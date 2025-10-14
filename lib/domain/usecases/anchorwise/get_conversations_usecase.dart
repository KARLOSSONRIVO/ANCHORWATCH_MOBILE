import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';

/// Use case for getting all conversations for the user
@injectable
class GetConversationsUseCase {
  final AnchorWiseRepository _repository;

  GetConversationsUseCase(this._repository);

  /// Execute the use case to get all conversations
  Future<ConversationsListResponseModel> execute() async {
    return await _repository.getConversations();
  }
}