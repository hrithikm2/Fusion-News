import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../controllers/live_stream_controller.dart';
import '../../data/datasources/agora_service.dart';

class LiveStreamViewer extends StatefulWidget {
  const LiveStreamViewer({super.key});
  @override
  State<LiveStreamViewer> createState() => _LiveStreamViewerState();
}

class _LiveStreamViewerState extends State<LiveStreamViewer> {
  final c = Get.find<LiveStreamController>();

  @override
  Widget build(BuildContext context) {
    final agora = Get.find<AgoraService>();
    return Obx(() {
      if (!c.isJoined.value) {
        return const Center(child: Text('Joining stream…'));
      }
      if (c.remoteUids.isEmpty) {
        return const Center(child: Text('Waiting for host…'));
      }
      // Render first remote by default; expand to grid if you expect multiples
      final uid = c.remoteUids.first;
      return Stack(
        fit: StackFit.expand,
        children: [
          AgoraVideoView(controller: agora.remoteVideoController(uid: uid)),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
