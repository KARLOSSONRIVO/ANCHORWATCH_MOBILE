class MacroTrendsData {
  final List<InflationRateData> annualInflationRates;
  final List<InflationSupplyData> inflationVsSupplyGrowth;
  final List<InflationRateData> inflationTimeline;
  final List<CorrelationData> correlationTable;
  final List<RollingCorrelationData> rollingCorrelations;

  MacroTrendsData({
    required this.annualInflationRates,
    required this.inflationVsSupplyGrowth,
    required this.inflationTimeline,
    required this.correlationTable,
    required this.rollingCorrelations,
  });
}

class InflationRateData {
  final int year;
  final String? period;
  final double? inflationRate;

  InflationRateData({
    required this.year,
    this.period,
    required this.inflationRate,
  });
}

class InflationSupplyData {
  final int year;
  final String? period;
  final double? inflationRate;
  final double? supplyGrowthPct;

  InflationSupplyData({
    required this.year,
    this.period,
    this.inflationRate,
    this.supplyGrowthPct,
  });
}

class CorrelationData {
  final String variable;
  final double inflationRate;
  final double price;
  final double marketCap;
  final double supplyClosing;
  final double netChangeUsd;

  CorrelationData({
    required this.variable,
    required this.inflationRate,
    required this.price,
    required this.marketCap,
    required this.supplyClosing,
    required this.netChangeUsd,
  });
}

class RollingCorrelationData {
  final String periodLabel;
  final double correlation;

  RollingCorrelationData({
    required this.periodLabel,
    required this.correlation,
  });
}