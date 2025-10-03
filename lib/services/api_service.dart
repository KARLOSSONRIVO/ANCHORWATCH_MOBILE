import 'package:flutter/material.dart';

/// API Endpoints constants
class ApiEndpoints {
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  
  // AnchorWise endpoints
  static const String anchorwiseData = '/anchorwise/data';
  static const String anchorwiseAnalysis = '/anchorwise/analysis';
  
  // Alerts endpoints
  static const String alerts = '/alerts';
  static const String alertsHistory = '/alerts/history';
  
  // Discovery endpoints
  static const String discoverContent = '/discover/content';
  static const String discoverRecommendations = '/discover/recommendations';
}

/// HTTP Status Codes constants
class HttpStatusCodes {
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}

/// Service for handling API communication
class ApiService {
  // Base URL for your API
  static const String baseUrl = 'https://api.anchorwatch.com'; // Replace with your actual API URL
  
  /// Common HTTP headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Handle API response
  static void handleApiResponse(int statusCode, String responseBody) {
    switch (statusCode) {
      case 200:
      case 201:
        // Success - no action needed
        break;
      case 401:
        debugPrint('API Error: Unauthorized - $responseBody');
        // Handle unauthorized access
        break;
      case 403:
        debugPrint('API Error: Forbidden - $responseBody');
        // Handle forbidden access
        break;
      case 404:
        debugPrint('API Error: Not Found - $responseBody');
        // Handle not found
        break;
      case 500:
        debugPrint('API Error: Internal Server Error - $responseBody');
        // Handle server error
        break;
      default:
        debugPrint('API Error: $statusCode - $responseBody');
        // Handle other errors
        break;
    }
  }

  /// Build full URL from endpoint
  static String buildUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint; // Already a full URL
    }
    
    // Remove leading slash if present
    if (endpoint.startsWith('/')) {
      endpoint = endpoint.substring(1);
    }
    
    return '$baseUrl/$endpoint';
  }


}