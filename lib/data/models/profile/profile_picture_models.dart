// Profile picture upload related models

class GenerateProfileUploadURLRequestModel {
  final String contentType;

  const GenerateProfileUploadURLRequestModel({
    required this.contentType,
  });

  factory GenerateProfileUploadURLRequestModel.fromJson(Map<String, dynamic> json) {
    return GenerateProfileUploadURLRequestModel(
      contentType: json['content_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content_type': contentType,
    };
  }
}

class GenerateProfileUploadURLResponseModel {
  final String key;
  final String url;
  final Map<String, dynamic> fields;
  final int maxSizeMb;
  final String contentType;

  const GenerateProfileUploadURLResponseModel({
    required this.key,
    required this.url,
    required this.fields,
    required this.maxSizeMb,
    required this.contentType,
  });

  factory GenerateProfileUploadURLResponseModel.fromJson(Map<String, dynamic> json) {
    return GenerateProfileUploadURLResponseModel(
      key: json['key'] as String,
      url: json['url'] as String,
      fields: json['fields'] as Map<String, dynamic>,
      maxSizeMb: json['max_size_mb'] as int? ?? 5,
      contentType: json['content_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'url': url,
      'fields': fields,
      'max_size_mb': maxSizeMb,
      'content_type': contentType,
    };
  }
}

class ConfirmProfileImageRequestModel {
  final String key;

  const ConfirmProfileImageRequestModel({
    required this.key,
  });

  factory ConfirmProfileImageRequestModel.fromJson(Map<String, dynamic> json) {
    return ConfirmProfileImageRequestModel(
      key: json['key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
    };
  }
}

class ConfirmProfileImageResponseModel {
  final String profileImageUrl;

  const ConfirmProfileImageResponseModel({
    required this.profileImageUrl,
  });

  factory ConfirmProfileImageResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmProfileImageResponseModel(
      profileImageUrl: json['profile_image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_image_url': profileImageUrl,
    };
  }
}
