import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../controllers/live_stream_controller.dart';
import '../../data/datasources/agora_service.dart';

class LiveStreamBroadcaster extends StatefulWidget {
  const LiveStreamBroadcaster({super.key});
  @override
  State<LiveStreamBroadcaster> createState() => _LiveStreamBroadcasterState();
}

class _LiveStreamBroadcasterState extends State<LiveStreamBroadcaster> {
  final c = Get.find<LiveStreamController>();

  @override
  Widget build(BuildContext context) {
    final agora = Get.find<AgoraService>();
    return Obx(() {
      if (!c.isJoined.value) {
        return const Center(child: Text('Starting camera…'));
      }
      return Stack(
        fit: StackFit.expand,
        children: [
          // Local preview
          AgoraVideoView(controller: agora.localVideoController()),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircleBtn(
                  icon: Icons.cameraswitch,
                  onTap: () {
                    agora.engine?.switchCamera();
                  },
                ),
                _CircleBtn(
                  icon: Icons.mic_off,
                  onTap: () async {
                    final eng = agora.engine;
                    if (eng == null) return;
                    // simple toggle
                    // In real app track mic state in controller
                    await eng.muteLocalAudioStream(true);
                  },
                ),
                _CircleBtn(
                  icon: Icons.call_end,
                  bg: Colors.red,
                  onTap: c.leave,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? bg;
  const _CircleBtn({required this.icon, required this.onTap, this.bg});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: bg ?? Colors.black54,
      child: Icon(icon, color: Colors.white),
    ),
  );
}
