import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';
@injectable
class GetConversationByIdUseCase {
  final AnchorWiseRepository _repository;

  GetConversationByIdUseCase(this._repository);
  Future<ConversationDetailsResponseModel> execute(String conversationId) async {
    if (conversationId.trim().isEmpty) {
      throw Exception('Conversation ID cannot be empty');
    }

    return await _repository.getConversationById(conversationId.trim());
  }
}
