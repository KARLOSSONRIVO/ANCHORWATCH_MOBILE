class ContactSupportRequestModel {
  final String subject;
  final String message;
  final String? userEmail;
  final String? userId;
  final String? username;

  const ContactSupportRequestModel({
    required this.subject,
    required this.message,
    this.userEmail,
    this.userId,
    this.username,
  });

  factory ContactSupportRequestModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportRequestModel(
      subject: json['subject'] as String,
      message: json['message'] as String,
      userEmail: json['user_email'] as String?,
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
      if (userEmail != null) 'user_email': userEmail,
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
    };
  }
}

class ContactSupportResponseModel {
  final String message;
  final String? conversationId;
  final bool? success;
  final int? retryAfterSeconds;

  const ContactSupportResponseModel({
    required this.message,
    this.conversationId,
    this.success,
    this.retryAfterSeconds,
  });

  factory ContactSupportResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactSupportResponseModel(
      message: json['message']?.toString() ?? 'Feedback submitted successfully',
      conversationId: json['conversation_id'] as String?,
      success: json['success'] as bool?,
      retryAfterSeconds: json['retry_after_seconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (conversationId != null) 'conversation_id': conversationId,
      if (success != null) 'success': success,
      if (retryAfterSeconds != null) 'retry_after_seconds': retryAfterSeconds,
    };
  }
}
