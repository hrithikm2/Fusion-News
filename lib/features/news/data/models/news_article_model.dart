import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/news_article.dart';

part 'news_article_model.g.dart';

/// Data model for NewsArticle
///
/// This model handles the serialization/deserialization of news articles
/// from external data sources (API, local storage, etc.)
@JsonSerializable()
class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.author,
    required super.source,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.categories,
    required super.readTime,
    super.isBookmarked,
    super.likes,
    super.shares,
  });

  /// Create a NewsArticleModel from JSON
  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleModelFromJson(json);

  /// Create a NewsArticleModel from NewsAPI JSON format
  factory NewsArticleModel.fromNewsApiJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id:
          json['url'] as String? ??
          '', // Use URL as ID since NewsAPI doesn't provide ID
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content:
          json['content'] as String? ?? json['description'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      source: json['source']?['name'] as String? ?? 'Unknown Source',
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String? ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : DateTime.now(),
      categories: _extractCategories(json),
      readTime: _calculateReadTime(
        json['content'] as String? ?? json['description'] as String? ?? '',
      ),
      isBookmarked: false,
      likes: 0,
      shares: 0,
    );
  }

  /// Extract categories from NewsAPI response
  static List<String> _extractCategories(Map<String, dynamic> json) {
    final categories = <String>[];

    // Add source as category
    if (json['source']?['name'] != null) {
      categories.add(json['source']['name'] as String);
    }

    // Add any other category information if available
    if (json['category'] != null) {
      categories.add(json['category'] as String);
    }

    return categories.isEmpty ? ['General'] : categories;
  }

  /// Calculate estimated read time based on content length
  static int _calculateReadTime(String content) {
    final wordCount = content.split(' ').length;
    final readTime = (wordCount / 200)
        .ceil(); // Average reading speed: 200 words per minute
    return readTime < 1 ? 1 : readTime;
  }

  /// Convert NewsArticleModel to JSON
  Map<String, dynamic> toJson() => _$NewsArticleModelToJson(this);

  /// Create a NewsArticleModel from a NewsArticle entity
  factory NewsArticleModel.fromEntity(NewsArticle article) {
    return NewsArticleModel(
      id: article.id,
      title: article.title,
      description: article.description,
      content: article.content,
      author: article.author,
      source: article.source,
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      categories: article.categories,
      readTime: article.readTime,
      isBookmarked: article.isBookmarked,
      likes: article.likes,
      shares: article.shares,
    );
  }

  /// Convert to NewsArticle entity
  NewsArticle toEntity() {
    return NewsArticle(
      id: id,
      title: title,
      description: description,
      content: content,
      author: author,
      source: source,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      categories: categories,
      readTime: readTime,
      isBookmarked: isBookmarked,
      likes: likes,
      shares: shares,
    );
  }

  /// Create a copy with updated fields
  @override
  NewsArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? author,
    String? source,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    List<String>? categories,
    int? readTime,
    bool? isBookmarked,
    int? likes,
    int? shares,
  }) {
    return NewsArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      author: author ?? this.author,
      source: source ?? this.source,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      categories: categories ?? this.categories,
      readTime: readTime ?? this.readTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
    );
  }
}
