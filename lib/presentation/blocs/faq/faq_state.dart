import 'package:equatable/equatable.dart';
import '../../../data/models/faq_models.dart';

/// Status enum for FAQ state
enum FaqStatus { initial, loading, success, failure }

/// State for FaqBloc
class FaqState extends Equatable {
  const FaqState({
    this.status = FaqStatus.initial,
    this.categories = const [],
    this.errorMessage = '',
  });

  final FaqStatus status;
  final List<FaqCategory> categories;
  final String errorMessage;

  FaqState copyWith({
    FaqStatus? status,
    List<FaqCategory>? categories,
    String? errorMessage,
  }) {
    return FaqState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, categories, errorMessage];
}