import 'package:injectable/injectable.dart';

import '../../entities/password_reset/verify_otp_result.dart';
import '../../repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpResult> call({
    required String otp,
  }) async {
    return await repository.verifyOtp(otp: otp);
  }
}