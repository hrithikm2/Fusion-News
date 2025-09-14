import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/news_article.dart';
import '../../../../core/constants/app_constants.dart';

/// Individual news article item for the reel interface
///
/// This widget displays a single news article in a full-screen format
/// optimized for vertical scrolling with interactive elements.
class NewsReelItem extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onBookmark;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const NewsReelItem({
    super.key,
    required this.article,
    required this.onBookmark,
    required this.onLike,
    required this.onShare,
  });

  static const double _sidePadding = AppConstants.defaultPadding;
  static const double _rightActionsPanelWidth = 72; // 48 btn + padding
  static const double _rightActionsBottomOffset = 16;
  static const double _bottomContentExtra = 12; // breathing space

  /// Format the published date
  String _formatPublishedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Build the article image
  Widget _buildArticleImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main image
        CachedNetworkImage(
          imageUrl: article.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),

        // Gradient overlay for better text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.30),
                Colors.black.withValues(alpha: 0.72),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  /// Build the article content
  Widget _buildArticleContent(BuildContext context) {
    final insets = MediaQuery.of(context).padding;
    // Reserve space on the right for the vertical actions and at the bottom for safe area
    final rightReserved = _rightActionsPanelWidth;
    final bottomReserved =
        insets.bottom + _rightActionsBottomOffset + _bottomContentExtra;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _sidePadding,
          0,
          // keep text away from the right-side actions
          rightReserved,
          bottomReserved,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Author
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    article.author.isNotEmpty
                        ? article.author[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'By ${article.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Source and time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatPublishedDate(article.publishedAt),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  '${article.readTime}m read',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              article.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              article.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the action buttons
  Widget _buildActionButtons(BuildContext context) {
    final insets = MediaQuery.of(context).padding;

    return Positioned(
      right: 16,
      bottom: _rightActionsBottomOffset + insets.bottom,
      child: Column(
        children: [
          // Bookmark button
          _buildActionButton(
            icon: article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            onTap: onBookmark,
            isActive: article.isBookmarked,
          ),

          const SizedBox(height: 16),

          // Like button
          _buildActionButton(
            icon: Icons.favorite_border,
            onTap: onLike,
            count: article.likes,
          ),

          const SizedBox(height: 16),

          // Share button
          _buildActionButton(
            icon: Icons.share,
            onTap: onShare,
            count: article.shares,
          ),
        ],
      ),
    );
  }

  /// Build individual action button
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    int? count,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.red : Colors.white,
              size: 24,
            ),
          ),
        ),
        if (count != null && count > 0) ...[
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  /// Format count for display (e.g., 1000 -> 1K)
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  /// Build categories (uses local context & safe area)
  Widget _buildCategories(BuildContext context) {
    if (article.categories.isEmpty) return const SizedBox.shrink();
    final insets = MediaQuery.of(context).padding;

    return Positioned(
      top: insets.top + 60,
      left: 16,
      right:
          16 + _rightActionsPanelWidth, // keep chips clear of the right panel
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: article.categories.take(3).map((category) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          _buildArticleImage(),

          // Article content (left-aligned, padded away from right panel & bottom)
          _buildArticleContent(context),

          // Action buttons (right vertical panel; sits above safe area)
          _buildActionButtons(context),

          // Categories (top-left chips; kept away from right actions)
          _buildCategories(context),
        ],
      ),
    );
  }
}
