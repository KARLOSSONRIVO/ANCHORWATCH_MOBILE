import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';

/// Use case for sending chat messages to AnchorWise AI
@injectable
class SendChatMessageUseCase {
  final AnchorWiseRepository _repository;

  SendChatMessageUseCase(this._repository);

  /// Execute the use case to send a chat message
  Future<ChatResponseModel> execute({
    required String query,
    String? conversationId,
  }) async {
    if (query.trim().isEmpty) {
      throw Exception('Query cannot be empty');
    }

    return await _repository.sendChatMessage(
      query: query.trim(),
      conversationId: conversationId,
    );
  }
}