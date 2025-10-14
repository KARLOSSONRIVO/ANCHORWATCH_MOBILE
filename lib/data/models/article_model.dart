import '../../domain/entities/article.dart';

class ArticleModel {
  final String title;
  final String url;
  final String source;
  final DateTime publishedAt;
  final String summary;
  final String category;
  final List<String> keyTopics;

  ArticleModel({
    required this.title,
    required this.url,
    required this.source,
    required this.publishedAt,
    required this.summary,
    required this.category,
    required this.keyTopics,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      summary: json['summary'] ?? '',
      category: json['category'] ?? '',
      keyTopics: (json['key_topics'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Article toEntity() {
    return Article(
      title: title,
      url: url,
      source: source,
      publishedAt: publishedAt,
      summary: summary,
      category: category,
      keyTopics: keyTopics,
    );
  }
}