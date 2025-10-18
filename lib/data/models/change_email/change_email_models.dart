import 'package:equatable/equatable.dart';
class RequestChangeEmailRequestModel extends Equatable {
  final String newEmail;

  const RequestChangeEmailRequestModel({
    required this.newEmail,
  });

  factory RequestChangeEmailRequestModel.fromJson(Map<String, dynamic> json) {
    return RequestChangeEmailRequestModel(
      newEmail: json['new_email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'new_email': newEmail,
    };
  }

  @override
  List<Object> get props => [newEmail];
}
class RequestChangeEmailResponseModel extends Equatable {
  final String message;

  const RequestChangeEmailResponseModel({
    required this.message,
  });

  factory RequestChangeEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestChangeEmailResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  List<Object> get props => [message];
}
class ConfirmChangeEmailRequestModel extends Equatable {
  final String otp;
  final String newEmail;

  const ConfirmChangeEmailRequestModel({
    required this.otp,
    required this.newEmail,
  });

  factory ConfirmChangeEmailRequestModel.fromJson(Map<String, dynamic> json) {
    return ConfirmChangeEmailRequestModel(
      otp: json['otp'] as String,
      newEmail: json['new_email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'new_email': newEmail,
    };
  }

  @override
  List<Object> get props => [otp, newEmail];
}
class ConfirmChangeEmailResponseModel extends Equatable {
  final String message;

  const ConfirmChangeEmailResponseModel({
    required this.message,
  });

  factory ConfirmChangeEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmChangeEmailResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  List<Object> get props => [message];
}
