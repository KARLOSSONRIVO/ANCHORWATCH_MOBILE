import 'package:equatable/equatable.dart';
abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}
class ArticlesLoadRequested extends ArticlesEvent {
  const ArticlesLoadRequested();
}
class ArticlesRefreshRequested extends ArticlesEvent {
  const ArticlesRefreshRequested();
}
class ArticlesFilterByTopic extends ArticlesEvent {
  final String topic;

  const ArticlesFilterByTopic(this.topic);

  @override
  List<Object> get props => [topic];
}
class ArticlesSortChanged extends ArticlesEvent {
  final String sortType;

  const ArticlesSortChanged(this.sortType);

  @override
  List<Object> get props => [sortType];
}
