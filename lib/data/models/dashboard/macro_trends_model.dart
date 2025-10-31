import '../../../domain/entities/macro_trends.dart';

class InflationRateModel {
  final int year;
  final String? period;
  final double? inflationRate;

  InflationRateModel({required this.year, this.period, this.inflationRate});

  factory InflationRateModel.fromJson(Map<String, dynamic> json) {
    int yearValue = 0;
    String? periodValue;

    if (json['year'] != null) {
      yearValue = json['year'] as int;
    } else if (json['period'] != null) {
      periodValue = json['period'] as String;
      try {
        yearValue = int.parse(periodValue.split('-')[0]);
      } catch (_) {
        yearValue = 0;
      }
    }

    return InflationRateModel(
      year: yearValue,
      period: periodValue,
      inflationRate: json['inflation_rate'] != null
          ? (json['inflation_rate'] as num?)?.toDouble()
          : null,
    );
  }

  InflationRateData toEntity() {
    return InflationRateData(
      year: year,
      period: period,
      inflationRate: inflationRate,
    );
  }
}

class CorrelationModel {
  final String variable;
  final double price;
  final double marketCap;
  final double supplyClosing;
  final double netChangeUsd;
  final double inflationRate;

  CorrelationModel({
    required this.variable,
    required this.price,
    required this.marketCap,
    required this.supplyClosing,
    required this.netChangeUsd,
    required this.inflationRate,
  });

  factory CorrelationModel.fromJson(Map<String, dynamic> json) {
    return CorrelationModel(
      variable: json['variable'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0,
      supplyClosing: (json['supply_closing'] as num?)?.toDouble() ?? 0,
      netChangeUsd: (json['net_change_usd'] as num?)?.toDouble() ?? 0,
      inflationRate: (json['inflation_rate'] as num?)?.toDouble() ?? 0,
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

class MacroTrendsModel {
  final List<InflationRateModel> annualInflationRates;
  final List<InflationRateModel> inflationTimeline;
  final List<CorrelationModel> correlationTable;
  final List<RollingCorrelationModel> rollingCorrelations;

  MacroTrendsModel({
    required this.annualInflationRates,
    required this.inflationTimeline,
    required this.correlationTable,
    required this.rollingCorrelations,
  });

  factory MacroTrendsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final inflationSource = data is Map<String, dynamic>
        ? (data['annual_inflation_rates'] as List<dynamic>? ?? const [])
        : json['annual_inflation_rates'] as List<dynamic>? ?? const [];
    final correlationSource = data is Map<String, dynamic>
        ? (data['correlation_table'] as List<dynamic>? ?? const [])
        : json['correlation_table'] as List<dynamic>? ?? const [];
    final rollingSource = data is Map<String, dynamic>
        ? (data['rolling_correlations'] as List<dynamic>? ?? const [])
        : json['rolling_correlations'] as List<dynamic>? ?? const [];

    final inflationRates = inflationSource
        .map(
          (item) => InflationRateModel.fromJson(
            item as Map<String, dynamic>? ?? {},
          ),
        )
        .toList();

    final correlation = correlationSource
        .map(
          (item) => CorrelationModel.fromJson(
            item as Map<String, dynamic>? ?? {},
          ),
        )
        .toList();

    final rolling = rollingSource
        .map(
          (item) => RollingCorrelationModel.fromJson(
            item as Map<String, dynamic>? ?? {},
          ),
        )
        .toList();

    return MacroTrendsModel(
      annualInflationRates: inflationRates,
      inflationTimeline: inflationRates,
      correlationTable: correlation,
      rollingCorrelations: rolling,
    );
  }

  MacroTrendsData toEntity() {
    return MacroTrendsData(
      annualInflationRates: annualInflationRates
          .map((e) => e.toEntity())
          .toList(),
      inflationVsSupplyGrowth: const [],
      inflationTimeline: inflationTimeline
          .map((e) => e.toEntity())
          .toList(),
      correlationTable: correlationTable
          .map((e) => e.toEntity())
          .toList(),
      rollingCorrelations: rollingCorrelations
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}

class RollingCorrelationModel {
  final String date;
  final double correlation;

  RollingCorrelationModel({required this.date, required this.correlation});

  factory RollingCorrelationModel.fromJson(Map<String, dynamic> json) {
    return RollingCorrelationModel(
      date: json['date'] as String? ?? '',
      correlation: (json['correlation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  RollingCorrelationData toEntity() {
    return RollingCorrelationData(
      periodLabel: date,
      correlation: correlation,
    );
  }
}

