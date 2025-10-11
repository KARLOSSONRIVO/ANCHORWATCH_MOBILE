import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';

/// Use case for sending feedback for AnchorWise AI messages
@injectable
class SendFeedbackUseCase {
  final AnchorWiseRepository _repository;

  SendFeedbackUseCase(this._repository);

  /// Execute the use case to send feedback for a message
  Future<bool> call({
    required String conversationId,
    required String messageId,
    required String feedback,
  }) async {
    if (conversationId.trim().isEmpty) {
      throw Exception('Conversation ID cannot be empty');
    }
    
    if (messageId.trim().isEmpty) {
      throw Exception('Message ID cannot be empty');
    }
    
    if (feedback.trim().isEmpty || 
        (!feedback.contains('positive') && !feedback.contains('negative'))) {
      throw Exception('Feedback must be either "positive" or "negative"');
    }

    return await _repository.sendFeedback(
      conversationId: conversationId.trim(),
      messageId: messageId.trim(),
      feedback: feedback.trim(),
    );
  }
}