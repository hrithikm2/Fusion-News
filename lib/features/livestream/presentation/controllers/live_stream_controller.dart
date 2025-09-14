import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/live_stream_repository.dart';
import '../../data/datasources/agora_service.dart';
import '../../../../core/errors/failures.dart';

class LiveStreamController extends GetxController {
  final LiveStreamRepository _repo;
  final AgoraService _agora;

  LiveStreamController({
    required LiveStreamRepository liveStreamRepository,
    required AgoraService agoraService,
  }) : _repo = liveStreamRepository,
       _agora = agoraService;

  // Reactive state
  final isLoading = false.obs;
  final isJoined = false.obs;
  final remoteUids = <int>[].obs;

  StreamSubscription? _joinSub, _userJoinSub, _userOffSub, _connSub;

  @override
  void onInit() {
    super.onInit();
    _joinSub = _agora.isJoined$.listen((v) => isJoined.value = v);
    _userJoinSub = _agora.userJoined$.listen((uid) {
      if (!remoteUids.contains(uid)) remoteUids.add(uid);
    });
    _userOffSub = _agora.userOffline$.listen((uid) {
      remoteUids.remove(uid);
    });
    _connSub = _agora.connectionState$.listen((_) {});
  }

  Future<void> startBroadcast(String channel, {int? uid}) async {
    try {
      isLoading.value = true;
      await _agora.join(
        channel: channel,
        role: RTCClientRole.broadcaster,
        uid: uid,
      );
    } on LiveStreamFailure catch (e) {
      Get.snackbar('Live', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinAsViewer(String channel, {int? uid}) async {
    try {
      isLoading.value = true;
      await _agora.join(
        channel: channel,
        role: RTCClientRole.audience,
        uid: uid,
      );
    } on LiveStreamFailure catch (e) {
      Get.snackbar('Live', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> leave() => _agora.leave();

  // Repository getter for future use
  LiveStreamRepository get repository => _repo;

  @override
  void onClose() {
    _joinSub?.cancel();
    _userJoinSub?.cancel();
    _userOffSub?.cancel();
    _connSub?.cancel();
    // Fully release engine when leaving the feature
    _agora.dispose();
    super.onClose();
  }
}
