import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/macro_trends.dart';
import '../../../domain/usecases/dashboard/fetch_dashboard_metrics_usecase.dart';
import '../../../utils/date_formatter.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardMetricsUseCase _fetchUseCase;
  static const List<String> timePeriods = ['Monthly', 'Yearly'];
  static const Map<String, String> _heatLabelMap = {
    'price': 'Price',
    'market_cap': 'Market Cap',
    'supply_closing': 'Supply',
    'net_change_usd': 'Net Change',
    'inflation_rate': 'Inflation',
  };
  static const List<String> _heatOrder = [
    'price',
    'market_cap',
    'supply_closing',
    'net_change_usd',
    'inflation_rate',
  ];

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
      final heatmapData = _buildHeatmapFromCorrelation(
        metrics.macroTrendsData.correlationTable,
      );
      final heatCells = heatmapData?.cells ?? const <HeatCell>[];
      final heatVars = heatmapData?.labels ?? const <String>[];
      final rollingCorrSeries = _buildRollingCorrelationSeries(
        metrics.macroTrendsData.rollingCorrelations,
        period: timePeriod,
        monthlyLimit: unified.length,
      );

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
    rollingCorrSeries: rollingCorrSeries,
    heatCells: heatCells,
    heatVars: heatVars,
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
    return {
      'priceSeries': priceSeries,
      'marketCapSeries': marketCapSeries,
      'supplySeries': supplySeries,
      'inflationSeries': inflationSeries,
      'scatterPoints': scatterPoints,
    };
  }
  double _pctChange(double prev, double cur) => prev == 0 ? 0 : ((cur - prev) / prev) * 100;
  
  _HeatmapData? _buildHeatmapFromCorrelation(List<CorrelationData> table) {
    if (table.isEmpty) {
      return null;
    }

    final normalized = <String, CorrelationData>{};
    for (final entry in table) {
      final key = entry.variable.trim().toLowerCase().replaceAll(' ', '_');
      if (_heatLabelMap.containsKey(key)) {
        normalized[key] = entry;
      }
    }

    final orderedKeys = _heatOrder.where(normalized.containsKey).toList();
    if (orderedKeys.length < 2) {
      return null;
    }

    final labels = orderedKeys.map((key) => _heatLabelMap[key]!).toList();
    final cells = <HeatCell>[];

    for (var rowIndex = 0; rowIndex < orderedKeys.length; rowIndex++) {
      final rowKey = orderedKeys[rowIndex];
      final rowData = normalized[rowKey]!;
      for (var colIndex = 0; colIndex < orderedKeys.length; colIndex++) {
        final colKey = orderedKeys[colIndex];
        final value = _valueForVariable(rowData, colKey);
        cells.add(HeatCell(row: rowIndex, col: colIndex, value: value));
      }
    }

    return _HeatmapData(labels: labels, cells: cells);
  }

  List<LinePoint> _buildRollingCorrelationSeries(
    List<RollingCorrelationData> rows, {
    required String period,
    required int monthlyLimit,
  }) {
    if (rows.isEmpty) {
      return const <LinePoint>[];
    }

    final sortedRows = List<RollingCorrelationData>.from(rows)
      ..sort((a, b) {
        final dateA = DateFormatter.tryParsePeriodLabel(a.periodLabel);
        final dateB = DateFormatter.tryParsePeriodLabel(b.periodLabel);
        if (dateA != null && dateB != null) {
          return dateA.compareTo(dateB);
        }
        if (dateA != null) {
          return 1;
        }
        if (dateB != null) {
          return -1;
        }
        return a.periodLabel.compareTo(b.periodLabel);
      });

    final isMonthly = period.toLowerCase() == 'monthly';
    final series = sortedRows
        .map(
          (row) {
            final parsedDate = DateFormatter.tryParsePeriodLabel(row.periodLabel);
            final label = isMonthly && parsedDate != null
                ? DateFormatter.formatMonth(parsedDate)
                : row.periodLabel;
            return LinePoint(
              label,
              row.correlation,
            );
          },
        )
        .toList();

    if (period.toLowerCase() != 'monthly') {
      return series;
    }

    final boundedLimit = monthlyLimit <= 0
        ? 0
        : (monthlyLimit > series.length ? series.length : monthlyLimit);
    if (boundedLimit == 0) {
      return const <LinePoint>[];
    }
    if (boundedLimit >= series.length) {
      return series;
    }
    return series.sublist(series.length - boundedLimit);
  }

  double _valueForVariable(CorrelationData data, String key) {
    switch (key) {
      case 'price':
        return data.price;
      case 'market_cap':
        return data.marketCap;
      case 'supply_closing':
        return data.supplyClosing;
      case 'net_change_usd':
        return data.netChangeUsd;
      case 'inflation_rate':
        return data.inflationRate;
      default:
        return 0;
    }
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
      mintBurnChartData.add(
        MintBurnChartData(activity.date, activity.mintUsd, activity.burnUsd),
      );
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
    final supplyData = stablecoinData.totalSupplyOverTime;
    if (inflationRates.isNotEmpty && supplyData.isNotEmpty) {
      for (int i = 0; i < inflationRates.length && i < supplyData.length && i < 10; i++) {
        final inflation = inflationRates[i];
        final supply = supplyData[i];
        if (inflation.inflationRate != null) {
          correlationScatterData.add(
            ScatterChartData(
              inflation.inflationRate!,
              supply.supplyClosing,
              inflation.year.toString(),
            ),
          );
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

class _HeatmapData {
  final List<String> labels;
  final List<HeatCell> cells;

  _HeatmapData({required this.labels, required this.cells});
}

