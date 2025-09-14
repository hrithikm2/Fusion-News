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
      c.startBroadcast(
        widget.channelName,
        token: widget.token,
        uid: widget.uid,
      );
    } else {
      c.joinAsViewer(widget.channelName, token: widget.token, uid: widget.uid);
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
        child: widget.isBroadcasting
            ? const LiveStreamBroadcaster()
            : const LiveStreamViewer(),
      ),
    );
  }
}
