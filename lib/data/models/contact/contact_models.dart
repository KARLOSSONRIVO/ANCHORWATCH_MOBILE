
class ContactSupportRequestModel {
  final String message;

  const ContactSupportRequestModel({
    required this.message,
  });

  factory ContactSupportRequestModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportRequestModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ContactSupportResponseModel {
  final String message;

  const ContactSupportResponseModel({
    required this.message,
  });

  factory ContactSupportResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
