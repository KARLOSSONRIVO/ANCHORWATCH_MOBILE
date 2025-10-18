import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../injection_container.dart';
import '../../blocs/discover/macro_trends/macro_trends.dart';
import '../../../utils/number_formatter.dart';
import '../../../domain/entities/macro_trends.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/chart_summary_widget.dart';
import '../../themes/app_theme.dart';

class MacroTrendsView extends StatelessWidget {
  const MacroTrendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MacroTrendsBloc>()..add(const MacroTrendsLoadRequested()),
      child: const _MacroTrendsView(),
    );
  }
}

class _MacroTrendsView extends StatelessWidget {
  const _MacroTrendsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MacroTrendsBloc, MacroTrendsState>(
      builder: (context, state) {
        if (state.status == MacroTrendsStatus.loading) {
          return const Center(
            child: LoadingWidget(
              size: 48.0,
              color: Color(0xFF00D4AA),
              text: 'Loading Macro Trends...',
            ),
          );
        }

        if (state.status == MacroTrendsStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<MacroTrendsBloc>().add(const MacroTrendsRefreshRequested());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                  ),
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        if (state.macroTrendsData == null) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? Colors.white70,
                fontSize: 16,
              ),
            ),
          );
        }

        return Container(
          color: AppTheme.getBackgroundColor(context),
      child: RefreshIndicator(
            color: const Color(0xFF00D4AA),
            onRefresh: () async {
              context.read<MacroTrendsBloc>().add(const MacroTrendsRefreshRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _card(
                    context, 
                    state,
                    title: _getInflationChartTitle(state), 
                    child: SizedBox(height: 240, child: _inflationTimelineChart(state)),
                    chartType: 'annual_inflation_rates',
                  ),
                  _card(
                    context, 
                    state,
                    title: 'Inflation vs Supply Growth', 
                    child: SizedBox(height: 240, child: _inflationVsSupplyChart(state)),
                    chartType: 'inflation_vs_supply_growth',
                  ),
                  _card(
                    context, 
                    state,
                    title: 'Correlation Matrix', 
                    child: _correlationHeatmap(state),
                    chartType: 'correlation_table',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _card(BuildContext context, MacroTrendsState state, {required String title, String? subtitle, required Widget child, required String chartType}) => Container(
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
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
        ChartSummaryWidget(
          chartType: chartType,
          chartTitle: title,
          timeFrame: state.selectedPeriod,
          chartData: _getChartDataForType(state, chartType),
        ),
      ],
    ),
  );
  Widget _inflationTimelineChart(MacroTrendsState state) {
    final data = state.macroTrendsData?.inflationTimeline ?? [];

    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No inflation data available',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }
    final validData = data.where((item) => item.inflationRate != null).toList();

    if (validData.isEmpty) {
      return const Center(
        child: Text(
          'No valid inflation data available',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }
    final isMonthly = validData.isNotEmpty && validData.first.period != null;
    final xAxisTitle = isMonthly ? 'Month' : 'Year';

    return Builder(
      builder: (context) {
        final labelColor = Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ?? Colors.white54;
        final titleColor = Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? Colors.white70;

        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: isMonthly 
            ? CategoryAxis(
                labelStyle: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(text: xAxisTitle, textStyle: TextStyle(color: titleColor, fontSize: 12)),
                majorTickLines: const MajorTickLines(width: 0),
                labelRotation: -45,
              )
            : NumericAxis(
                labelStyle: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                title: AxisTitle(text: xAxisTitle, textStyle: TextStyle(color: titleColor, fontSize: 12)),
                interval: 1,
                labelFormat: '{value}',
                majorTickLines: const MajorTickLines(width: 0),
              ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: titleColor, fontSize: 11),
            majorGridLines: MajorGridLines(width: 0.5, color: Theme.of(context).dividerColor),
            axisLine: const AxisLine(width: 0),
            title: AxisTitle(text: 'Inflation Rate (%)', textStyle: TextStyle(color: titleColor, fontSize: 12)),
          ),
          series: <CartesianSeries>[
            LineSeries<InflationRateData, dynamic>(
              dataSource: validData,
              xValueMapper: (InflationRateData data, _) => isMonthly ? data.period : data.year,
              yValueMapper: (InflationRateData data, _) => data.inflationRate,
              color: const Color(0xFF00D4AA),
              width: 3,
              markerSettings: const MarkerSettings(
                isVisible: true,
                height: 6,
                width: 6,
                color: Color(0xFF00D4AA),
                borderColor: Colors.white,
                borderWidth: 2,
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _inflationVsSupplyChart(MacroTrendsState state) {
    final data = state.macroTrendsData?.inflationVsSupplyGrowth ?? [];

    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No inflation vs supply data available',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }
    final validInflationData = data.where((item) => item.inflationRate != null).toList();
    final validSupplyData = data.where((item) => item.supplyGrowthPct != null).toList();

    return Builder(
      builder: (context) {
        final labelColor = Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.54) ?? Colors.white54;
        final titleColor = Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ?? Colors.white70;

        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            textStyle: TextStyle(color: titleColor, fontSize: 10),
          ),
          primaryXAxis: NumericAxis(
            labelStyle: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500),
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            title: AxisTitle(text: 'Year', textStyle: TextStyle(color: titleColor, fontSize: 12)),
            interval: 1,
            labelFormat: '{value}',
            majorTickLines: const MajorTickLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: titleColor, fontSize: 11),
            majorGridLines: MajorGridLines(width: 0.5, color: Theme.of(context).dividerColor),
            axisLine: const AxisLine(width: 0),
            title: AxisTitle(text: 'Inflation Rate (%)', textStyle: TextStyle(color: titleColor, fontSize: 12)),
          ),
          axes: [
            NumericAxis(
              name: 'secondaryY',
              opposedPosition: true,
              labelStyle: TextStyle(color: titleColor, fontSize: 11),
              title: AxisTitle(text: 'Supply Growth (%)', textStyle: TextStyle(color: titleColor, fontSize: 12)),
              majorGridLines: const MajorGridLines(width: 0),
            ),
          ],
          series: <CartesianSeries>[
            LineSeries<InflationSupplyData, int>(
              name: 'Inflation Rate',
              dataSource: validInflationData,
              xValueMapper: (InflationSupplyData data, _) => data.year,
              yValueMapper: (InflationSupplyData data, _) => data.inflationRate,
              color: const Color(0xFF00D4AA),
              width: 2,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
            ColumnSeries<InflationSupplyData, int>(
              name: 'Supply Growth',
              dataSource: validSupplyData,
              xValueMapper: (InflationSupplyData data, _) => data.year,
              yValueMapper: (InflationSupplyData data, _) => data.supplyGrowthPct,
              yAxisName: 'secondaryY',
              color: const Color(0xFFFF6B9D).withValues(alpha: 0.7),
            ),
          ],
        );
      },
    );
  }
  Widget _correlationHeatmap(MacroTrendsState state) {
    final correlationData = state.macroTrendsData?.correlationTable ?? [];

    if (correlationData.isEmpty) {
      return const Center(
        child: Text(
          'No correlation data available',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }
    final List<String> variables = ['Inflation', 'Price', 'Market Cap', 'Supply', 'Net Change'];
    final List<List<double>> correlationMatrix = [];
    for (final data in correlationData) {
      correlationMatrix.add([
        data.inflationRate,
        data.price,
        data.marketCap,
        data.supplyClosing,
        data.netChangeUsd,
      ]);
    }

    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: AppTheme.getBackgroundColor(context),
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                  ),
                  ...variables.map((variable) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: AppTheme.getBackgroundColor(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          variable,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black87 // Better contrast for light mode
                                : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            ...List.generate(variables.length, (rowIndex) {
              return SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppTheme.getBackgroundColor(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            variables[rowIndex],
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black87 // Better contrast for light mode
                                  : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(variables.length, (colIndex) {
                      final value = correlationMatrix[rowIndex][colIndex];
                      Color getCorrelationColor(double corr) {
                        if (corr > 0.8) {
                          return const Color(0xFF00D4AA); // Strong positive - bright teal
                        } else if (corr > 0.5) {
                          return const Color(0xFF4DDDC7); // Medium positive - medium teal
                        } else if (corr > 0.2) {
                          return const Color(0xFF7DE8D3); // Weak positive - light teal
                        } else if (corr > -0.2) {
                          return Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                              : const Color(0xFF1E1E1E); // Softer dark gray for dark mode
                        } else if (corr > -0.5) {
                          return const Color(0xFF8B4B73); // Weak negative - light pink
                        } else if (corr > -0.8) {
                          return const Color(0xFFB85C8A); // Medium negative - medium pink
                        } else {
                          return const Color(0xFFFF6B9D); // Strong negative - bright pink
                        }
                      }

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: getCorrelationColor(value),
                            borderRadius: BorderRadius.circular(4),
                            border: rowIndex == colIndex ? Border.all(color: Colors.white, width: 1.5) : null,
                          ),
                          child: Center(
                            child: Text(
                              NumberFormatter.formatPercentage(value * 100),
                              style: TextStyle(
                                color: value.abs() > 0.6
                                    ? Colors.white
                                    : Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87 // Better contrast for light mode
                                    : Colors.white70,
                                fontSize: 11,
                                fontWeight: rowIndex == colIndex ? FontWeight.bold : FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context, 'Strong Negative', const Color(0xFFFF6B9D)),
                _buildLegendItem(context, 'Weak', Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                    : const Color(0xFF1E1E1E)), // Softer dark gray for dark mode
                _buildLegendItem(context, 'Strong Positive', const Color(0xFF00D4AA)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>>? _getChartDataForType(MacroTrendsState state, String chartType) {
    if (state.macroTrendsData == null) return null;
    
    switch (chartType) {
      case 'annual_inflation_rates':
        return state.macroTrendsData!.inflationTimeline
            .map((item) => {
                  'year': item.year,
                  'inflation_rate': item.inflationRate,
                })
            .toList();
      case 'inflation_vs_supply_growth':
        return state.macroTrendsData!.inflationVsSupplyGrowth
            .map((item) => {
                  'year': item.year,
                  'inflation_rate': item.inflationRate,
                  'supply_growth_pct': item.supplyGrowthPct,
                })
            .toList();
      case 'correlation_table':
        return state.macroTrendsData!.correlationTable
            .map((item) => {
                  'inflation_rate': item.inflationRate,
                  'price': item.price,
                  'market_cap': item.marketCap,
                  'supply_closing': item.supplyClosing,
                  'net_change_usd': item.netChangeUsd,
                })
            .toList();
      default:
        return null;
    }
  }

  String _getInflationChartTitle(MacroTrendsState state) {
    final period = state.selectedPeriod;
    switch (period) {
      case 'monthly':
        return 'Monthly Inflation Rates';
      case 'weekly':
        return 'Weekly Inflation Rates';
      case 'daily':
        return 'Daily Inflation Rates';
      default:
        return 'Annual Inflation Rates';
    }
  }
}
