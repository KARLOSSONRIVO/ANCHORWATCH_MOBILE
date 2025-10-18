
class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequestModel(
      oldPassword: json['old_password'] as String,
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }
}

class ChangePasswordResponseModel {
  final String message;

  const ChangePasswordResponseModel({
    required this.message,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ChangeUsernameRequestModel {
  final String newUsername;

  const ChangeUsernameRequestModel({
    required this.newUsername,
  });

  factory ChangeUsernameRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangeUsernameRequestModel(
      newUsername: json['new_username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'new_username': newUsername,
    };
  }
}

class ChangeUsernameResponseModel {
  final String message;

  const ChangeUsernameResponseModel({
    required this.message,
  });

  factory ChangeUsernameResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeUsernameResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
