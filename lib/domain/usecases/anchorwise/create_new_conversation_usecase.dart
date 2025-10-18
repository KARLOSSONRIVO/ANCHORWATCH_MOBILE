import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
@injectable
class CreateNewConversationUseCase {
  final AnchorWiseRepository _repository;

  CreateNewConversationUseCase(this._repository);
  Future<String> execute() async {
    final response = await _repository.createNewConversation();
    return response.conversationId;
  }
}
