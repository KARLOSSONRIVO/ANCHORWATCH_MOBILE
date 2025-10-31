import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';
@injectable
class DeleteConversationUseCase {
  final AnchorWiseRepository _repository;

  DeleteConversationUseCase(this._repository);
  Future<DeleteConversationResponseModel> execute(String conversationId) async {
    if (conversationId.trim().isEmpty) {
      throw Exception('Conversation ID cannot be empty');
    }

    return await _repository.deleteConversation(conversationId.trim());
  }
}
