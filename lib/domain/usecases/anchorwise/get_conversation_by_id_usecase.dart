import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';

/// Use case for getting a specific conversation by ID
@injectable
class GetConversationByIdUseCase {
  final AnchorWiseRepository _repository;

  GetConversationByIdUseCase(this._repository);

  /// Execute the use case to get a conversation by ID
  Future<ConversationDetailsResponseModel> execute(String conversationId) async {
    if (conversationId.trim().isEmpty) {
      throw Exception('Conversation ID cannot be empty');
    }

    return await _repository.getConversationById(conversationId.trim());
  }
}