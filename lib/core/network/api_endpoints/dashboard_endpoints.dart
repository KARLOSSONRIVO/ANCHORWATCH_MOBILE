/// Dashboard related API endpoints
class DashboardEndpoints {
  // Base paths for analytics API
  static const String _analytics = '/analytics';
  
  // Dashboard data endpoints matching Django backend
  static const String unifiedStablecoinData = '$_analytics/unified-stablecoin-data/';
  static const String stablecoinsPage = '$_analytics/stablecoins-page/';
  static const String macroTrendsPage = '$_analytics/macro-trends-page/';
  static const String chartSummary = '$_analytics/chart-summary/';
  
  // Legacy endpoint mappings for backward compatibility
  static const String stablecoinData = unifiedStablecoinData;
  static const String macroTrends = macroTrendsPage;
  
}