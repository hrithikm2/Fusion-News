import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_datasource.dart';
import '../datasources/news_remote_datasource.dart';

/// Implementation of NewsRepository
///
/// This class implements the NewsRepository interface and handles
/// the coordination between remote and local data sources.
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NewsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<List<NewsArticle>> getNewsArticles({
    int page = 1,
    int pageSize = 20,
    String? category,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        // Fetch from remote source
        final remoteArticles = await _remoteDataSource.getNewsArticles(
          page: page,
          pageSize: pageSize,
          category: category,
        );

        // Cache the articles locally
        await _localDataSource.cacheNewsArticles(remoteArticles);

        // Convert models to entities
        return remoteArticles.map((model) => model.toEntity()).toList();
      } else {
        // Return cached articles if no network
        final cachedArticles = await _localDataSource.getCachedNewsArticles();
        return cachedArticles.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      // Fallback to cached data on error
      try {
        final cachedArticles = await _localDataSource.getCachedNewsArticles();
        return cachedArticles.map((model) => model.toEntity()).toList();
      } catch (cacheError) {
        throw CacheFailure(message: 'Failed to load news articles: $e');
      }
    }
  }

  @override
  Future<NewsArticle?> getNewsArticleById(String id) async {
    try {
      if (await _networkInfo.isConnected) {
        // Try to fetch from remote source
        final remoteArticle = await _remoteDataSource.getNewsArticleById(id);
        if (remoteArticle != null) {
          // Cache the article locally
          await _localDataSource.cacheNewsArticle(remoteArticle);
          return remoteArticle.toEntity();
        }
      }

      // Fallback to cached data
      final cachedArticle = await _localDataSource.getCachedNewsArticleById(id);
      return cachedArticle?.toEntity();
    } catch (e) {
      throw CacheFailure(message: 'Failed to get news article: $e');
    }
  }

  @override
  Future<List<NewsArticle>> searchNewsArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        // Search from remote source
        final remoteArticles = await _remoteDataSource.searchNewsArticles(
          query: query,
          page: page,
          pageSize: pageSize,
        );

        // Cache the search results
        await _localDataSource.cacheNewsArticles(remoteArticles);

        // Convert models to entities
        return remoteArticles.map((model) => model.toEntity()).toList();
      } else {
        // Return cached articles if no network
        final cachedArticles = await _localDataSource.getCachedNewsArticles();
        // Filter cached articles by query (simple implementation)
        final filteredArticles = cachedArticles
            .where(
              (article) =>
                  article.title.toLowerCase().contains(query.toLowerCase()) ||
                  article.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
        return filteredArticles.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      throw CacheFailure(message: 'Failed to search news articles: $e');
    }
  }

  @override
  Future<List<NewsArticle>> getTrendingNews({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        // Fetch trending from remote source
        final remoteArticles = await _remoteDataSource.getTrendingNews(
          limit: limit,
        );

        // Cache the trending articles
        await _localDataSource.cacheNewsArticles(remoteArticles);

        // Convert models to entities
        return remoteArticles.map((model) => model.toEntity()).toList();
      } else {
        // Return cached articles if no network
        final cachedArticles = await _localDataSource.getCachedNewsArticles();
        return cachedArticles
            .take(limit)
            .map((model) => model.toEntity())
            .toList();
      }
    } catch (e) {
      throw CacheFailure(message: 'Failed to get trending news: $e');
    }
  }

  @override
  Future<bool> toggleBookmark(String articleId, bool isBookmarked) async {
    try {
      // Get current bookmarked articles
      final bookmarkedIds = await _localDataSource
          .getCachedBookmarkedArticles();

      if (isBookmarked) {
        // Add to bookmarks
        if (!bookmarkedIds.contains(articleId)) {
          bookmarkedIds.add(articleId);
        }
      } else {
        // Remove from bookmarks
        bookmarkedIds.remove(articleId);
      }

      // Update cached bookmarks
      await _localDataSource.cacheBookmarkedArticles(bookmarkedIds);

      // In a real app, you would also update the remote server
      // For now, we'll just return true for local operations
      return true;
    } catch (e) {
      throw CacheFailure(message: 'Failed to toggle bookmark: $e');
    }
  }

  @override
  Future<List<NewsArticle>> getBookmarkedArticles() async {
    try {
      // Get bookmarked article IDs
      final bookmarkedIds = await _localDataSource
          .getCachedBookmarkedArticles();

      // Get the actual articles
      final List<NewsArticle> bookmarkedArticles = [];
      for (final id in bookmarkedIds) {
        final article = await getNewsArticleById(id);
        if (article != null) {
          // Mark as bookmarked
          bookmarkedArticles.add(article.copyWith(isBookmarked: true));
        }
      }

      return bookmarkedArticles;
    } catch (e) {
      throw CacheFailure(message: 'Failed to get bookmarked articles: $e');
    }
  }

  @override
  Future<bool> toggleLike(String articleId, bool isLiked) async {
    try {
      // Get current liked articles
      final likedIds = await _localDataSource.getCachedLikedArticles();

      if (isLiked) {
        // Add to likes
        if (!likedIds.contains(articleId)) {
          likedIds.add(articleId);
        }
      } else {
        // Remove from likes
        likedIds.remove(articleId);
      }

      // Update cached likes
      await _localDataSource.cacheLikedArticles(likedIds);

      // In a real app, you would also update the remote server
      // For now, we'll just return true for local operations
      return true;
    } catch (e) {
      throw CacheFailure(message: 'Failed to toggle like: $e');
    }
  }

  @override
  Future<bool> shareArticle(String articleId) async {
    try {
      // In a real app, you would implement actual sharing functionality
      // For now, we'll just return true
      return true;
    } catch (e) {
      throw UnexpectedFailure(message: 'Failed to share article: $e');
    }
  }
}
