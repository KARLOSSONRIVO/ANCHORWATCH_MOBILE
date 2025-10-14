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