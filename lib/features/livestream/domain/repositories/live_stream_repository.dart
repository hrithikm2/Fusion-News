import '../entities/live_stream.dart';

/// Abstract repository for live stream operations
///
/// This defines the contract for live stream data operations
/// without specifying the implementation details.
abstract class LiveStreamRepository {
  /// Get a list of live streams
  ///
  /// [page] - The page number (starts from 1)
  /// [pageSize] - Number of streams per page
  /// [category] - Optional category filter
  /// Returns a list of LiveStream entities
  Future<List<LiveStream>> getLiveStreams({
    int page = 1,
    int pageSize = 20,
    String? category,
  });

  /// Get a specific live stream by ID
  ///
  /// [id] - The unique identifier of the stream
  /// Returns the LiveStream entity or null if not found
  Future<LiveStream?> getLiveStreamById(String id);

  /// Get currently live streams
  ///
  /// [limit] - Maximum number of streams to return
  /// Returns a list of currently live LiveStream entities
  Future<List<LiveStream>> getCurrentlyLiveStreams({int limit = 10});

  /// Start a new live stream
  ///
  /// [title] - The title of the stream
  /// [description] - The description of the stream
  /// [categories] - List of categories for the stream
  /// Returns the created LiveStream entity
  Future<LiveStream> startLiveStream({
    required String title,
    required String description,
    required List<String> categories,
  });

  /// End a live stream
  ///
  /// [streamId] - The ID of the stream to end
  /// Returns true if successful, false otherwise
  Future<bool> endLiveStream(String streamId);

  /// Join a live stream as a viewer
  ///
  /// [streamId] - The ID of the stream to join
  /// Returns the stream details and connection info
  Future<Map<String, dynamic>> joinLiveStream(String streamId);

  /// Leave a live stream
  ///
  /// [streamId] - The ID of the stream to leave
  /// Returns true if successful, false otherwise
  Future<bool> leaveLiveStream(String streamId);

  /// Update stream viewer count
  ///
  /// [streamId] - The ID of the stream
  /// [viewerCount] - The new viewer count
  /// Returns true if successful, false otherwise
  Future<bool> updateViewerCount(String streamId, int viewerCount);

  /// Get stream analytics
  ///
  /// [streamId] - The ID of the stream
  /// Returns analytics data for the stream
  Future<Map<String, dynamic>> getStreamAnalytics(String streamId);

  /// Report a stream
  ///
  /// [streamId] - The ID of the stream to report
  /// [reason] - The reason for reporting
  /// [description] - Additional description
  /// Returns true if successful, false otherwise
  Future<bool> reportStream({
    required String streamId,
    required String reason,
    String? description,
  });
}
