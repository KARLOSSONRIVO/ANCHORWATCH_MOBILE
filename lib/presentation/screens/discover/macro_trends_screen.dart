import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../injection_container.dart';
import '../../blocs/discover/macro_trends/macro_trends.dart';
import '../../../utils/number_formatter.dart';
import '../../../domain/entities/macro_trends.dart';
import '../../widgets/loading_widget.dart';

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
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70,
                fontSize: 16,
              ),
            ),
          );
        }

        return Container(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
              : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
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
                  const SizedBox(height: 8),
                  _card(context, title: 'Annual Inflation Rates', child: SizedBox(height: 240, child: _inflationTimelineChart(state))),
                  _card(context, title: 'Inflation vs Supply Growth', child: SizedBox(height: 240, child: _inflationVsSupplyChart(state))),
                  _card(context, title: 'Correlation Matrix', child: _correlationHeatmap(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _card(BuildContext context, {required String title, String? subtitle, required Widget child}) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8F8F8) // Softer off-white for light mode
          : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
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
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );

  // Annual Inflation Rates Timeline Chart
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

    // Filter out null inflation rates
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

    return Builder(
      builder: (context) {
        final labelColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54) ?? Colors.white54;
        final titleColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70;

        return SfCartesianChart(
          plotAreaBorderWidth: 0,
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
          series: <CartesianSeries>[
            LineSeries<InflationRateData, int>(
              dataSource: validData,
              xValueMapper: (InflationRateData data, _) => data.year,
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

  // Inflation vs Supply Growth Dual Axis Chart
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

    // Filter out null values for inflation rate and supply growth
    final validInflationData = data.where((item) => item.inflationRate != null).toList();
    final validSupplyData = data.where((item) => item.supplyGrowthPct != null).toList();

    return Builder(
      builder: (context) {
        final labelColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.54) ?? Colors.white54;
        final titleColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70;

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
              color: const Color(0xFFFF6B9D).withOpacity(0.7),
            ),
          ],
        );
      },
    );
  }

  // Enhanced Correlation Matrix Heatmap
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

    // Extract variable names and build correlation matrix
    final List<String> variables = ['Inflation', 'Price', 'Market Cap', 'Supply', 'Net Change'];
    final List<List<double>> correlationMatrix = [];

    // Build correlation matrix from API data
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
            // Header row with variable names
            Container(
              height: 30,
              child: Row(
                children: [
                  // Empty corner cell
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Variable name headers
                  ...variables.map((variable) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
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
            // Data rows
            ...List.generate(variables.length, (rowIndex) {
              return Container(
                height: 40,
                child: Row(
                  children: [
                    // Row variable name
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                              : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
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
                    // Correlation values
                    ...List.generate(variables.length, (colIndex) {
                      final value = correlationMatrix[rowIndex][colIndex];

                      // Color mapping based on correlation strength
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
            // Legend
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
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}