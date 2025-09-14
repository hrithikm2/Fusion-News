import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../controllers/live_stream_controller.dart';
import '../../data/datasources/agora_service.dart';

/// Widget for displaying remote video streams from other users
class LiveStreamViewer extends GetView<LiveStreamController> {
  const LiveStreamViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = AgoraService();
    return Obx(() {
      final uids = controller.remoteUids; // your RxList<int>
      if (uids.isEmpty) {
        return const Center(
          child: Text(
            'Waiting for host…',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        children: [
          for (final uid in uids)
            Container(
              margin: const EdgeInsets.all(4),
              child: AgoraVideoView(
                controller: svc.remoteVideoController(
                  uid: uid,
                ), // uses .remote + connection
              ),
            ),
        ],
      );
    });
  }
}
