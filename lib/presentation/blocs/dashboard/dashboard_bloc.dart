import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/dashboard/fetch_dashboard_metrics_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardMetricsUseCase _fetchUseCase;

  // Time period options
  static const List<String> timePeriods = ['Monthly', 'Yearly'];

  DashboardBloc(this._fetchUseCase) : super(const DashboardInitialState()) {
    on<DashboardInitialLoadEvent>(_onInitialLoad);
    on<DashboardRefreshEvent>(_onRefresh);
    on<DashboardTimePeriodChangedEvent>(_onTimePeriodChanged);
  }

  Future<void> _onInitialLoad(
    DashboardInitialLoadEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    await _loadData(emit, 'Yearly');
  }

  Future<void> _onRefresh(
    DashboardRefreshEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoadedState) {
      emit(const DashboardLoadingState());
      await _loadData(emit, currentState.selectedTimePeriod);
    } else {
      await _loadData(emit, 'Yearly');
    }
  }

  Future<void> _onTimePeriodChanged(
    DashboardTimePeriodChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    await _loadData(emit, event.timePeriod);
  }

  Future<void> _loadData(Emitter<DashboardState> emit, String timePeriod) async {
    try {
      final metrics = await _fetchUseCase.call(timePeriod.toLowerCase());
      
      // Parse raw data
      final prices = <YearlyPricePoint>[];
      final supplies = <YearlySupplyPoint>[];
      final mintBurn = <YearlyMintBurn>[];
      final macros = <YearlyMacro>[];

      // Map from metrics to our data structures
      _mapFromMetrics(metrics, prices, supplies, mintBurn, macros, timePeriod);

      // Build unified data
      final unified = _buildUnified(prices, supplies, mintBurn, macros, timePeriod);

      // Build derived series
      final derivedData = _buildDerived(unified);

      // Build chart data for Syncfusion
      final chartData = _buildChartData(metrics);

      emit(DashboardLoadedState(
        selectedTimePeriod: timePeriod,
        prices: prices,
        supplies: supplies,
        mintBurn: mintBurn,
        macros: macros,
        unified: unified,
        priceSeries: derivedData['priceSeries'] as List<LinePoint>,
        marketCapSeries: derivedData['marketCapSeries'] as List<LinePoint>,
        supplySeries: derivedData['supplySeries'] as List<LinePoint>,
        inflationSeries: derivedData['inflationSeries'] as List<LinePoint>,
        scatterPoints: derivedData['scatterPoints'] as List<ScatterPoint>,
        rollingCorrSeries: derivedData['rollingCorrSeries'] as List<LinePoint>,
        heatCells: derivedData['heatCells'] as List<HeatCell>,
        heatVars: ['Price', 'Supply', 'Inflation', 'NetChange'],
        supplyChartData: chartData['supply'] as List<ChartData>,
        priceChartData: chartData['price'] as List<ChartData>,
        inflationChartData: chartData['inflation'] as List<ChartData>,
        mintBurnChartData: chartData['mintBurn'] as List<MintBurnChartData>,
        correlationScatterData: chartData['correlation'] as List<ScatterChartData>,
      ));
    } catch (e) {
      emit(DashboardErrorState('Failed to load dashboard data: $e'));
    }
  }

  void _mapFromMetrics(
    dynamic metrics,
    List<YearlyPricePoint> prices,
    List<YearlySupplyPoint> supplies,
    List<YearlyMintBurn> mintBurn,
    List<YearlyMacro> macros,
    String timePeriod,
  ) {
    final now = DateTime.now();
    
    // Process stablecoin data
    final stablecoinData = metrics.stablecoinData;
    
    // Process supply data points
    for (final point in stablecoinData.totalSupplyOverTime) {
      if (_shouldIncludeDataPoint(point.date, now, timePeriod)) {
        supplies.add(YearlySupplyPoint(
          point.date.year, 
          point.supplyClosing, 
          month: timePeriod.toLowerCase() == 'monthly' ? point.date.month : 1
        ));
      }
    }

    // Process mint burn activity
    for (final activity in stablecoinData.mintBurnActivity) {
      if (_shouldIncludeDataPoint(activity.date, now, timePeriod)) {
        mintBurn.add(YearlyMintBurn(
          activity.date.year, 
          '${activity.date.year}', 
          activity.mintUsd, 
          activity.burnUsd, 
          activity.netChange,
          month: timePeriod.toLowerCase() == 'monthly' ? activity.date.month : 1
        ));
      }
    }

    // Process macro trends data
    final macroData = metrics.macroTrendsData;
    
    // Process annual inflation rates
    for (final inflation in macroData.annualInflationRates) {
      macros.add(YearlyMacro(
        inflation.year, 
        inflation.inflationRate ?? 0.0, 
        0.0,
        month: 1 // Macro data is typically yearly
      ));
    }

    // Add some mock price data based on supply data for visualization
    for (final supply in supplies) {
      // Calculate mock market cap based on supply (simplified)
      final mockMarketCap = supply.supply * 1.0; // Assume $1 per token
      prices.add(YearlyPricePoint(supply.year, mockMarketCap, month: supply.month));
    }
  }

  bool _shouldIncludeDataPoint(DateTime dataDate, DateTime now, String timePeriod) {
    switch (timePeriod.toLowerCase()) {
      case 'monthly':
        // Past 12 months
        return now.difference(dataDate).inDays <= 365;
      case 'yearly':
      default:
        // All data (10 year window)
        final yearDiff = now.year - dataDate.year;
        if (yearDiff > 10) return false;
        if (yearDiff == 10 && now.month < dataDate.month) return false;
        return true;
    }
  }

  List<UnifiedRow> _buildUnified(
    List<YearlyPricePoint> prices,
    List<YearlySupplyPoint> supplies,
    List<YearlyMintBurn> mintBurn,
    List<YearlyMacro> macros,
    String timePeriod,
  ) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    if (timePeriod.toLowerCase() == 'monthly') {
      // For monthly view, group data by actual month numbers
      final monthData = <int, List<YearlyMintBurn>>{}; // Group by month number
      
      // Parse mintBurn data to extract months
      for (int i = 0; i < mintBurn.length; i++) {
        final mb = mintBurn[i];
        final monthNum = mb.month;
        
        if (monthNum >= 1 && monthNum <= 12) {
          monthData.putIfAbsent(monthNum, () => []).add(mb);
        }
      }
      
      // Build unified rows only for months that have actual data
      final unified = <UnifiedRow>[];
      
      // Only process months that have actual mint/burn data
      final availableMonths = monthData.keys.toList()..sort();
      
      for (final monthNum in availableMonths) {
        final monthName = monthNames[monthNum - 1];
        
        double totalMint = 0.0;
        double totalBurn = 0.0;
        double netChange = 0.0;
        
        final monthMintBurn = monthData[monthNum]!;
        
        // Aggregate data for this month across all years
        totalMint = monthMintBurn.fold(0.0, (sum, mb) => sum + mb.mint);
        totalBurn = monthMintBurn.fold(0.0, (sum, mb) => sum + mb.burn);
        netChange = totalMint - totalBurn;
        
        // Find price, supply and inflation data that corresponds to this month
        double price = 1.0;
        double supply = 0.0;
        double inflation = double.nan;
        
        // For monthly view, use the most recent available price across all data
        if (prices.isNotEmpty) {
          price = prices.last.price;
        }
        
        // Find month-specific supply data for more accurate supply values
        final matchingSupplies = supplies.where((s) => s.month == monthNum);
        if (matchingSupplies.isNotEmpty) {
          supply = matchingSupplies.last.supply;
        } else if (supplies.isNotEmpty) {
          supply = supplies.last.supply;
        }
        
        final matchingMacros = macros.where((m) => m.month == monthNum);
        if (matchingMacros.isNotEmpty) {
          inflation = matchingMacros.last.inflation;
        } else if (macros.isNotEmpty) {
          inflation = macros.last.inflation;
        }
        
        unified.add(UnifiedRow(
          timeId: monthName,
          year: DateTime.now().year, // Use current year for backward compatibility
          price: price,
          supply: supply,
          marketCap: price * supply,
          netChange: netChange,
          inflation: inflation.isNaN ? 0.0 : inflation,
        ));
      }
      
      return unified;
    } else {
      // Yearly view - existing logic
      final timeIds = <String>{};
      timeIds.addAll(prices.map((e) => e.year.toString()));
      timeIds.addAll(supplies.map((e) => e.year.toString()));
      timeIds.addAll(mintBurn.map((e) => e.year.toString()));
      timeIds.addAll(macros.map((e) => e.year.toString()));
      
      final sortedTimeIds = timeIds.toList()..sort();
      
      final unified = <UnifiedRow>[];
      for (final timeId in sortedTimeIds) {
        final year = int.tryParse(timeId) ?? DateTime.now().year;
        final price = prices.firstWhere((p) => p.year == year, orElse: () => YearlyPricePoint(year, 1.0, month: 1)).price;
        final supply = supplies.firstWhere((s) => s.year == year, orElse: () => YearlySupplyPoint(year, 0.0, month: 1)).supply;
        final mintBurnData = mintBurn.where((mb) => mb.year == year);
        final netChange = mintBurnData.fold(0.0, (sum, mb) => sum + mb.net);
        final inflation = macros.firstWhere((m) => m.year == year, orElse: () => YearlyMacro(year, double.nan, double.nan, month: 1)).inflation;
        
        unified.add(UnifiedRow(
          timeId: timeId,
          year: year,
          price: price,
          supply: supply,
          marketCap: price * supply,
          netChange: netChange,
          inflation: inflation.isNaN ? 0.0 : inflation,
        ));
      }
      
      return unified;
    }
  }

  Map<String, dynamic> _buildDerived(List<UnifiedRow> unified) {
    final priceSeries = <LinePoint>[];
    final marketCapSeries = <LinePoint>[];
    final supplySeries = <LinePoint>[];
    final inflationSeries = <LinePoint>[];
    final scatterPoints = <ScatterPoint>[];
    final rollingCorrSeries = <LinePoint>[];
    final heatCells = <HeatCell>[];

    // Build basic series
    for (final row in unified) {
      priceSeries.add(LinePoint(row.timeId, row.price));
      marketCapSeries.add(LinePoint(row.timeId, row.marketCap / 1e6)); // Convert to millions
      supplySeries.add(LinePoint(row.timeId, row.supply / 1e6)); // Convert to millions
      inflationSeries.add(LinePoint(row.timeId, row.inflation));
    }

    // Build scatter points (price change vs supply change)
    for (int i = 1; i < unified.length; i++) {
      final curr = unified[i];
      final prev = unified[i - 1];
      
      if (prev.price > 0 && prev.supply > 0) {
        final priceChange = ((curr.price - prev.price) / prev.price) * 100;
        final supplyChange = ((curr.supply - prev.supply) / prev.supply) * 100;
        scatterPoints.add(ScatterPoint(year: curr.year, x: supplyChange, y: priceChange));
      }
    }

    // Build rolling correlation (simplified)
    for (int i = 2; i < unified.length; i++) {
      final subset = unified.sublist(max(0, i - 2), i + 1);
      final corr = _calculateCorrelation(
        subset.map((r) => r.supply).toList(),
        subset.map((r) => r.marketCap).toList(),
      );
      rollingCorrSeries.add(LinePoint(unified[i].year.toString(), corr));
    }

    // Build correlation heatmap
    final priceArr = unified.map((e) => e.price).toList();
    final supplyArr = unified.map((e) => e.supply).toList();
    final inflArr = unified.map((e) => e.inflation).toList();
    final netArr = unified.map((e) => e.netChange).toList();
    final vars = [priceArr, supplyArr, inflArr, netArr];

    for (int i = 0; i < vars.length; i++) {
      for (int j = 0; j < vars.length; j++) {
        final corr = _calculateCorrelation(vars[i], vars[j]);
        heatCells.add(HeatCell(row: i, col: j, value: corr));
      }
    }

    return {
      'priceSeries': priceSeries,
      'marketCapSeries': marketCapSeries,
      'supplySeries': supplySeries,
      'inflationSeries': inflationSeries,
      'scatterPoints': scatterPoints,
      'rollingCorrSeries': rollingCorrSeries,
      'heatCells': heatCells,
    };
  }

  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return 0.0;
    
    final n = x.length;
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;
    
    double numerator = 0.0;
    double denomX = 0.0;
    double denomY = 0.0;
    
    for (int i = 0; i < n; i++) {
      final diffX = x[i] - meanX;
      final diffY = y[i] - meanY;
      numerator += diffX * diffY;
      denomX += diffX * diffX;
      denomY += diffY * diffY;
    }
    
    final denominator = sqrt(denomX * denomY);
    return denominator == 0 ? 0.0 : numerator / denominator;
  }

  Map<String, List> _buildChartData(dynamic metrics) {
    final supplyChartData = <ChartData>[];
    final priceChartData = <ChartData>[];
    final inflationChartData = <ChartData>[];
    final mintBurnChartData = <MintBurnChartData>[];
    final correlationScatterData = <ScatterChartData>[];

    final stablecoinData = metrics.stablecoinData;
    final macroData = metrics.macroTrendsData;

    // Build supply chart data
    for (final point in stablecoinData.totalSupplyOverTime) {
      supplyChartData.add(ChartData(point.date, point.supplyClosing));
    }

    // Build mint/burn chart data
    for (final activity in stablecoinData.mintBurnActivity) {
      mintBurnChartData.add(MintBurnChartData(activity.date, activity.mintUsd, activity.burnUsd));
    }

    // Build inflation chart data
    if (macroData.annualInflationRates.isNotEmpty) {
      for (final inflation in macroData.annualInflationRates) {
        if (inflation.inflationRate != null) {
          final date = DateTime(inflation.year);
          inflationChartData.add(ChartData(date, inflation.inflationRate!));
        }
      }
    }
    
    // Add mock inflation data if no real data is available
    if (inflationChartData.isEmpty) {
      inflationChartData.add(ChartData(DateTime(2024), 3.2));
      inflationChartData.add(ChartData(DateTime(2023), 6.0));
      inflationChartData.add(ChartData(DateTime(2022), 5.8));
    }

    // Build mock price data from supply (since we don't have real price data)
    for (final supplyPoint in supplyChartData) {
      // Create mock price based on supply changes
      final mockPrice = supplyPoint.y * 1.0; // Simplified calculation
      priceChartData.add(ChartData(supplyPoint.x, mockPrice));
    }

    // Build correlation scatter data from available data
    // Since correlationTable is empty, create scatter data from inflation vs supply data
    final inflationRates = macroData.annualInflationRates;
    final supplyData = stablecoinData.totalSupplyOverTime;
    
    if (inflationRates.isNotEmpty && supplyData.isNotEmpty) {
      for (int i = 0; i < inflationRates.length && i < supplyData.length && i < 10; i++) {
        final inflation = inflationRates[i];
        final supply = supplyData[i];
        if (inflation.inflationRate != null) {
          correlationScatterData.add(ScatterChartData(
            inflation.inflationRate!, 
            supply.supplyClosing, 
            inflation.year.toString()
          ));
        }
      }
    }
    
    // Add mock scatter data if no real data is available
    if (correlationScatterData.isEmpty) {
      correlationScatterData.add(ScatterChartData(3.2, 100000, '2024'));
      correlationScatterData.add(ScatterChartData(6.0, 95000, '2023'));
      correlationScatterData.add(ScatterChartData(5.8, 90000, '2022'));
    }

    return {
      'supply': supplyChartData,
      'price': priceChartData,
      'inflation': inflationChartData,
      'mintBurn': mintBurnChartData,
      'correlation': correlationScatterData,
    };
  }
}