class ForgotPasswordRequestModel {
  final String email;

  const ForgotPasswordRequestModel({
    required this.email,
  });
  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequestModel(
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
class ForgotPasswordResponseModel {
  final String message;

  const ForgotPasswordResponseModel({
    required this.message,
  });
  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
class VerifyOtpRequestModel {
  final String otp;

  const VerifyOtpRequestModel({
    required this.otp,
  });
  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      otp: json['otp'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
    };
  }
}
class VerifyOtpResponseModel {
  final String message;
  final String email;

  const VerifyOtpResponseModel({
    required this.message,
    required this.email,
  });
  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      message: json['message'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
    };
  }
}
class ResetPasswordRequestModel {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequestModel({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      email: json['email'] as String,
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}
class ResetPasswordResponseModel {
  final String message;

  const ResetPasswordResponseModel({
    required this.message,
  });
  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
