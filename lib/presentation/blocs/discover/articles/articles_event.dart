import 'package:equatable/equatable.dart';

/// Events for the Articles BLoC
abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

/// Event to load articles
class ArticlesLoadRequested extends ArticlesEvent {
  const ArticlesLoadRequested();
}

/// Event to refresh articles
class ArticlesRefreshRequested extends ArticlesEvent {
  const ArticlesRefreshRequested();
}

/// Event to filter articles by topic
class ArticlesFilterByTopic extends ArticlesEvent {
  final String topic;

  const ArticlesFilterByTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

/// Event to sort articles
class ArticlesSortChanged extends ArticlesEvent {
  final String sortType;

  const ArticlesSortChanged(this.sortType);

  @override
  List<Object> get props => [sortType];
}