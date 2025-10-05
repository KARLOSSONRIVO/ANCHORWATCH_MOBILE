/// Comprehensive API endpoints matching Django backend structure
class ApiEndpoints {
  // Base API paths
  static const String baseUrl = ''; // Set this to your backend URL
  
  // Account endpoints
  static const String accounts = '/accounts/';
  
  // Analytics endpoints
  static const String analytics = '/analytics/';
  static const String unifiedStablecoinData = '$analytics/unified-stablecoin-data/';
  static const String stablecoinsPage = '$analytics/stablecoins-page/';
  static const String macroTrendsPage = '$analytics/macro-trends-page/';
  static const String chartSummary = '$analytics/chart-summary/';
  
  // API endpoints
  static const String feedback = '/api/feedback/';
  static const String llmApi = '/api/llm/';
  static const String maintenance = '/api/';
  
  // News endpoints
  static const String news = '/news/';
  
  // Configuration endpoints
  static const String config = '/config/';
  
  // Utility method to build full URL
  static String fullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}