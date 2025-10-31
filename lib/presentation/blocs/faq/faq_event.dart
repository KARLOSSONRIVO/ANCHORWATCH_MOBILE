import 'package:equatable/equatable.dart';
abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}
class FaqLoadRequested extends FaqEvent {
  const FaqLoadRequested();
}
class FaqRefreshRequested extends FaqEvent {
  const FaqRefreshRequested();
}
class FaqCategoryToggled extends FaqEvent {
  final String categoryId;

  const FaqCategoryToggled(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
class FaqItemToggled extends FaqEvent {
  final String categoryId;
  final String itemId;

  const FaqItemToggled(this.categoryId, this.itemId);

  @override
  List<Object> get props => [categoryId, itemId];
}
