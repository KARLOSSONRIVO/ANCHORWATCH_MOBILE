import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../injection_container.dart';
import '../../blocs/discover/stablecoin/stablecoin.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/chart_summary_widget.dart';
import '../../themes/app_theme.dart';

class StablecoinView extends StatelessWidget {
  const StablecoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<StablecoinBloc>()..add(const StablecoinInitializeRequested()),
      child: const _StablecoinView(),
    );
  }
}

class _StablecoinView extends StatelessWidget {
  const _StablecoinView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StablecoinBloc, StablecoinState>(
      builder: (context, state) {
        if (state.status == StablecoinStatus.loading &&
            state.chartData == null) {
          return const Center(
            child: LoadingWidget(
              size: 48.0,
              color: Color(0xFF00D4AA),
              text: 'Loading Stablecoin Data...',
            ),
          );
        }

        if (state.status == StablecoinStatus.error && state.chartData == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'An unexpected error occurred',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<StablecoinBloc>().add(
                      const StablecoinRefreshRequested(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Container(
          color: AppTheme.getBackgroundColor(context),
          child: RefreshIndicator(
            color: const Color(0xFF00D4AA),
            onRefresh: () async {
              context.read<StablecoinBloc>().add(
                const StablecoinRefreshRequested(),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Period',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildDropdown(context, state),
                      ],
                    ),
                  ),
                  _card(
                    context,
                    state,
                    title: 'Total Supply Over Time',
                    child: _totalSupplyChart(state),
                    chartType: 'total_supply_over_time',
                  ),
                  _card(
                    context,
                    state,
                    title: 'Mint vs Burn Activity',
                    child: _mintBurnChart(state),
                    chartType: 'mint_burn_activity',
                  ),
                  _card(
                    context,
                    state,
                    title: 'Net Change in Supply',
                    child: _netChangeChart(state),
                    chartType: 'net_change_in_supply',
                  ),
                  _card(
                    context,
                    state,
                    title: 'Rolling Average Supply Changes',
                    child: _rollingAverageChart(state),
                    chartType: 'rolling_average_supply_changes',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    StablecoinState state, {
    required String title,
    String? subtitle,
    required Widget child,
    required String chartType,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.getCardBackgroundColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Theme.of(context).dividerColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                  border: Border.all(color: const Color(0xFF00D4AA)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF00D4AA),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(height: 240, child: child),
        ChartSummaryWidget(
          chartType: chartType,
          chartTitle: title,
          timeFrame: state.selectedPeriod,
          chartData: _getChartDataForType(state, chartType),
        ),
      ],
    ),
  );

  Widget _buildDropdown(BuildContext context, StablecoinState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: PopupMenuButton<String>(
          initialValue: state.selectedPeriod == 'yearly' ? 'Yearly' : 'Monthly',
          onSelected: (String value) {
            final period = value.toLowerCase();
            context.read<StablecoinBloc>().add(
              StablecoinAggregationPeriodChanged(period),
            );
          },
          color: AppTheme.getSurfaceColor(context),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppTheme.getBorderColor(context), width: 1),
          ),
          offset: const Offset(0, 45),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.selectedPeriod == 'yearly' ? 'Yearly' : 'Monthly',
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.getTextPrimaryColor(context),
                size: 18,
              ),
            ],
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'Monthly',
              padding: EdgeInsets.zero,
              mouseCursor: SystemMouseCursors.click,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                child: Text(
                  'Monthly',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Yearly',
              padding: EdgeInsets.zero,
              mouseCursor: SystemMouseCursors.click,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                child: Text(
                  'Yearly',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalSupplyChart(StablecoinState state) {
    return Builder(
      builder: (context) {
        final labelColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ??
            Colors.white54;
        final titleColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.white70;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5,
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                labelStyle: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: state.selectedPeriod == 'yearly' ? 'Year' : 'Month',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                intervalType: state.selectedPeriod == 'yearly'
                    ? DateTimeIntervalType.years
                    : DateTimeIntervalType.months,
                interval: 1,
                dateFormat: state.selectedPeriod == 'yearly'
                    ? DateFormat.y()
                    : DateFormat.MMM(),
                majorTickLines: const MajorTickLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(color: titleColor, fontSize: 11),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: 'Total Supply',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                numberFormat: NumberFormat.compact(),
              ),
              series: <CartesianSeries>[
                AreaSeries<Map<String, dynamic>, DateTime>(
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['totalSupply'],
                  color: const Color(0xFF00D4AA).withValues(alpha: 0.3),
                  borderColor: const Color(0xFF00D4AA),
                  borderWidth: 2,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00D4AA).withValues(alpha: 0.4),
                      const Color(0xFF00D4AA).withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mintBurnChart(StablecoinState state) {
    return Builder(
      builder: (context) {
        final labelColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ??
            Colors.white54;
        final titleColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.white70;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5,
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                labelStyle: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: state.selectedPeriod == 'yearly' ? 'Year' : 'Month',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                intervalType: state.selectedPeriod == 'yearly'
                    ? DateTimeIntervalType.years
                    : DateTimeIntervalType.months,
                interval: 1,
                dateFormat: state.selectedPeriod == 'yearly'
                    ? DateFormat.y()
                    : DateFormat.MMM(),
                majorTickLines: const MajorTickLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(color: titleColor, fontSize: 11),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: 'Amount',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                numberFormat: NumberFormat.compact(),
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: titleColor, fontSize: 10),
              ),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, DateTime>(
                  name: 'Mint',
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['mintAmount'] ?? 0,
                  color: const Color(0xFF00D4AA),
                  borderRadius: BorderRadius.circular(4),
                  width: 0.8,
                ),
                ColumnSeries<Map<String, dynamic>, DateTime>(
                  name: 'Burn',
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['burnAmount'] ?? 0,
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(4),
                  width: 0.8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _netChangeChart(StablecoinState state) {
    return Builder(
      builder: (context) {
        final labelColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ??
            Colors.white54;
        final titleColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.white70;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5,
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                labelStyle: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: state.selectedPeriod == 'yearly' ? 'Year' : 'Month',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                intervalType: state.selectedPeriod == 'yearly'
                    ? DateTimeIntervalType.years
                    : DateTimeIntervalType.months,
                interval: 1,
                dateFormat: state.selectedPeriod == 'yearly'
                    ? DateFormat.y()
                    : DateFormat.MMM(),
                majorTickLines: const MajorTickLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(color: titleColor, fontSize: 11),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: 'Net Change',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                numberFormat: NumberFormat.compact(),
              ),
              series: <CartesianSeries>[
                LineSeries<Map<String, dynamic>, DateTime>(
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      (data['mintAmount'] ?? 0) - (data['burnAmount'] ?? 0),
                  color: const Color(0xFF00D4AA),
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderColor: Color(0xFF00D4AA),
                    color: Color(0xFF00D4AA),
                    borderWidth: 2,
                    width: 6,
                    height: 6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rollingAverageChart(StablecoinState state) {
    return Builder(
      builder: (context) {
        final labelColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ??
            Colors.white54;
        final titleColor =
            Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
            Colors.white70;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5,
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                labelStyle: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: state.selectedPeriod == 'yearly' ? 'Year' : 'Month',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                intervalType: state.selectedPeriod == 'yearly'
                    ? DateTimeIntervalType.years
                    : DateTimeIntervalType.months,
                interval: 1,
                dateFormat: state.selectedPeriod == 'yearly'
                    ? DateFormat.y()
                    : DateFormat.MMM(),
                majorTickLines: const MajorTickLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(color: titleColor, fontSize: 11),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(
                  text: 'Rolling Average',
                  textStyle: TextStyle(color: titleColor, fontSize: 12),
                ),
                numberFormat: NumberFormat.compact(),
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: titleColor, fontSize: 10),
              ),
              series: <CartesianSeries>[
                LineSeries<Map<String, dynamic>, DateTime>(
                  name: 'Short Term Avg',
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['rollingAverage7'] ?? 0,
                  color: const Color(0xFF00D4AA),
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderColor: Color(0xFF00D4AA),
                    color: Color(0xFF00D4AA),
                    borderWidth: 2,
                    width: 6,
                    height: 6,
                  ),
                ),
                LineSeries<Map<String, dynamic>, DateTime>(
                  name: 'Long Term Avg',
                  dataSource: state.chartData ?? [],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      DateTime.parse(data['date']),
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['rollingAverage30'] ?? 0,
                  color: const Color(0xFFE91E63),
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    borderColor: Color(0xFFE91E63),
                    color: Color(0xFFE91E63),
                    borderWidth: 2,
                    width: 6,
                    height: 6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>>? _getChartDataForType(
    StablecoinState state,
    String chartType,
  ) {
    if (state.chartData == null) return null;

    switch (chartType) {
      case 'total_supply_over_time':
        return state.chartData!
            .map(
              (item) => {
                'date': item['date'],
                'totalSupply': item['totalSupply'],
              },
            )
            .toList();
      case 'mint_burn_activity':
        return state.chartData!
            .map(
              (item) => {
                'date': item['date'],
                'mintAmount': item['mintAmount'],
                'burnAmount': item['burnAmount'],
              },
            )
            .toList();
      case 'net_change_in_supply':
        return state.chartData!
            .map(
              (item) => {
                'date': item['date'],
                'netChange':
                    (item['mintAmount'] ?? 0.0) - (item['burnAmount'] ?? 0.0),
              },
            )
            .toList();
      case 'rolling_average_supply_changes':
        return state.chartData!
            .map(
              (item) => {
                'date': item['date'],
                'rollingAverage7': item['rollingAverage7'],
                'rollingAverage30': item['rollingAverage30'],
              },
            )
            .toList();
      default:
        return state.chartData;
    }
  }
}
