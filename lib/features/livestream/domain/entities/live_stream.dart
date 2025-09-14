/// Live Stream entity
///
/// This represents the core business object for live streams
/// in the domain layer. It contains only the essential data
/// without any external dependencies.
class LiveStream {
  final String id;
  final String title;
  final String description;
  final String hostId;
  final String hostName;
  final String hostAvatar;
  final String channelName;
  final String thumbnailUrl;
  final DateTime startTime;
  final DateTime? endTime;
  final LiveStreamStatus status;
  final int viewerCount;
  final int maxViewers;
  final List<String> categories;
  final bool isLive;
  final String? streamUrl;
  final Map<String, dynamic> metadata;

  const LiveStream({
    required this.id,
    required this.title,
    required this.description,
    required this.hostId,
    required this.hostName,
    required this.hostAvatar,
    required this.channelName,
    required this.thumbnailUrl,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.viewerCount,
    required this.maxViewers,
    required this.categories,
    required this.isLive,
    this.streamUrl,
    this.metadata = const {},
  });

  /// Create a copy of this live stream with updated fields
  LiveStream copyWith({
    String? id,
    String? title,
    String? description,
    String? hostId,
    String? hostName,
    String? hostAvatar,
    String? channelName,
    String? thumbnailUrl,
    DateTime? startTime,
    DateTime? endTime,
    LiveStreamStatus? status,
    int? viewerCount,
    int? maxViewers,
    List<String>? categories,
    bool? isLive,
    String? streamUrl,
    Map<String, dynamic>? metadata,
  }) {
    return LiveStream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostAvatar: hostAvatar ?? this.hostAvatar,
      channelName: channelName ?? this.channelName,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      viewerCount: viewerCount ?? this.viewerCount,
      maxViewers: maxViewers ?? this.maxViewers,
      categories: categories ?? this.categories,
      isLive: isLive ?? this.isLive,
      streamUrl: streamUrl ?? this.streamUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get the duration of the stream
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Check if the stream is currently active
  bool get isActive => isLive && status == LiveStreamStatus.live;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiveStream && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LiveStream(id: $id, title: $title, hostName: $hostName, status: $status, isLive: $isLive)';
  }
}

/// Enum representing the status of a live stream
enum LiveStreamStatus { scheduled, live, ended, cancelled, error }

/// Extension to get string representation of LiveStreamStatus
extension LiveStreamStatusExtension on LiveStreamStatus {
  String get displayName {
    switch (this) {
      case LiveStreamStatus.scheduled:
        return 'Scheduled';
      case LiveStreamStatus.live:
        return 'Live';
      case LiveStreamStatus.ended:
        return 'Ended';
      case LiveStreamStatus.cancelled:
        return 'Cancelled';
      case LiveStreamStatus.error:
        return 'Error';
    }
  }
}
