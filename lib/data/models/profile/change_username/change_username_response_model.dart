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