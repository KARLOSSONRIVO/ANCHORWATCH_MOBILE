import 'package:equatable/equatable.dart';
class ChartData {
  final DateTime x;
  final double y;
  final String? category;
  
  ChartData(this.x, this.y, [this.category]);
}

class MintBurnChartData {
  final DateTime x;
  final double mint;
  final double burn;
  
  MintBurnChartData(this.x, this.mint, this.burn);
}

class ScatterChartData {
  final double x;
  final double y;
  final String label;
  
  ScatterChartData(this.x, this.y, this.label);
}
class YearlyPricePoint {
  final int year;
  final int month;
  final double price;
  
  YearlyPricePoint(this.year, this.price, {this.month = 1});
}

class YearlySupplyPoint {
  final int year;
  final int month;
  final double supply;
  
  YearlySupplyPoint(this.year, this.supply, {this.month = 1});
}

class YearlyMintBurn {
  final int year;
  final int month;
  final String chain;
  final double mint;
  final double burn;
  final double net;
  
  YearlyMintBurn(this.year, this.chain, this.mint, this.burn, this.net, {this.month = 1});
}

class YearlyMacro {
  final int year;
  final int month;
  final double inflation;
  final double gdp;
  
  YearlyMacro(this.year, this.inflation, this.gdp, {this.month = 1});
}
class LinePoint {
  final String x;
  final double y;
  
  LinePoint(this.x, this.y);
}

class ScatterPoint {
  final int year;
  final double x;
  final double y;
  
  ScatterPoint({required this.year, required this.x, required this.y});
}

class HeatCell {
  final int row;
  final int col;
  final double value;
  
  HeatCell({required this.row, required this.col, required this.value});
}

class UnifiedRow {
  final String timeId; // Can be year, month, week identifier
  final int year; // Keep for backward compatibility
  final double price;
  final double supply;
  final double marketCap;
  final double netChange;
  final double inflation;
  
  UnifiedRow({
    required this.timeId,
    int? year,
    required this.price,
    required this.supply,
    required this.marketCap,
    required this.netChange,
    required this.inflation,
  }) : year = year ?? int.tryParse(timeId) ?? DateTime.now().year;
}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardLoadedState extends DashboardState {
  final String selectedTimePeriod;
  final List<YearlyPricePoint> prices;
  final List<YearlySupplyPoint> supplies;
  final List<YearlyMintBurn> mintBurn;
  final List<YearlyMacro> macros;
  final List<UnifiedRow> unified;
  final List<LinePoint> priceSeries;
  final List<LinePoint> marketCapSeries;
  final List<LinePoint> supplySeries;
  final List<LinePoint> inflationSeries;
  final List<ScatterPoint> scatterPoints;
  final List<LinePoint> rollingCorrSeries;
  final List<HeatCell> heatCells;
  final List<String> heatVars;
  final List<ChartData> supplyChartData;
  final List<ChartData> priceChartData;
  final List<ChartData> inflationChartData;
  final List<MintBurnChartData> mintBurnChartData;
  final List<ScatterChartData> correlationScatterData;
  
  const DashboardLoadedState({
    required this.selectedTimePeriod,
    required this.prices,
    required this.supplies,
    required this.mintBurn,
    required this.macros,
    required this.unified,
    required this.priceSeries,
    required this.marketCapSeries,
    required this.supplySeries,
    required this.inflationSeries,
    required this.scatterPoints,
    required this.rollingCorrSeries,
    required this.heatCells,
    required this.heatVars,
    required this.supplyChartData,
    required this.priceChartData,
    required this.inflationChartData,
    required this.mintBurnChartData,
    required this.correlationScatterData,
  });

  @override
  List<Object?> get props => [
    selectedTimePeriod,
    prices,
    supplies,
    mintBurn,
    macros,
    unified,
    priceSeries,
    marketCapSeries,
    supplySeries,
    inflationSeries,
    scatterPoints,
    rollingCorrSeries,
    heatCells,
    heatVars,
    supplyChartData,
    priceChartData,
    inflationChartData,
    mintBurnChartData,
    correlationScatterData,
  ];

  DashboardLoadedState copyWith({
    String? selectedTimePeriod,
    List<YearlyPricePoint>? prices,
    List<YearlySupplyPoint>? supplies,
    List<YearlyMintBurn>? mintBurn,
    List<YearlyMacro>? macros,
    List<UnifiedRow>? unified,
    List<LinePoint>? priceSeries,
    List<LinePoint>? marketCapSeries,
    List<LinePoint>? supplySeries,
    List<LinePoint>? inflationSeries,
    List<ScatterPoint>? scatterPoints,
    List<LinePoint>? rollingCorrSeries,
    List<HeatCell>? heatCells,
    List<String>? heatVars,
    List<ChartData>? supplyChartData,
    List<ChartData>? priceChartData,
    List<ChartData>? inflationChartData,
    List<MintBurnChartData>? mintBurnChartData,
    List<ScatterChartData>? correlationScatterData,
  }) {
    return DashboardLoadedState(
      selectedTimePeriod: selectedTimePeriod ?? this.selectedTimePeriod,
      prices: prices ?? this.prices,
      supplies: supplies ?? this.supplies,
      mintBurn: mintBurn ?? this.mintBurn,
      macros: macros ?? this.macros,
      unified: unified ?? this.unified,
      priceSeries: priceSeries ?? this.priceSeries,
      marketCapSeries: marketCapSeries ?? this.marketCapSeries,
      supplySeries: supplySeries ?? this.supplySeries,
      inflationSeries: inflationSeries ?? this.inflationSeries,
      scatterPoints: scatterPoints ?? this.scatterPoints,
      rollingCorrSeries: rollingCorrSeries ?? this.rollingCorrSeries,
      heatCells: heatCells ?? this.heatCells,
      heatVars: heatVars ?? this.heatVars,
      supplyChartData: supplyChartData ?? this.supplyChartData,
      priceChartData: priceChartData ?? this.priceChartData,
      inflationChartData: inflationChartData ?? this.inflationChartData,
      mintBurnChartData: mintBurnChartData ?? this.mintBurnChartData,
      correlationScatterData: correlationScatterData ?? this.correlationScatterData,
    );
  }
}

class DashboardErrorState extends DashboardState {
  final String message;
  
  const DashboardErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
}
