import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../models/news_article_model.dart';

/// Abstract local data source for news
///
/// This defines the contract for storing and retrieving news data locally
abstract class NewsLocalDataSource {
  /// Cache news articles locally
  Future<void> cacheNewsArticles(List<NewsArticleModel> articles);

  /// Get cached news articles
  Future<List<NewsArticleModel>> getCachedNewsArticles();

  /// Cache a specific news article
  Future<void> cacheNewsArticle(NewsArticleModel article);

  /// Get a cached news article by ID
  Future<NewsArticleModel?> getCachedNewsArticleById(String id);

  /// Cache bookmarked articles
  Future<void> cacheBookmarkedArticles(List<String> articleIds);

  /// Get cached bookmarked article IDs
  Future<List<String>> getCachedBookmarkedArticles();

  /// Cache liked articles
  Future<void> cacheLikedArticles(List<String> articleIds);

  /// Get cached liked article IDs
  Future<List<String>> getCachedLikedArticles();

  /// Clear all cached data
  Future<void> clearCache();
}

/// Implementation of NewsLocalDataSource using SharedPreferences
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences _prefs;

  NewsLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _cachedNewsKey = 'CACHED_NEWS_ARTICLES';
  static const String _cachedArticleKey = 'CACHED_ARTICLE_';
  static const String _bookmarkedArticlesKey = 'BOOKMARKED_ARTICLES';
  static const String _likedArticlesKey = 'LIKED_ARTICLES';

  @override
  Future<void> cacheNewsArticles(List<NewsArticleModel> articles) async {
    try {
      final articlesJson = articles.map((article) => article.toJson()).toList();
      await _prefs.setString(_cachedNewsKey, jsonEncode(articlesJson));
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache news articles: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getCachedNewsArticles() async {
    try {
      final cachedData = _prefs.getString(_cachedNewsKey);
      if (cachedData != null) {
        final List<dynamic> articlesJson = jsonDecode(cachedData);
        return articlesJson
            .map((json) => NewsArticleModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheFailure(message: 'Failed to get cached news articles: $e');
    }
  }

  @override
  Future<void> cacheNewsArticle(NewsArticleModel article) async {
    try {
      final articleJson = jsonEncode(article.toJson());
      await _prefs.setString('$_cachedArticleKey${article.id}', articleJson);
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache news article: $e');
    }
  }

  @override
  Future<NewsArticleModel?> getCachedNewsArticleById(String id) async {
    try {
      final cachedData = _prefs.getString('$_cachedArticleKey$id');
      if (cachedData != null) {
        final Map<String, dynamic> articleJson = jsonDecode(cachedData);
        return NewsArticleModel.fromJson(articleJson);
      }
      return null;
    } catch (e) {
      throw CacheFailure(message: 'Failed to get cached news article: $e');
    }
  }

  @override
  Future<void> cacheBookmarkedArticles(List<String> articleIds) async {
    try {
      await _prefs.setStringList(_bookmarkedArticlesKey, articleIds);
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache bookmarked articles: $e');
    }
  }

  @override
  Future<List<String>> getCachedBookmarkedArticles() async {
    try {
      return _prefs.getStringList(_bookmarkedArticlesKey) ?? [];
    } catch (e) {
      throw CacheFailure(
        message: 'Failed to get cached bookmarked articles: $e',
      );
    }
  }

  @override
  Future<void> cacheLikedArticles(List<String> articleIds) async {
    try {
      await _prefs.setStringList(_likedArticlesKey, articleIds);
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache liked articles: $e');
    }
  }

  @override
  Future<List<String>> getCachedLikedArticles() async {
    try {
      return _prefs.getStringList(_likedArticlesKey) ?? [];
    } catch (e) {
      throw CacheFailure(message: 'Failed to get cached liked articles: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
