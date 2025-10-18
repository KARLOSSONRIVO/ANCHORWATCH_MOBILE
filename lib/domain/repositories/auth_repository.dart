import '../entities/auth_result.dart';
import '../entities/password_reset/forgot_password_result.dart';
import '../entities/password_reset/verify_otp_result.dart';
import '../entities/password_reset/reset_password_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    required String password,
  });
  
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  });
  Future<ForgotPasswordResult> forgotPassword({
    required String email,
  });

  Future<VerifyOtpResult> verifyOtp({
    required String otp,
  });

  Future<ResetPasswordResult> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}
