import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/news_article_model.dart';
import 'news_demo_datasource.dart';

/// Abstract remote data source for news
///
/// This defines the contract for fetching news data from remote sources
abstract class NewsRemoteDataSource {
  /// Get news articles from remote API
  Future<List<NewsArticleModel>> getNewsArticles({
    int page = 1,
    int pageSize = 20,
    String? category,
  });

  /// Get a specific news article by ID
  Future<NewsArticleModel?> getNewsArticleById(String id);

  /// Search news articles
  Future<List<NewsArticleModel>> searchNewsArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  /// Get trending news articles
  Future<List<NewsArticleModel>> getTrendingNews({int limit = 10});
}

/// Implementation of NewsRemoteDataSource using NewsAPI
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<NewsArticleModel>> getNewsArticles({
    int page = 1,
    int pageSize = 20,
    String? category,
  }) async {
    // Use demo data if API key is not configured
    if (AppConstants.apiKey == 'YOUR_NEWS_API_KEY') {
      final demoArticles = NewsDemoDataSource.getDemoArticles();
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      return demoArticles.sublist(
        startIndex.clamp(0, demoArticles.length),
        endIndex.clamp(0, demoArticles.length),
      );
    }

    try {
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'page': page,
          'pageSize': pageSize,
          if (category != null) 'category': category,
          'sortBy': 'publishedAt',
          'language': 'en',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles.map((json) => NewsArticleModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to fetch news articles',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(message: 'No internet connection');
      } else {
        throw ServerFailure(
          message: e.message ?? 'Unknown server error',
          code: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw UnexpectedFailure(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<NewsArticleModel?> getNewsArticleById(String id) async {
    try {
      // Since NewsAPI doesn't provide direct article by ID,
      // we'll search for it or return a mock implementation
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'q': id,
          'pageSize': 1,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        if (articles.isNotEmpty) {
          return NewsArticleModel.fromJson(articles.first);
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(message: 'No internet connection');
      } else {
        throw ServerFailure(
          message: e.message ?? 'Unknown server error',
          code: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw UnexpectedFailure(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> searchNewsArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'sortBy': 'relevancy',
          'language': 'en',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles.map((json) => NewsArticleModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to search news articles',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(message: 'No internet connection');
      } else {
        throw ServerFailure(
          message: e.message ?? 'Unknown server error',
          code: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw UnexpectedFailure(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getTrendingNews({int limit = 10}) async {
    // Use demo data if API key is not configured
    if (AppConstants.apiKey == 'YOUR_NEWS_API_KEY') {
      final demoArticles = NewsDemoDataSource.getDemoArticles();
      return demoArticles.take(limit).toList();
    }

    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'country': 'us',
          'pageSize': limit,
          'sortBy': 'popularity',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles.map((json) => NewsArticleModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          message: 'Failed to fetch trending news',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(message: 'No internet connection');
      } else {
        throw ServerFailure(
          message: e.message ?? 'Unknown server error',
          code: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw UnexpectedFailure(message: 'Unexpected error: $e');
    }
  }
}
