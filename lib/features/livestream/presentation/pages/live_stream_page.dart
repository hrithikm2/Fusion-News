import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_stream_controller.dart';
import '../widgets/live_stream_viewer.dart';
import '../widgets/live_stream_broadcaster.dart';

class LiveStreamPage extends StatefulWidget {
  final String channelName; // <-- make this explicit
  final bool isBroadcasting;
  final String? token;
  final int? uid;
  const LiveStreamPage({
    super.key,
    required this.channelName,
    this.isBroadcasting = false,
    this.token,
    this.uid,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late final LiveStreamController c;

  @override
  void initState() {
    super.initState();
    c = Get.find<LiveStreamController>();
    if (widget.isBroadcasting) {
      c.startBroadcast(widget.channelName, uid: widget.uid);
    } else {
      c.joinAsViewer(widget.channelName, uid: widget.uid);
    }
  }

  @override
  void dispose() {
    c.leave(); // also disposes engine in controller.onClose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            widget.isBroadcasting
                ? const LiveStreamBroadcaster()
                : const LiveStreamViewer(),

            // End button overlay
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () => _showEndStreamDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stop, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            widget.isBroadcasting ? 'End Stream' : 'Leave',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEndStreamDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            widget.isBroadcasting ? 'End Stream?' : 'Leave Stream?',
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            widget.isBroadcasting
                ? 'Are you sure you want to end this live stream?'
                : 'Are you sure you want to leave this stream?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _endStream();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.isBroadcasting ? 'End Stream' : 'Leave'),
            ),
          ],
        );
      },
    );
  }

  void _endStream() {
    c.leave();
    Navigator.of(context).pop(); // Go back to previous screen
  }
}
