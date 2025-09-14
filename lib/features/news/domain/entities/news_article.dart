/// News Article entity
///
/// This represents the core business object for news articles
/// in the domain layer. It contains only the essential data
/// without any external dependencies.
class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String source;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final List<String> categories;
  final int readTime; // in minutes
  final bool isBookmarked;
  final int likes;
  final int shares;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.categories,
    required this.readTime,
    this.isBookmarked = false,
    this.likes = 0,
    this.shares = 0,
  });

  /// Create a copy of this article with updated fields
  NewsArticle copyWith({
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
    return NewsArticle(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsArticle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NewsArticle(id: $id, title: $title, author: $author, publishedAt: $publishedAt)';
  }
}
