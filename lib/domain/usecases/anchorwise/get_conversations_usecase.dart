import 'package:injectable/injectable.dart';
import '../../repositories/anchorwise_repository.dart';
import '../../../data/models/anchorwise/chat_models.dart';
@injectable
class GetConversationsUseCase {
  final AnchorWiseRepository _repository;

  GetConversationsUseCase(this._repository);
  Future<ConversationsListResponseModel> execute() async {
    return await _repository.getConversations();
  }
}
