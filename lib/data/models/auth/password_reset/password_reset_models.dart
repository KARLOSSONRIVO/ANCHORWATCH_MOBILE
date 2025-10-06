/// Password Reset Request and Response Models

/// Request model for forgot password API
class ForgotPasswordRequestModel {
  final String email;

  const ForgotPasswordRequestModel({
    required this.email,
  });

  /// Creates instance from JSON data
  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequestModel(
      email: json['email'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

/// Response model for forgot password API
class ForgotPasswordResponseModel {
  final String message;

  const ForgotPasswordResponseModel({
    required this.message,
  });

  /// Creates instance from JSON data
  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

/// Request model for verify OTP API
class VerifyOtpRequestModel {
  final String otp;

  const VerifyOtpRequestModel({
    required this.otp,
  });

  /// Creates instance from JSON data
  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      otp: json['otp'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
    };
  }
}

/// Response model for verify OTP API
class VerifyOtpResponseModel {
  final String message;
  final String email;

  const VerifyOtpResponseModel({
    required this.message,
    required this.email,
  });

  /// Creates instance from JSON data
  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      message: json['message'] as String,
      email: json['email'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
    };
  }
}

/// Request model for reset password API
class ResetPasswordRequestModel {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequestModel({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  /// Creates instance from JSON data
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      email: json['email'] as String,
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}

/// Response model for reset password API
class ResetPasswordResponseModel {
  final String message;

  const ResetPasswordResponseModel({
    required this.message,
  });

  /// Creates instance from JSON data
  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'] as String,
    );
  }

  /// Converts instance to JSON data
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}