import '../../../domain/entities/macro_trends.dart';

class InflationRateModel {
  final int year;
  final String? period;
  final double? inflationRate;

  InflationRateModel({required this.year, this.period, this.inflationRate});

  factory InflationRateModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'year' (yearly) and 'period' (monthly) fields
    int yearValue = 0;
    String? periodValue;
    
    if (json['year'] != null) {
      yearValue = json['year'] as int;
    } else if (json['period'] != null) {
      periodValue = json['period'] as String;
      // Extract year from period string (e.g., "2023-01" -> 2023)
      try {
        yearValue = int.parse(periodValue.split('-')[0]);
      } catch (e) {
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
    return InflationRateData(year: year, period: period, inflationRate: inflationRate);
  }
}

class MacroTrendsModel {
  final List<InflationRateModel> annualInflationRates;

  MacroTrendsModel({required this.annualInflationRates});

  factory MacroTrendsModel.fromJson(Map<String, dynamic> json) {
    // Handle the API response wrapper - data is nested under 'data' key
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return MacroTrendsModel(
      annualInflationRates:
          (data['annual_inflation_rates'] as List<dynamic>?)
              ?.map(
                (item) => InflationRateModel.fromJson(
                  item as Map<String, dynamic>? ?? {},
                ),
              )
              .toList() ??
          [],
    );
  }

  MacroTrendsData toEntity() {
    return MacroTrendsData(
      annualInflationRates: annualInflationRates
          .map((e) => e.toEntity())
          .toList(),
      inflationVsSupplyGrowth:
          [], // Empty for now - your API doesn't provide this
      inflationTimeline: annualInflationRates
          .map((e) => e.toEntity())
          .toList(), // Use same data
      correlationTable: [], // Empty for now - your API doesn't provide this
    );
  }
}
