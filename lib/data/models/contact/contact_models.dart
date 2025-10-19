class ContactSupportRequestModel {
  final String message;

  const ContactSupportRequestModel({required this.message});

  factory ContactSupportRequestModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportRequestModel(message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class ContactSupportResponseModel {
  final String message;
  final bool? success;
  final int? retryAfterSeconds;

  const ContactSupportResponseModel({
    required this.message,
    this.success,
    this.retryAfterSeconds,
  });

  factory ContactSupportResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportResponseModel(
      message: json['message']?.toString() ?? 'Message sent successfully',
      success: json['success'] as bool?,
      retryAfterSeconds: json['retry_after_seconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (success != null) 'success': success,
      if (retryAfterSeconds != null) 'retry_after_seconds': retryAfterSeconds,
    };
  }
}
