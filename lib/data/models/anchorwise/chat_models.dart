/// Request model for chat API
class ChatRequestModel {
  final String query;

  ChatRequestModel({
    required this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
    };
  }
}

/// Response model for chat API
class ChatResponseModel {
  final String response;
  final String timestamp;

  ChatResponseModel({
    required this.response,
    required this.timestamp,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      response: json['response'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}