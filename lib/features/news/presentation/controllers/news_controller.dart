import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../../../core/errors/failures.dart';

/// GetX controller for managing news state
///
/// This controller handles all news-related operations including
/// fetching articles, searching, bookmarking, and managing UI state.
class NewsController extends GetxController {
  final NewsRepository _newsRepository;

  NewsController({required NewsRepository newsRepository})
    : _newsRepository = newsRepository;

  // Observable state variables
  final RxList<NewsArticle> _articles = <NewsArticle>[].obs;
  final RxList<NewsArticle> _trendingArticles = <NewsArticle>[].obs;
  final RxList<NewsArticle> _bookmarkedArticles = <NewsArticle>[].obs;
  final RxList<NewsArticle> _searchResults = <NewsArticle>[].obs;

  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _isSearching = false.obs;
  final RxBool _isLoadingTrending = false.obs;
  final RxBool _isLoadingBookmarks = false.obs;

  final RxString _errorMessage = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = ''.obs;

  final RxInt _currentPage = 1.obs;
  final RxBool _hasMoreData = true.obs;

  // Getters
  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get trendingArticles => _trendingArticles;
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;
  List<NewsArticle> get searchResults => _searchResults;

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isSearching => _isSearching.value;
  bool get isLoadingTrending => _isLoadingTrending.value;
  bool get isLoadingBookmarks => _isLoadingBookmarks.value;

  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;

  int get currentPage => _currentPage.value;
  bool get hasMoreData => _hasMoreData.value;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  /// Load initial data (trending articles and first page of articles)
  Future<void> loadInitialData() async {
    await Future.wait([loadTrendingNews(), loadNewsArticles()]);
  }

  /// Load news articles with pagination
  Future<void> loadNewsArticles({
    bool refresh = false,
    String? category,
  }) async {
    try {
      if (refresh) {
        _currentPage.value = 1;
        _hasMoreData.value = true;
        _articles.clear();
        _isLoading.value = true;
      } else {
        _isLoadingMore.value = true;
      }

      _errorMessage.value = '';

      final newArticles = await _newsRepository.getNewsArticles(
        page: _currentPage.value,
        pageSize: 20,
        category:
            category ??
            ((_selectedCategory.value.isEmpty)
                ? null
                : _selectedCategory.value),
      );

      if (refresh) {
        _articles.assignAll(newArticles);
      } else {
        _articles.addAll(newArticles);
      }

      if (newArticles.length < 20) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'An unexpected error occurred: $e';
    } finally {
      _isLoading.value = false;
      _isLoadingMore.value = false;
    }
  }

  /// Load more articles (pagination)
  Future<void> loadMoreArticles() async {
    if (!_hasMoreData.value || _isLoadingMore.value) return;
    await loadNewsArticles();
  }

  /// Refresh articles
  Future<void> refreshArticles() async {
    await loadNewsArticles(refresh: true);
  }

  /// Load trending news articles
  Future<void> loadTrendingNews() async {
    try {
      _isLoadingTrending.value = true;
      _errorMessage.value = '';

      final trending = await _newsRepository.getTrendingNews(limit: 10);
      _trendingArticles.assignAll(trending);
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Failed to load trending news: $e';
    } finally {
      _isLoadingTrending.value = false;
    }
  }

  /// Search news articles
  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _searchQuery.value = '';
      return;
    }

    try {
      _isSearching.value = true;
      _searchQuery.value = query;
      _errorMessage.value = '';

      final results = await _newsRepository.searchNewsArticles(
        query: query,
        page: 1,
        pageSize: 50,
      );

      _searchResults.assignAll(results);
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Search failed: $e';
    } finally {
      _isSearching.value = false;
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults.clear();
    _searchQuery.value = '';
  }

  /// Filter articles by category
  Future<void> filterByCategory(String category) async {
    _selectedCategory.value = category;
    await loadNewsArticles(refresh: true, category: category);
  }

  /// Clear category filter
  Future<void> clearCategoryFilter() async {
    _selectedCategory.value = '';
    await loadNewsArticles(refresh: true);
  }

  /// Toggle bookmark for an article
  Future<void> toggleBookmark(String articleId) async {
    try {
      final article = _articles.firstWhereOrNull((a) => a.id == articleId);
      if (article == null) return;

      final newBookmarkStatus = !article.isBookmarked;
      final success = await _newsRepository.toggleBookmark(
        articleId,
        newBookmarkStatus,
      );

      if (success) {
        final updatedArticle = article.copyWith(
          isBookmarked: newBookmarkStatus,
        );
        final index = _articles.indexWhere((a) => a.id == articleId);
        if (index != -1) {
          _articles[index] = updatedArticle;
        }

        // Update in other lists if present
        _updateArticleInList(_trendingArticles, updatedArticle);
        _updateArticleInList(_searchResults, updatedArticle);
        _updateArticleInList(_bookmarkedArticles, updatedArticle);

        // Refresh bookmarked articles if needed
        if (newBookmarkStatus) {
          await loadBookmarkedArticles();
        }
      }
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Failed to update bookmark: $e';
    }
  }

  /// Load bookmarked articles
  Future<void> loadBookmarkedArticles() async {
    try {
      _isLoadingBookmarks.value = true;
      _errorMessage.value = '';

      final bookmarked = await _newsRepository.getBookmarkedArticles();
      _bookmarkedArticles.assignAll(bookmarked);
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Failed to load bookmarked articles: $e';
    } finally {
      _isLoadingBookmarks.value = false;
    }
  }

  /// Toggle like for an article (just tracks like status, doesn't increment counter)
  Future<void> toggleLike(String articleId) async {
    try {
      final article = _articles.firstWhereOrNull((a) => a.id == articleId);
      if (article == null) return;

      // Just track the like status locally, don't increment the counter
      // The counter should reflect the actual server-side count
      await _newsRepository.toggleLike(articleId, true);

      // You could add a local like status tracking here if needed
      // For now, we'll just show a success message
      Get.snackbar(
        'Liked',
        'Article liked successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Failed to like article: $e';
    }
  }

  /// Share an article using share_plus
  Future<void> shareArticle(String articleId) async {
    try {
      final article = _articles.firstWhereOrNull((a) => a.id == articleId);
      if (article == null) return;

      // Use share_plus to share the article
      await _shareArticleContent(article);

      // Track the share action (but don't increment counter locally)
      await _newsRepository.shareArticle(articleId);
    } on Failure catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Failed to share article: $e';
    }
  }

  /// Share article content using share_plus
  Future<void> _shareArticleContent(NewsArticle article) async {
    try {
      final shareText =
          '''
${article.title}

${article.description}

Read more: ${article.url}

Shared via Fusion News
''';

      await Share.share(shareText, subject: article.title);
    } catch (e) {
      throw Exception('Failed to share article: $e');
    }
  }

  /// Get a specific article by ID
  NewsArticle? getArticleById(String id) {
    return _articles.firstWhereOrNull((article) => article.id == id);
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }

  /// Helper method to update article in a list
  void _updateArticleInList(
    RxList<NewsArticle> list,
    NewsArticle updatedArticle,
  ) {
    final index = list.indexWhere((a) => a.id == updatedArticle.id);
    if (index != -1) {
      list[index] = updatedArticle;
    }
  }
}
