import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../data/datasources/agora_service.dart';

/// Widget for displaying the broadcaster's local video preview
class LiveStreamBroadcaster extends StatelessWidget {
  const LiveStreamBroadcaster({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = AgoraService();

    return StreamBuilder<bool>(
      // Rebuild when the engine finishes init OR preview starts
      stream: svc.initialized$, // primary trigger
      initialData: svc.isInitialized,
      builder: (context, initSnap) {
        final initialized = initSnap.data ?? false;
        if (!initialized) {
          return const Center(
            child: Text(
              'Starting camera...',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Optional: also wait for preview to turn on
        return StreamBuilder<bool>(
          stream: svc.preview$,
          initialData:
              true, // preview usually starts right after init+join for host
          builder: (context, prevSnap) {
            final previewOn = prevSnap.data ?? false;
            if (!previewOn) {
              return const Center(
                child: Text(
                  'Starting camera...',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return AgoraVideoView(controller: svc.localVideoController());
          },
        );
      },
    );
  }
}
