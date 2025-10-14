import 'package:injectable/injectable.dart';
import '../../repositories/alert_repository.dart';

@injectable
class ResolveAlertUseCase {
  final AlertRepository _repository;

  ResolveAlertUseCase(this._repository);

  Future<void> call(String alertId) async {
    return await _repository.resolveAlert(alertId);
  }
}
