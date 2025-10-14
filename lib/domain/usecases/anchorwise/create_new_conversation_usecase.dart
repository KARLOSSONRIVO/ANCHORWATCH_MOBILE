import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';

/// Use case for creating a new conversation
@injectable
class CreateNewConversationUseCase {
  final AnchorWiseRepository _repository;

  CreateNewConversationUseCase(this._repository);

  /// Execute the use case to create a new conversation
  /// Returns the conversation ID from the API response
  Future<String> execute() async {
    final response = await _repository.createNewConversation();
    return response.conversationId;
  }
}