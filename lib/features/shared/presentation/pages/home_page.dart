import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../news/presentation/controllers/news_controller.dart';
import '../../../livestream/presentation/controllers/live_stream_controller.dart';

/// Home Page - Main navigation hub of the application
///
/// This page provides access to all major features including
/// news reel and live streaming functionality.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Ensure news data is loaded when home page is accessed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsController = Get.find<NewsController>();
      // Always try to load initial data if articles are empty
      if (newsController.articles.isEmpty) {
        newsController.loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32),

              // Main features
              _buildNewsReelSection(),

              const SizedBox(height: 32),

              // Live Stream Section
              _buildLiveStreamSection(),

              const SizedBox(height: 32),

              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppConstants.appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Stay informed with the latest news and live streams',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Build news reel section
  Widget _buildNewsReelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'News Reel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.newsReel),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNewsReelPreview(),
      ],
    );
  }

  /// Build news reel preview
  Widget _buildNewsReelPreview() {
    final newsController = Get.find<NewsController>();

    return Obx(() {
      // Show loading state only if we have no articles and are loading
      if (newsController.isLoading && newsController.articles.isEmpty) {
        return _buildLoadingCard();
      }

      // If no articles, show loading (data should be loading from initState)
      if (newsController.articles.isEmpty) {
        return _buildLoadingCard();
      }

      // If we have articles but they're all invalid, show a fallback
      final validArticles = newsController.articles
          .where(
            (article) => article.title.isNotEmpty && article.source.isNotEmpty,
          )
          .toList();

      if (validArticles.isEmpty) {
        return _buildEmptyCard('No valid news articles available');
      }

      // Show articles in PageView
      return SizedBox(
        height: 200,
        child: PageView.builder(
          itemCount: validArticles.take(5).length,
          itemBuilder: (context, index) {
            final article = validArticles[index];
            return _buildNewsPreviewCard(article);
          },
        ),
      );
    });
  }

  /// Build news preview card
  Widget _buildNewsPreviewCard(dynamic article) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.newsDetail, arguments: article),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[900],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              if (article.imageUrl.isNotEmpty)
                Positioned.fill(
                  child: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 48,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.article,
                    color: Colors.grey,
                    size: 48,
                  ),
                ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        article.title.isNotEmpty
                            ? article.title
                            : 'No title available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.source.isNotEmpty
                            ? article.source
                            : 'Unknown Source',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build live stream section
  Widget _buildLiveStreamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Live Streams',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.liveStream),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLiveStreamPreview(),
      ],
    );
  }

  /// Build live stream preview
  Widget _buildLiveStreamPreview() {
    final liveStreamController = Get.find<LiveStreamController>();

    return Obx(() {
      if (liveStreamController.isLoading.value &&
          liveStreamController.remoteUids.isEmpty) {
        return _buildLoadingCard();
      }

      if (liveStreamController.remoteUids.isEmpty) {
        return _buildEmptyCard('No live streams available');
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: liveStreamController.remoteUids.take(3).length,
          itemBuilder: (context, index) {
            final stream = liveStreamController.remoteUids[index];
            return _buildLiveStreamPreviewCard(stream);
          },
        ),
      );
    });
  }

  /// Build live stream preview card
  Widget _buildLiveStreamPreviewCard(dynamic stream) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.liveStream, arguments: stream.id),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(stream.thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${stream.viewerCount}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                stream.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.videocam,
                title: 'Start Live',
                subtitle: 'Go live now',
                onTap: () => Get.toNamed(AppRoutes.startLiveStream),
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.article,
                title: 'Read News',
                subtitle: 'Browse articles',
                onTap: () => Get.toNamed(AppRoutes.newsReel),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build quick action card
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading card
  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }

  /// Build empty card
  Widget _buildEmptyCard(String message) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white70, size: 32),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
