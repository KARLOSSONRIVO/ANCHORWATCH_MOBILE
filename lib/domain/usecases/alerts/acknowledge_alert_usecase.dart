import 'package:injectable/injectable.dart';
import '../../repositories/alert_repository.dart';

@injectable
class AcknowledgeAlertUseCase {
  final AlertRepository _repository;

  AcknowledgeAlertUseCase(this._repository);

  Future<void> call(String alertId) async {
    return await _repository.acknowledgeAlert(alertId);
  }
}
