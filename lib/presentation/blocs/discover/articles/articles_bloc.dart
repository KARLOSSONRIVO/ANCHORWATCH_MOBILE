import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'articles_event.dart';
import 'articles_state.dart';

/// BLoC for managing articles state
@injectable
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  ArticlesBloc() : super(const ArticlesState()) {
    on<ArticlesLoadRequested>(_onArticlesLoadRequested);
    on<ArticlesRefreshRequested>(_onArticlesRefreshRequested);
    on<ArticlesFilterByTopic>(_onArticlesFilterByTopic);
    on<ArticlesSortChanged>(_onArticlesSortChanged);
  }

  /// Handle loading articles
  void _onArticlesLoadRequested(
    ArticlesLoadRequested event,
    Emitter<ArticlesState> emit,
  ) async {
    emit(state.copyWith(status: ArticlesStatus.loading));

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      final articles = _getSampleArticles();
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

  /// Handle refreshing articles
  void _onArticlesRefreshRequested(
    ArticlesRefreshRequested event,
    Emitter<ArticlesState> emit,
  ) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      final articles = _getSampleArticles();
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

  /// Handle filtering articles by topic
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

  /// Handle sorting articles
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

  /// Filter and sort articles based on criteria
  List<Article> _filterAndSortArticles(
    List<Article> articles,
    String topic,
    String sortType,
  ) {
    var filtered = articles;
    
    // Filter by topic
    if (topic != 'All Topics') {
      filtered = articles.where((article) => article.topics.contains(topic)).toList();
    }
    
    // Sort articles
    if (sortType == 'Newest First') {
      filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (sortType == 'Oldest First') {
      filtered.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }
    
    return filtered;
  }

  /// Generate sample articles - replace with actual API call
  List<Article> _getSampleArticles() {
    return [
      Article(
        id: '1',
        title: 'Stablecoin Market Analysis: Q4 2024 Trends',
        source: 'CryptoNews',
        date: 'Oct 6, 2024',
        summary: 'An in-depth analysis of stablecoin market movements and their correlation with traditional financial indicators during the fourth quarter.',
        topics: ['Stablecoins', 'Analysis', 'Markets'],
        publishedAt: DateTime(2024, 10, 6),
      ),
      Article(
        id: '2',
        title: 'DeFi Protocol Updates: Major Changes This Week',
        source: 'DeFi Weekly',
        date: 'Oct 5, 2024',
        summary: 'Round-up of significant protocol updates, governance changes, and new feature releases across major DeFi platforms.',
        topics: ['DeFi', 'Updates'],
        publishedAt: DateTime(2024, 10, 5),
      ),
      Article(
        id: '3',
        title: 'Federal Reserve Policy Impact on Digital Assets',
        source: 'Financial Times',
        date: 'Oct 4, 2024',
        summary: 'Analysis of how recent Federal Reserve policy decisions are affecting cryptocurrency markets and stablecoin adoption.',
        topics: ['Analysis', 'Markets', 'Policy'],
        publishedAt: DateTime(2024, 10, 4),
      ),
      Article(
        id: '4',
        title: 'USDT Supply Dynamics: October 2024 Report',
        source: 'Blockchain Analytics',
        date: 'Oct 3, 2024',
        summary: 'Detailed examination of USDT minting and burning patterns, exchange flows, and market implications.',
        topics: ['Stablecoins', 'USDT', 'Analysis'],
        publishedAt: DateTime(2024, 10, 3),
      ),
      Article(
        id: '5',
        title: 'Cross-Chain Bridge Security Analysis',
        source: 'Security Labs',
        date: 'Oct 2, 2024',
        summary: 'Comprehensive review of security measures and recent vulnerabilities in major cross-chain bridge protocols.',
        topics: ['DeFi', 'Security', 'Analysis'],
        publishedAt: DateTime(2024, 10, 2),
      ),
    ];
  }
}