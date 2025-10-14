import '../../domain/entities/macro_trends.dart';

// Data models for API response mapping
class MacroTrendsModel {
  final List<InflationRateModel> annualInflationRates;
  final List<InflationSupplyModel> inflationVsSupplyGrowth;
  final List<InflationRateModel> inflationTimeline;
  final List<CorrelationModel> correlationTable;

  MacroTrendsModel({
    required this.annualInflationRates,
    required this.inflationVsSupplyGrowth,
    required this.inflationTimeline,
    required this.correlationTable,
  });

  factory MacroTrendsModel.fromJson(Map<String, dynamic> json) {
    return MacroTrendsModel(
      annualInflationRates:
          (json['annual_inflation_rates'] as List<dynamic>?)
              ?.map(
                (item) =>
                    InflationRateModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      inflationVsSupplyGrowth:
          (json['inflation_vs_supply_growth'] as List<dynamic>?)
              ?.map(
                (item) =>
                    InflationSupplyModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      inflationTimeline:
          (json['inflation_timeline'] as List<dynamic>?)
              ?.map(
                (item) =>
                    InflationRateModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      correlationTable:
          (json['correlation_table'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CorrelationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  MacroTrendsData toEntity() {
    return MacroTrendsData(
      annualInflationRates: annualInflationRates
          .map((model) => model.toEntity())
          .toList(),
      inflationVsSupplyGrowth: inflationVsSupplyGrowth
          .map((model) => model.toEntity())
          .toList(),
      inflationTimeline: inflationTimeline
          .map((model) => model.toEntity())
          .toList(),
      correlationTable: correlationTable
          .map((model) => model.toEntity())
          .toList(),
    );
  }
}

class InflationRateModel {
  final int year;
  final double? inflationRate;

  InflationRateModel({required this.year, required this.inflationRate});

  factory InflationRateModel.fromJson(Map<String, dynamic> json) {
    return InflationRateModel(
      year: json['year'] as int? ?? 0,
      inflationRate: (json['inflation_rate'] as num?)?.toDouble(),
    );
  }

  InflationRateData toEntity() {
    return InflationRateData(year: year, inflationRate: inflationRate);
  }
}

class InflationSupplyModel {
  final int year;
  final double? inflationRate;
  final double? supplyGrowthPct;

  InflationSupplyModel({
    required this.year,
    required this.inflationRate,
    this.supplyGrowthPct,
  });

  factory InflationSupplyModel.fromJson(Map<String, dynamic> json) {
    return InflationSupplyModel(
      year: json['year'] as int? ?? 0,
      inflationRate: (json['inflation_rate'] as num?)?.toDouble(),
      supplyGrowthPct: (json['supply_growth_pct'] as num?)?.toDouble(),
    );
  }

  InflationSupplyData toEntity() {
    return InflationSupplyData(
      year: year,
      inflationRate: inflationRate,
      supplyGrowthPct: supplyGrowthPct,
    );
  }
}

class CorrelationModel {
  final String variable;
  final double inflationRate;
  final double price;
  final double marketCap;
  final double supplyClosing;
  final double netChangeUsd;

  CorrelationModel({
    required this.variable,
    required this.inflationRate,
    required this.price,
    required this.marketCap,
    required this.supplyClosing,
    required this.netChangeUsd,
  });

  factory CorrelationModel.fromJson(Map<String, dynamic> json) {
    return CorrelationModel(
      variable: json['variable'] as String? ?? '',
      inflationRate: (json['inflation_rate'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      supplyClosing: (json['supply_closing'] as num?)?.toDouble() ?? 0.0,
      netChangeUsd: (json['net_change_usd'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CorrelationData toEntity() {
    return CorrelationData(
      variable: variable,
      inflationRate: inflationRate,
      price: price,
      marketCap: marketCap,
      supplyClosing: supplyClosing,
      netChangeUsd: netChangeUsd,
    );
  }
}
