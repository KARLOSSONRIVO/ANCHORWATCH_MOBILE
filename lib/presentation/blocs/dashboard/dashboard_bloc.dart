import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/dashboard/fetch_dashboard_metrics_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardMetricsUseCase _fetchUseCase;
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
      final prices = <YearlyPricePoint>[];
      final supplies = <YearlySupplyPoint>[];
      final mintBurn = <YearlyMintBurn>[];
      final macros = <YearlyMacro>[];
      _mapFromMetrics(metrics, prices, supplies, mintBurn, macros, timePeriod);
      final unified = _buildUnified(prices, supplies, mintBurn, macros, timePeriod);
      final derivedData = _buildDerived(unified);
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
    final stablecoinData = metrics.stablecoinData;
    for (final point in stablecoinData.totalSupplyOverTime) {
      if (_shouldIncludeDataPoint(point.date, now, timePeriod)) {
        if (point.price != null && point.price! > 0) {
          prices.add(YearlyPricePoint(
            point.date.year, 
            point.price!, 
            month: timePeriod.toLowerCase() == 'monthly' ? point.date.month : 1
          ));
        }
        
        supplies.add(YearlySupplyPoint(
          point.date.year, 
          point.supplyClosing, 
          month: timePeriod.toLowerCase() == 'monthly' ? point.date.month : 1
        ));
      }
    }
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
    final macroData = metrics.macroTrendsData;
    for (final inflation in macroData.annualInflationRates) {
      macros.add(YearlyMacro(
        inflation.year, 
        inflation.inflationRate ?? 0.0, 
        0.0,
        month: 1 
      ));
    }
    if (macroData.correlationTable.isNotEmpty) {
      for (final corr in macroData.correlationTable) {
        if (corr.price > 0) {
          int year = DateTime.now().year;
          try {
            final yearMatch = RegExp(r'\d{4}').firstMatch(corr.variable);
            if (yearMatch != null) {
              year = int.parse(yearMatch.group(0)!);
            }
          } catch (_) {}
          if (!prices.any((p) => p.year == year)) {
            prices.add(YearlyPricePoint(
              year, 
              corr.price, 
              month: timePeriod.toLowerCase() == 'monthly' ? DateTime.now().month : 1
            ));
          }
        }
      }
    }
    if (prices.isEmpty) {
      prices.add(YearlyPricePoint(
        DateTime.now().year, 
        1.0, 
        month: timePeriod.toLowerCase() == 'monthly' ? DateTime.now().month : 1
      ));
    }
  }

  bool _shouldIncludeDataPoint(DateTime dataDate, DateTime now, String timePeriod) {
    switch (timePeriod.toLowerCase()) {
      case 'monthly':
        if (dataDate.isAfter(now)) return false;
        if (dataDate.year == now.year && dataDate.month > now.month) return false;
        return now.difference(dataDate).inDays <= 365;
      case 'yearly':
      default:
        if (dataDate.year > now.year) return false;
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
      final monthData = <int, List<YearlyMintBurn>>{};
      for (int i = 0; i < mintBurn.length; i++) {
        final mb = mintBurn[i];
        final monthNum = mb.month;
        
        if (monthNum >= 1 && monthNum <= 12) {
          monthData.putIfAbsent(monthNum, () => []).add(mb);
        }
      }
      final unified = <UnifiedRow>[];
      final now = DateTime.now();
      final availableMonths = monthData.keys.where((monthNum) {
        return monthNum <= now.month;
      }).toList()..sort();
      
      for (final monthNum in availableMonths) {
        final monthName = monthNames[monthNum - 1];
        
        double totalMint = 0.0;
        double totalBurn = 0.0;
        double netChange = 0.0;
        
        final monthMintBurn = monthData[monthNum]!;
        totalMint = monthMintBurn.fold(0.0, (sum, mb) => sum + mb.mint);
        totalBurn = monthMintBurn.fold(0.0, (sum, mb) => sum + mb.burn);
        netChange = totalMint - totalBurn;
        double price = 1.0;
        double supply = 0.0;
        double inflation = double.nan;
        if (prices.isNotEmpty) {
          price = prices.last.price;
        } else {
          price = 1.0;
        }
        final matchingSupplies = supplies.where((s) => s.month == monthNum);
        if (matchingSupplies.isNotEmpty) {
          supply = matchingSupplies.last.supply;
        } else if (supplies.isNotEmpty) {
          supply = supplies.last.supply;
        }
        
        int inflationYear = now.year; 
        
        final yearlyInflation = macros.firstWhere(
          (m) => m.year == inflationYear, 
          orElse: () => YearlyMacro(inflationYear, 0.0, double.nan) 
        );
        inflation = yearlyInflation.inflation;
        
        unified.add(UnifiedRow(
          timeId: monthName,
          year: inflationYear, 
          price: price,
          supply: supply,
          marketCap: price * supply,
          netChange: netChange,
          inflation: inflation.isNaN ? 0.0 : inflation, 
        ));
      }
      
      return unified;
    } else {
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
    for (final row in unified) {
      priceSeries.add(LinePoint(row.timeId, row.price));
      supplySeries.add(LinePoint(row.timeId, row.supply / 1e6)); // scale
      marketCapSeries.add(LinePoint(row.timeId, row.price * row.supply / 1e6));
      inflationSeries.add(LinePoint(row.timeId, row.inflation.isNaN ? 0 : row.inflation));
    }
    for (var i = 1; i < unified.length; i++) {
      final prev = unified[i - 1]; 
      final cur = unified[i];
      final supplyCh = _pctChange(prev.supply, cur.supply);
      final priceCh = _pctChange(prev.price, cur.price);
      scatterPoints.add(ScatterPoint(year: cur.year, x: supplyCh, y: priceCh));
    }
    final priceArr = unified.map((e) => e.price).toList();
    final supplyArr = unified.map((e) => e.supply / 1e6).toList(); 
    final inflArr = unified.map((e) => e.inflation.isNaN ? 0 : e.inflation).toList();
    final netArr = unified.map((e) => e.netChange / 1e6).toList(); 
    final vars = [priceArr, supplyArr, inflArr, netArr];
    
    for (var i = 0; i < vars.length; i++) {
      for (var j = 0; j < vars.length; j++) {
        final a = vars[i].map((e) => e.toDouble()).toList();
        final b = vars[j].map((e) => e.toDouble()).toList();
        heatCells.add(HeatCell(row: i, col: j, value: _corr(a, b)));
      }
    }
    if (unified.length >= 2) {
      for (var w = 2; w <= unified.length; w++) {
        final subSupply = unified.sublist(0, w).map((e) => e.supply).toList();
        final subMc = unified.sublist(0, w).map((e) => e.price * e.supply).toList();
        rollingCorrSeries.add(LinePoint(unified[w - 1].timeId, _corr(subSupply, subMc)));
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
  double _pctChange(double prev, double cur) => prev == 0 ? 0 : ((cur - prev) / prev) * 100;
  
  double _corr(List<double> a, List<double> b) {
    final n = a.length < b.length ? a.length : b.length; 
    if (n == 0) return 0;
    if (n == 1) return 1.0; 
    
    final ma = a.take(n).reduce((x, y) => x + y) / n; 
    final mb = b.take(n).reduce((x, y) => x + y) / n;
    double num = 0, da = 0, db = 0; 
    for (var i = 0; i < n; i++) { 
      final xa = a[i] - ma; 
      final yb = b[i] - mb; 
      num += xa * yb; 
      da += xa * xa; 
      db += yb * yb; 
    }
    if (da == 0 || db == 0) return identical(a, b) ? 1.0 : 0.0; 
    return num / sqrt(da * db);
  }

  Map<String, List> _buildChartData(dynamic metrics) {
    final supplyChartData = <ChartData>[];
    final priceChartData = <ChartData>[];
    final inflationChartData = <ChartData>[];
    final mintBurnChartData = <MintBurnChartData>[];
    final correlationScatterData = <ScatterChartData>[];

    final stablecoinData = metrics.stablecoinData;
    final macroData = metrics.macroTrendsData;
    for (final point in stablecoinData.totalSupplyOverTime) {
      supplyChartData.add(ChartData(point.date, point.supplyClosing));
    }
    for (final activity in stablecoinData.mintBurnActivity) {
      mintBurnChartData.add(MintBurnChartData(activity.date, activity.mintUsd, activity.burnUsd));
    }
    if (macroData.annualInflationRates.isNotEmpty) {
      for (final inflation in macroData.annualInflationRates) {
        if (inflation.inflationRate != null) {
          final date = DateTime(inflation.year);
          inflationChartData.add(ChartData(date, inflation.inflationRate!));
        }
      }
    }
    if (macroData.correlationTable.isNotEmpty) {
      for (final corr in macroData.correlationTable) {
      if (corr.price > 0) {
        int year = DateTime.now().year;
        try {
          final yearMatch = RegExp(r'\d{4}').firstMatch(corr.variable);
          if (yearMatch != null) {
            year = int.parse(yearMatch.group(0)!);
          }
        } catch (_) {}
        priceChartData.add(ChartData(DateTime(year), corr.price));
      }
    }
  }
  final inflationRates = macroData.annualInflationRates;
  final supplyData = stablecoinData.totalSupplyOverTime;    if (inflationRates.isNotEmpty && supplyData.isNotEmpty) {
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

    return {
      'supply': supplyChartData,
      'price': priceChartData,
      'inflation': inflationChartData,
      'mintBurn': mintBurnChartData,
      'correlation': correlationScatterData,
    };
  }
}

