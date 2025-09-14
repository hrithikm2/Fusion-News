import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';

/// Agora RTC Service for live streaming functionality
///
/// This service handles Agora RTC engine initialization and channel management
/// using App ID only mode for simplified authentication.
///
/// Authentication Mode:
/// - Uses App ID only mode (no tokens required)
/// - Primary Certificate must be disabled in Agora Console
/// - Passes empty string ("") as token parameter in joinChannel()
/// - Suitable for development and testing environments

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  RtcEngine? _engine;
  bool _initialized = false;
  bool _joined = false;

  String? _channel;
  int _localUid = 0; // 0 lets Agora assign; you can pass a fixed UID if needed.

  // Exposed streams
  final _isJoinedCtrl = StreamController<bool>.broadcast();
  final _userJoinedCtrl = StreamController<int>.broadcast();
  final _userOfflineCtrl = StreamController<int>.broadcast();
  final _connectionStateCtrl =
      StreamController<ConnectionStateType>.broadcast();
  final _initializedCtrl = StreamController<bool>.broadcast();
  final _previewCtrl = StreamController<bool>.broadcast();

  Stream<bool> get isJoined$ => _isJoinedCtrl.stream;
  Stream<int> get userJoined$ => _userJoinedCtrl.stream;
  Stream<int> get userOffline$ => _userOfflineCtrl.stream;
  Stream<ConnectionStateType> get connectionState$ =>
      _connectionStateCtrl.stream;
  Stream<bool> get initialized$ => _initializedCtrl.stream;
  Stream<bool> get preview$ => _previewCtrl.stream;

  RtcEngine? get engine => _engine;
  bool get isInitialized => _initialized;
  bool get isJoined => _joined;
  String? get currentChannel => _channel;
  int get localUid => _localUid;

  Future<void> _ensurePermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      throw LiveStreamFailure(message: 'Camera/Mic permissions not granted');
    }
  }

  Future<void> initialize({required String appId}) async {
    if (_initialized) return;
    // Create + initialize engine (6.x API)
    final eng = createAgoraRtcEngine();
    await eng.initialize(RtcEngineContext(appId: appId));

    // Basic config
    await eng.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await eng.enableVideo();
    await eng.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 720, height: 1280),
        frameRate: 30,
        bitrate: 1130, // good mobile default; adjust as needed
        orientationMode: OrientationMode.orientationModeFixedPortrait,
      ),
    );

    // Event handlers
    eng.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection conn, int elapsed) {
          _joined = true;
          _isJoinedCtrl.add(true);
        },
        onLeaveChannel: (RtcConnection conn, RtcStats stats) {
          _joined = false;
          _isJoinedCtrl.add(false);
        },
        onUserJoined: (RtcConnection conn, int remoteUid, int elapsed) {
          _userJoinedCtrl.add(remoteUid);
        },
        onUserOffline:
            (RtcConnection conn, int remoteUid, UserOfflineReasonType reason) {
              _userOfflineCtrl.add(remoteUid);
            },
        onConnectionStateChanged:
            (
              RtcConnection conn,
              ConnectionStateType state,
              ConnectionChangedReasonType reason,
            ) {
              _connectionStateCtrl.add(state);
            },
        // Token renewal not needed in App ID only mode
        onError: (ErrorCodeType err, String msg) {
          // Surface via connection state instead of throwing
          _connectionStateCtrl.add(ConnectionStateType.connectionStateFailed);
          // Log the error for debugging
          print('Agora error: $msg (${err.value})');
        },
        onLocalVideoStateChanged:
            (
              VideoSourceType source,
              LocalVideoStreamState state,
              LocalVideoStreamReason reason,
            ) {
              // Debug logging for video state changes
              print(
                'LocalVideoState: source=$source state=$state reason=$reason',
              );
            },
      ),
    );

    _engine = eng;
    _initialized = true;
    _initializedCtrl.add(true); // notify UI that engine is ready
  }

  /// Join as Broadcaster or Audience
  Future<void> join({
    required String channel,
    required RTCClientRole role,
    int? uid,
  }) async {
    await _ensurePermissions();
    await initialize(appId: AppConstants.agoraAppId);

    _channel = channel;
    _localUid = uid ?? 0;

    final eng = _engine!;

    // Set role BEFORE preview/join
    await eng.setClientRole(
      role: role == RTCClientRole.broadcaster
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
    );

    // Only broadcasters preview & publish
    final isHost = role == RTCClientRole.broadcaster;
    if (isHost) {
      await eng.startPreview(); // important: do this before join
      _previewCtrl.add(true); // notify UI that camera preview is ready
    }

    await eng.joinChannel(
      token: "", // App ID only mode - no token needed
      channelId: _channel!,
      uid: _localUid,
      options: ChannelMediaOptions(
        publishCameraTrack: isHost,
        publishMicrophoneTrack: isHost,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> leave() async {
    if (_engine == null) return;
    try {
      await _engine!.leaveChannel();
      await _engine!.stopPreview();
      _previewCtrl.add(false); // notify UI that preview stopped
    } finally {
      _joined = false;
      _channel = null;
      // We intentionally DO NOT destroy engine here to speed re-joins.
      // Use dispose() at controller/widget tear-down if you truly leave the feature.
    }
  }

  Future<void> dispose() async {
    try {
      await leave();
    } catch (_) {}
    if (_engine != null) {
      await _engine!.release();
      _engine = null;
    }
    _initialized = false;

    // Do not close the stream controllers here (service is a singleton);
    // let the app lifecycle own them or expose a separate close() if needed.
  }

  /// Video view controllers (hook these into your widgets)
  VideoViewController localVideoController() {
    final eng = _engine;
    if (eng == null) {
      // Never called now (widget waits), but keep a guard.
      throw LiveStreamFailure(message: 'Engine is not initialized yet');
    }
    return VideoViewController(
      rtcEngine: eng,
      canvas: const VideoCanvas(uid: 0), // local uid is 0 by default
    );
  }

  VideoViewController remoteVideoController({required int uid}) {
    final eng = _engine;
    if (eng == null) {
      throw LiveStreamFailure(message: 'Engine is not initialized');
    }
    if (_channel == null) {
      throw LiveStreamFailure(message: 'No active channel');
    }
    return VideoViewController.remote(
      rtcEngine: eng,
      connection: RtcConnection(channelId: _channel!), // required in v6
      canvas: VideoCanvas(uid: uid),
    );
  }
}

/// Simple role enum to decouple from SDK outside this file
enum RTCClientRole { broadcaster, audience }
