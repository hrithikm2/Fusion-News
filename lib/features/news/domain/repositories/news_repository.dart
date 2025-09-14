import '../entities/news_article.dart';

/// Abstract repository for news operations
///
/// This defines the contract for news data operations
/// without specifying the implementation details.
abstract class NewsRepository {
  /// Get a list of news articles with pagination
  ///
  /// [page] - The page number (starts from 1)
  /// [pageSize] - Number of articles per page
  /// [category] - Optional category filter
  /// Returns a list of NewsArticle entities
  Future<List<NewsArticle>> getNewsArticles({
    int page = 1,
    int pageSize = 20,
    String? category,
  });

  /// Get a specific news article by ID
  ///
  /// [id] - The unique identifier of the article
  /// Returns the NewsArticle entity or null if not found
  Future<NewsArticle?> getNewsArticleById(String id);

  /// Search news articles by query
  ///
  /// [query] - The search term
  /// [page] - The page number (starts from 1)
  /// [pageSize] - Number of articles per page
  /// Returns a list of matching NewsArticle entities
  Future<List<NewsArticle>> searchNewsArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  /// Get trending news articles
  ///
  /// [limit] - Maximum number of articles to return
  /// Returns a list of trending NewsArticle entities
  Future<List<NewsArticle>> getTrendingNews({int limit = 10});

  /// Bookmark or unbookmark a news article
  ///
  /// [articleId] - The ID of the article to bookmark/unbookmark
  /// [isBookmarked] - Whether to bookmark (true) or unbookmark (false)
  /// Returns true if successful, false otherwise
  Future<bool> toggleBookmark(String articleId, bool isBookmarked);

  /// Get bookmarked news articles
  ///
  /// Returns a list of bookmarked NewsArticle entities
  Future<List<NewsArticle>> getBookmarkedArticles();

  /// Like or unlike a news article
  ///
  /// [articleId] - The ID of the article to like/unlike
  /// [isLiked] - Whether to like (true) or unlike (false)
  /// Returns true if successful, false otherwise
  Future<bool> toggleLike(String articleId, bool isLiked);

  /// Share a news article
  ///
  /// [articleId] - The ID of the article to share
  /// Returns true if successful, false otherwise
  Future<bool> shareArticle(String articleId);
}
