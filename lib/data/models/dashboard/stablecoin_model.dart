import '../../../domain/entities/stablecoin_chart_data.dart';

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonData) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromJsonData(json['data']),
    );
  }
}

// Updated models to match your actual API response
class UnifiedStablecoinDataModel {
  final String date;
  final double price;
  final double marketCap;
  final double supplyClosing;
  final double mintUsd;
  final double burnUsd;
  final double netChangeUsd;
  final double? inflationRate;
  final double? pctChangeSupply;
  final double? pctChangePrice;

  UnifiedStablecoinDataModel({
    required this.date,
    required this.price,
    required this.marketCap,
    required this.supplyClosing,
    required this.mintUsd,
    required this.burnUsd,
    required this.netChangeUsd,
    this.inflationRate,
    this.pctChangeSupply,
    this.pctChangePrice,
  });

  factory UnifiedStablecoinDataModel.fromJson(Map<String, dynamic> json) {
    return UnifiedStablecoinDataModel(
      date: json['date'] as String,
      price: (json['price'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      supplyClosing: (json['supply_closing'] as num).toDouble(),
      mintUsd: (json['mint_usd'] as num).toDouble(),
      burnUsd: (json['burn_usd'] as num).toDouble(),
      netChangeUsd: (json['net_change_usd'] as num).toDouble(),
      inflationRate: json['inflation_rate'] != null 
          ? (json['inflation_rate'] as num).toDouble() 
          : null,
      pctChangeSupply: json['pct_change_supply'] != null 
          ? (json['pct_change_supply'] as num).toDouble() 
          : null,
      pctChangePrice: json['pct_change_price'] != null 
          ? (json['pct_change_price'] as num).toDouble() 
          : null,
    );
  }

  DateTime get dateTime => DateTime.parse(date);

  // Convert to old model format for compatibility
  SupplyDataPoint toSupplyDataPoint() {
    return SupplyDataPoint(
      date: dateTime,
      supplyClosing: supplyClosing,
      price: price, // Include price data from API
    );
  }

  MintBurnActivity toMintBurnActivity() {
    return MintBurnActivity(
      date: dateTime,
      mintUsd: mintUsd,
      burnUsd: burnUsd,
    );
  }

  NetChangeData toNetChangeData() {
    return NetChangeData(
      date: dateTime,
      netChangeUsd: netChangeUsd,
    );
  }
}

// Updated stablecoin chart data model to work with your API
class StablecoinChartDataModel {
  final List<UnifiedStablecoinDataModel> data;

  StablecoinChartDataModel({
    required this.data,
  });

  factory StablecoinChartDataModel.fromJson(Map<String, dynamic> json) {
    // Handle the API response wrapper
    final responseData = json['data'] as List<dynamic>;
    return StablecoinChartDataModel(
      data: responseData
          .map((item) => UnifiedStablecoinDataModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  StablecoinChartData toEntity() {
    return StablecoinChartData(
      totalSupplyOverTime: data.map((e) => e.toSupplyDataPoint()).toList(),
      mintBurnActivity: data.map((e) => e.toMintBurnActivity()).toList(),
      netChangeInSupply: data.map((e) => e.toNetChangeData()).toList(),
      largestMintBurnEvents: [], // Empty for now - need more data from API
      rollingAverageSupplyChanges: [], // Empty for now - need more data from API
    );
  }
}