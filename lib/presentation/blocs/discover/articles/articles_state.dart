import 'package:equatable/equatable.dart';
import '../../../../domain/entities/article.dart';
enum ArticlesStatus {
  initial,
  loading,
  loaded,
  error,
}
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
