import 'package:equatable/equatable.dart';

/// Events for the FaqBloc
abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

/// Event to load FAQ information
class FaqLoadRequested extends FaqEvent {
  const FaqLoadRequested();
}

/// Event to refresh FAQ information
class FaqRefreshRequested extends FaqEvent {
  const FaqRefreshRequested();
}

/// Event to toggle a category expansion
class FaqCategoryToggled extends FaqEvent {
  final String categoryId;

  const FaqCategoryToggled(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

/// Event to toggle a FAQ item expansion
class FaqItemToggled extends FaqEvent {
  final String categoryId;
  final String itemId;

  const FaqItemToggled(this.categoryId, this.itemId);

  @override
  List<Object> get props => [categoryId, itemId];
}