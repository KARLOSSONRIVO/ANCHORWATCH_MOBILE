import 'package:equatable/equatable.dart';

/// Status enumeration for Articles state
enum ArticlesStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Article model
class Article extends Equatable {
  final String id;
  final String title;
  final String source;
  final String date;
  final String summary;
  final List<String> topics;
  final String? url;
  final DateTime publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.source,
    required this.date,
    required this.summary,
    required this.topics,
    this.url,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [id, title, source, date, summary, topics, url, publishedAt];
}

/// State for the Articles BLoC
class ArticlesState extends Equatable {
  final ArticlesStatus status;
  final List<Article> articles;
  final List<Article> filteredArticles;
  final String selectedTopic;
  final String selectedSort;
  final String? errorMessage;

  const ArticlesState({
    this.status = ArticlesStatus.initial,
    this.articles = const [],
    this.filteredArticles = const [],
    this.selectedTopic = 'All Topics',
    this.selectedSort = 'Newest First',
    this.errorMessage,
  });

  /// Create a copy of the current state with optional changes
  ArticlesState copyWith({
    ArticlesStatus? status,
    List<Article>? articles,
    List<Article>? filteredArticles,
    String? selectedTopic,
    String? selectedSort,
    String? errorMessage,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      selectedSort: selectedSort ?? this.selectedSort,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        articles,
        filteredArticles,
        selectedTopic,
        selectedSort,
        errorMessage,
      ];
}