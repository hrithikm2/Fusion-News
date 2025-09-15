import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/news_article.dart';
import '../../../../core/widgets/animated_card.dart';

/// News Detail Page with SliverAppBar
///
/// This page displays the full details of a news article with a collapsible
/// header that shows the article image and transforms into text when scrolled.
class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        // Action buttons
        _buildActionButtons(),
      ],
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, isBoxScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () => _shareArticle(),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_browser, color: Colors.white),
                  onPressed: () => _openInBrowser(),
                ),
              ],
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              excludeHeaderSemantics: true,
              flexibleSpace: FlexibleSpaceBar(
                title: isBoxScrolled
                    ? Text(
                        article.title.length > 20
                            ? article.title.substring(0, 20) + '...'
                            : article.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                centerTitle: true,
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: _buildArticleImage(),
                ),
              ),
            ),
          ];
        },
        body: _buildArticleContent(),
      ),
    );
  }

  /// Build the article image for the SliverAppBar
  Widget _buildArticleImage() {
    if (article.imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Icon(Icons.article, color: Colors.grey, size: 64),
        ),
      );
    }

    return Image.network(
      article.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        log('Error loading image: $error');
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: Colors.grey, size: 64),
                SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  /// Build the main article content
  Widget _buildArticleContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article title (only shown when not scrolled)
          if (article.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),

          // Article metadata
          _buildArticleMetadata(),

          const SizedBox(height: 24),

          // Article description
          if (article.description.isNotEmpty) _buildDescriptionSection(),

          const SizedBox(height: 24),

          // Article content
          if (article.content.isNotEmpty) _buildContentSection(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build article metadata section
  Widget _buildArticleMetadata() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    article.author.isNotEmpty
                        ? article.author
                        : 'Unknown Author',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.source, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    article.source.isNotEmpty
                        ? article.source
                        : 'Unknown Source',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatDate(article.publishedAt),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            if (article.readTime > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${article.readTime} min read',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build description section
  Widget _buildDescriptionSection() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            article.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build content section
  Widget _buildContentSection() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            article.content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 600),
      child: Row(
        children: [
          Expanded(
            child: AnimatedCard(
              onTap: () => _openInBrowser(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.open_in_browser, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Read Full Article',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedCard(
              onTap: () => _shareArticle(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Share the article
  Future<void> _shareArticle() async {
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
      Get.snackbar(
        'Error',
        'Failed to share article: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Open article in browser
  Future<void> _openInBrowser() async {
    try {
      final uri = Uri.parse(article.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the article in browser',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open article: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}
