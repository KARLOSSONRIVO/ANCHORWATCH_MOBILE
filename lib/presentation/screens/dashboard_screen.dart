import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../injection_container.dart';
import '../blocs/dashboard/dashboard.dart';
import '../themes/app_theme.dart';

/// Dashboard page content only (no navigation)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(const DashboardInitialLoadEvent()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00D4AA),
            ),
          );
        }
        
        if (state is DashboardErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Dashboard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<DashboardBloc>().add(const DashboardRefreshEvent()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                    foregroundColor: AppTheme.getTextPrimaryColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry', style: TextStyle(fontFamily: 'Inter')),
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoadedState) {
          return Container(
            color: AppTheme.getBackgroundColor(context),
            child: RefreshIndicator(
              color: const Color(0xFF00D4AA),
              onRefresh: () async {
                context.read<DashboardBloc>().add(const DashboardRefreshEvent());
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  _buildHeader(context, state),
                  _buildCard(
                    title: 'Unified Table (${state.selectedTimePeriod})',
                    child: _buildDataTable(context, state),
                    height: 320,
                  ),
                  _buildCard(
                    title: 'Price vs Market Cap',
                    child: _buildPriceMarketCapChart(context, state),
                  ),
                  _buildCard(
                    title: 'Supply vs Inflation (Dual Axis)',
                    child: _buildSupplyInflationChart(context, state),
                  ),
                  _buildCard(
                    title: 'Mint vs Burn (Stacked)',
                    child: _buildMintBurnChart(context, state),
                    height: 300,
                  ),
                  _buildCard(
                    title: 'Supply% vs Price% (Scatter)',
                    child: _buildCorrelationScatterChart(context, state),
                    height: 280,
                  ),
                  _buildCard(
                    title: 'Correlation Heatmap',
                    child: _buildCorrelationHeatmap(context, state),
                    height: 320,
                  ),
                  _buildCard(
                    title: 'Rolling Correlation (Supply vs Market Cap)',
                    child: _buildRollingCorrelationChart(context, state),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: Text('Welcome to AnchorWatch Dashboard', style: TextStyle(color: AppTheme.getTextPrimaryColor(context))));
      },
    );
  }

  Widget _buildHeader(BuildContext context, DashboardLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'DASHBOARD',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: AppTheme.getTextPrimaryColor(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.getBorderColor(context), width: 2),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                initialValue: state.selectedTimePeriod,
                onSelected: (String? newValue) {
                  if (newValue != null) {
                    context.read<DashboardBloc>().add(DashboardTimePeriodChangedEvent(newValue));
                  }
                },
                color: AppTheme.getSurfaceColor(context),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppTheme.getBorderColor(context), width: 1),
                ),
                offset: const Offset(0, 35),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.selectedTimePeriod,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        color: AppTheme.getTextPrimaryColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppTheme.getTextPrimaryColor(context),
                      size: 20,
                    ),
                  ],
                ),
                itemBuilder: (BuildContext context) => DashboardBloc.timePeriods.map((String period) {
                  return PopupMenuItem<String>(
                    value: period,
                    padding: EdgeInsets.zero,
                    mouseCursor: SystemMouseCursors.click,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          color: state.selectedTimePeriod == period
                              ? const Color(0xFF00D4AA)
                              : AppTheme.getTextSecondaryColor(context),
                          fontWeight: state.selectedTimePeriod == period ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child, double? height}) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.getCardBackgroundColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.getBorderColor(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 12),
            height != null ? SizedBox(height: height, child: child) : child,
          ],
        ),
      ),
    );
  }



  Widget _buildDataTable(BuildContext context, DashboardLoadedState state) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Period',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Price',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Supply (M)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Net Δ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Inflation %',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ),
          ],
          rows: state.unified.map((row) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    row.timeId,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _formatCurrency(row.price),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _formatNumber(row.supply / 1e6),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _formatNumber(row.netChange),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    row.inflation.isNaN ? '-' : _formatPercentage(row.inflation),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }


  // Correlation Heatmap
  Widget _buildCorrelationHeatmap(BuildContext context, DashboardLoadedState state) {
    final size = state.heatVars.length;
    if (size == 0 || state.heatCells.isEmpty) {
      return Center(
        child: Text(
          'No correlation data available',
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.getTextSecondaryColor(context),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 60),
              ...state.heatVars.map((variable) => Expanded(
                child: Center(
                  child: Text(
                    variable,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: List.generate(size, (row) {
                return Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          state.heatVars[row],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: AppTheme.getTextSecondaryColor(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ...List.generate(size, (col) {
                        final cellIndex = row * size + col;
                        if (cellIndex >= state.heatCells.length) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: AppTheme.getChartBackgroundColor(context),
                                border: Border.all(
                                  color: Colors.grey.shade600,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }

                        final cell = state.heatCells[cellIndex];
                        final v = cell.value.clamp(-1.0, 1.0);
                        final frac = v.abs();
                        final color = v >= 0
                            ? Color.lerp(AppTheme.getChartBackgroundColor(context), Colors.greenAccent, frac)!
                            : Color.lerp(AppTheme.getChartBackgroundColor(context), Colors.redAccent, frac)!;

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                color: Colors.grey.shade600,
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                v.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                  color: frac > 0.5 
                                      ? AppTheme.getTextPrimaryColor(context) 
                                      : AppTheme.getTextPrimaryColor(context),
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
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMintBurnChart(BuildContext context, DashboardLoadedState state) {
    final textColor = AppTheme.getTextSecondaryColor(context);
    final labelColor = AppTheme.getTextSecondaryColor(context).withOpacity(0.7);

    final mintPoints = <Map<String, dynamic>>[];
    final burnPoints = <Map<String, dynamic>>[];

    // Use unified data approach like reference
    for (final unified in state.unified) {
      double mint = 0.0;
      double burn = 0.0;

      if (state.selectedTimePeriod.toLowerCase() == 'monthly') {
        // For monthly view, derive mint/burn from net change
        if (unified.netChange > 0) {
          mint = unified.netChange;
          burn = 0.0;
        } else {
          mint = 0.0;
          burn = -unified.netChange;
        }
      } else {
        // For yearly view, use aggregated data from mint burn chart data
        final matchingData = state.mintBurnChartData.where((data) => data.x.year.toString() == unified.timeId);
        if (matchingData.isNotEmpty) {
          mint = matchingData.fold(0.0, (sum, data) => sum + data.mint);
          burn = matchingData.fold(0.0, (sum, data) => sum + data.burn);
        }
      }

      mintPoints.add({'x': unified.timeId, 'y': mint / 1e6});
      burnPoints.add({'x': unified.timeId, 'y': burn / 1e6});
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: mintPoints.length * 60.0 + 100,
        child: SfCartesianChart(
          backgroundColor: AppTheme.getChartBackgroundColor(context),
          margin: const EdgeInsets.fromLTRB(10, 15, 10, 45),
          legend: Legend(isVisible: true, textStyle: TextStyle(color: textColor)),
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(color: labelColor),
            majorGridLines: const MajorGridLines(width: 0),
            maximumLabels: 20,
            labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: labelColor),
            title: AxisTitle(text: 'Volume (M)', textStyle: TextStyle(color: labelColor)),
            numberFormat: NumberFormat.compact(),
          ),
          series: <CartesianSeries<dynamic, String>>[
            StackedColumnSeries<dynamic, String>(
              name: 'Mint',
              dataSource: mintPoints,
              xValueMapper: (dynamic data, _) => data['x'],
              yValueMapper: (dynamic data, _) => data['y'],
              color: Colors.lightGreenAccent,
            ),
            StackedColumnSeries<dynamic, String>(
              name: 'Burn',
              dataSource: burnPoints,
              xValueMapper: (dynamic data, _) => data['x'],
              yValueMapper: (dynamic data, _) => data['y'],
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrelationScatterChart(BuildContext context, DashboardLoadedState state) {
    final labelColor = AppTheme.getTextSecondaryColor(context).withOpacity(0.7);
    final textColor = AppTheme.getTextSecondaryColor(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: state.scatterPoints.length * 80.0 + 150,
        child: SfCartesianChart(
          backgroundColor: AppTheme.getChartBackgroundColor(context),
          primaryXAxis: NumericAxis(
            labelStyle: TextStyle(color: labelColor),
            title: AxisTitle(text: 'Supply Δ% (YoY)', textStyle: TextStyle(color: labelColor)),
            majorGridLines: const MajorGridLines(width: 0.5),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: labelColor),
            title: AxisTitle(text: 'Price Δ% (YoY)', textStyle: TextStyle(color: labelColor)),
            majorGridLines: const MajorGridLines(width: 0.5),
          ),
          series: <CartesianSeries<dynamic, double>>[
            ScatterSeries<dynamic, double>(
              name: 'Year',
              dataSource: state.scatterPoints,
              xValueMapper: (dynamic data, _) => data.x,
              yValueMapper: (dynamic data, _) => data.y,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: textColor, fontSize: 10),
              ),
              pointColorMapper: (dynamic data, _) => Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }



  String _formatNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(4)}';
  }

  String _formatPercentage(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  Widget _buildPriceMarketCapChart(BuildContext context, DashboardLoadedState state) {
    final textColor = AppTheme.getTextSecondaryColor(context);
    final labelColor = AppTheme.getTextSecondaryColor(context).withOpacity(0.7);

    return SfCartesianChart(
      backgroundColor: AppTheme.getChartBackgroundColor(context),
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 45),
      legend: Legend(isVisible: true, textStyle: TextStyle(color: textColor)),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: labelColor),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: labelColor),
        title: AxisTitle(text: 'Price', textStyle: TextStyle(color: labelColor)),
        numberFormat: NumberFormat.compact(),
      ),
      axes: [
        NumericAxis(
          name: 'mc',
          opposedPosition: true,
          labelStyle: TextStyle(color: labelColor),
          title: AxisTitle(text: 'Mkt Cap (M)', textStyle: TextStyle(color: labelColor)),
          numberFormat: NumberFormat.compact(),
        )
      ],
      series: <CartesianSeries<dynamic, String>>[
        LineSeries<dynamic, String>(
          name: 'Price',
          dataSource: state.priceSeries,
          xValueMapper: (dynamic data, _) => data.x,
          yValueMapper: (dynamic data, _) => data.y,
          color: Colors.cyanAccent,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<dynamic, String>(
          name: 'Market Cap',
          dataSource: state.marketCapSeries,
          xValueMapper: (dynamic data, _) => data.x,
          yValueMapper: (dynamic data, _) => data.y, // Already converted to millions in BLoC
          yAxisName: 'mc',
          color: Colors.deepPurpleAccent,
          width: 2,
        ),
      ],
    );
  }

  Widget _buildSupplyInflationChart(BuildContext context, DashboardLoadedState state) {
    final textColor = AppTheme.getTextSecondaryColor(context);
    final labelColor = AppTheme.getTextSecondaryColor(context).withOpacity(0.7);

    return SfCartesianChart(
      backgroundColor: AppTheme.getChartBackgroundColor(context),
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 45),
      legend: Legend(isVisible: true, textStyle: TextStyle(color: textColor)),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: labelColor),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: labelColor),
        title: AxisTitle(text: 'Supply (M)', textStyle: TextStyle(color: labelColor)),
        numberFormat: NumberFormat.compact(),
      ),
      axes: [
        NumericAxis(
          name: 'infl',
          opposedPosition: true,
          labelStyle: TextStyle(color: labelColor),
          title: AxisTitle(text: 'Inflation %', textStyle: TextStyle(color: labelColor)),
          numberFormat: NumberFormat.compact(),
        )
      ],
      series: <CartesianSeries<dynamic, String>>[
        SplineSeries<dynamic, String>(
          name: 'Supply',
          dataSource: state.supplySeries,
          xValueMapper: (dynamic data, _) => data.x,
          yValueMapper: (dynamic data, _) => data.y, // Already in millions from BLoC
          color: Colors.greenAccent,
          width: 2,
        ),
        StepLineSeries<dynamic, String>(
          name: 'Inflation',
          dataSource: state.inflationSeries,
          xValueMapper: (dynamic data, _) => data.x,
          yValueMapper: (dynamic data, _) => data.y,
          yAxisName: 'infl',
          color: Colors.orangeAccent,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildRollingCorrelationChart(BuildContext context, DashboardLoadedState state) {
    final labelColor = AppTheme.getTextSecondaryColor(context).withOpacity(0.7);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: state.rollingCorrSeries.length * 70.0 + 120,
        child: SfCartesianChart(
          backgroundColor: AppTheme.getChartBackgroundColor(context),
          margin: const EdgeInsets.fromLTRB(10, 15, 10, 30),
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(color: labelColor),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: labelColor),
            minimum: -1,
            maximum: 1,
            interval: 0.5,
          ),
          series: <CartesianSeries<dynamic, String>>[
            LineSeries<dynamic, String>(
              name: 'Rolling Corr',
              dataSource: state.rollingCorrSeries,
              xValueMapper: (dynamic data, _) => data.x,
              yValueMapper: (dynamic data, _) => data.y,
              color: Colors.amberAccent,
              width: 2,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}