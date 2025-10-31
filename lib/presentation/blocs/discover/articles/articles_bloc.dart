import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/article.dart';
import '../../../../domain/usecases/get_articles_usecase.dart';
import 'articles_event.dart';
import 'articles_state.dart';
@injectable
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;

  ArticlesBloc(this._getArticlesUseCase) : super(const ArticlesState()) {
    on<ArticlesLoadRequested>(_onArticlesLoadRequested);
    on<ArticlesRefreshRequested>(_onArticlesRefreshRequested);
    on<ArticlesFilterByTopic>(_onArticlesFilterByTopic);
    on<ArticlesSortChanged>(_onArticlesSortChanged);
  }
  void _onArticlesLoadRequested(
    ArticlesLoadRequested event,
    Emitter<ArticlesState> emit,
  ) async {
    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      final articles = await _getArticlesUseCase();
      final filteredArticles = _filterAndSortArticles(
        articles,
        state.selectedTopic,
        state.selectedSort,
      );
      
      emit(state.copyWith(
        status: ArticlesStatus.loaded,
        articles: articles,
        filteredArticles: filteredArticles,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ArticlesStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onArticlesRefreshRequested(
    ArticlesRefreshRequested event,
    Emitter<ArticlesState> emit,
  ) async {
    try {
      final articles = await _getArticlesUseCase();
      final filteredArticles = _filterAndSortArticles(
        articles,
        state.selectedTopic,
        state.selectedSort,
      );
      
      emit(state.copyWith(
        status: ArticlesStatus.loaded,
        articles: articles,
        filteredArticles: filteredArticles,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ArticlesStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
  void _onArticlesFilterByTopic(
    ArticlesFilterByTopic event,
    Emitter<ArticlesState> emit,
  ) {
    final filteredArticles = _filterAndSortArticles(
      state.articles,
      event.topic,
      state.selectedSort,
    );
    
    emit(state.copyWith(
      selectedTopic: event.topic,
      filteredArticles: filteredArticles,
    ));
  }
  void _onArticlesSortChanged(
    ArticlesSortChanged event,
    Emitter<ArticlesState> emit,
  ) {
    final filteredArticles = _filterAndSortArticles(
      state.articles,
      state.selectedTopic,
      event.sortType,
    );
    
    emit(state.copyWith(
      selectedSort: event.sortType,
      filteredArticles: filteredArticles,
    ));
  }
  List<Article> _filterAndSortArticles(
    List<Article> articles,
    String topic,
    String sortType,
  ) {
    var filtered = articles;
    if (topic != 'All Topics') {
      filtered = articles.where((article) => article.keyTopics.contains(topic)).toList();
    }
    if (sortType == 'Newest First') {
      filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (sortType == 'Oldest First') {
      filtered.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }
    
    return filtered;
  }


}
