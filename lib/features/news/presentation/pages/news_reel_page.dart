import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import '../widgets/news_reel_item.dart';
import '../../../../core/constants/app_constants.dart';

/// News Reel Page - A TikTok-like vertical scrolling interface for news articles
///
/// This page displays news articles in a vertical PageView format,
/// allowing users to swipe up/down to navigate between articles.
class NewsReelPage extends StatefulWidget {
  const NewsReelPage({super.key});

  @override
  State<NewsReelPage> createState() => _NewsReelPageState();
}

class _NewsReelPageState extends State<NewsReelPage> {
  final PageController _pageController = PageController();
  final NewsController _newsController = Get.find<NewsController>();

  int _currentIndex = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Set up scroll listener for pagination
  void _setupScrollListener() {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        _loadMoreIfNeeded();
      }
    });
  }

  /// Load more articles when approaching the end
  void _loadMoreIfNeeded() {
    if (!_isLoadingMore && _newsController.hasMoreData) {
      setState(() {
        _isLoadingMore = true;
      });

      _newsController.loadMoreArticles().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  /// Handle page change
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            'Error loading news',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _newsController.refreshArticles(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article_outlined, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            'No news articles found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or check your internet connection',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _newsController.refreshArticles(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        // Show loading state
        if (_newsController.isLoading && _newsController.articles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        // Show error state
        if (_newsController.errorMessage.isNotEmpty &&
            _newsController.articles.isEmpty) {
          return _buildErrorWidget(_newsController.errorMessage);
        }

        // Show empty state
        if (_newsController.articles.isEmpty) {
          return _buildEmptyState();
        }

        // Show news reel
        return Stack(
          children: [
            // Main PageView
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount:
                  _newsController.articles.length +
                  (_newsController.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the end
                if (index >= _newsController.articles.length) {
                  return _buildLoadingIndicator();
                }

                final article = _newsController.articles[index];
                return NewsReelItem(
                  article: article,
                  onBookmark: () => _newsController.toggleBookmark(article.id),
                  onLike: () => _newsController.toggleLike(article.id),
                  onShare: () => _newsController.shareArticle(article.id),
                );
              },
            ),

            // Loading overlay for refresh
            if (_newsController.isLoading &&
                _newsController.articles.isNotEmpty)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
