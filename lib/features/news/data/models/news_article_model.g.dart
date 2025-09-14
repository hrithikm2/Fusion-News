// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleModel _$NewsArticleModelFromJson(Map<String, dynamic> json) =>
    NewsArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      source: json['source'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      readTime: (json['readTime'] as num).toInt(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NewsArticleModelToJson(NewsArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'author': instance.author,
      'source': instance.source,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'categories': instance.categories,
      'readTime': instance.readTime,
      'isBookmarked': instance.isBookmarked,
      'likes': instance.likes,
      'shares': instance.shares,
    };
