/// FAQ models for the application
class FaqCategory {
  final String id;
  final String title;
  final List<FaqItem> questions;
  final bool isExpanded;

  const FaqCategory({
    required this.id,
    required this.title,
    required this.questions,
    this.isExpanded = false,
  });

  FaqCategory copyWith({
    String? id,
    String? title,
    List<FaqItem>? questions,
    bool? isExpanded,
  }) {
    return FaqCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class FaqItem {
  final String id;
  final String question;
  final String answer;
  final bool isExpanded;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}