import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';
@injectable
class SendChatMessageUseCase {
  final AnchorWiseRepository _repository;

  SendChatMessageUseCase(this._repository);
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
