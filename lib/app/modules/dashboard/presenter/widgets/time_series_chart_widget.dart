import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../shared/translate/translate.dart';
import '../../domain/entities/solve_analytics.dart';

/// Widget that displays a time series line chart showing solve times over time
/// with rolling Ao5 and Ao12 averages overlaid
class TimeSeriesChartWidget extends StatelessWidget {
  final SolveAnalytics analytics;
  final int maxSolvesToShow;

  const TimeSeriesChartWidget({
    super.key,
    required this.analytics,
    this.maxSolvesToShow = 50,
  });

  @override
  Widget build(BuildContext context) {
    if (analytics.timeSeriesData.isEmpty) {
      return _buildEmptyState(context);
    }

    final theme = Theme.of(context);
    final count = analytics.timeSeriesData.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.time_series_title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translate(
                'dashboard.time_series_subtitle',
              ).replaceAll('{count}', count.toString()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            _buildLegend(theme),
            const SizedBox(height: 16),
            SizedBox(height: 300, child: _buildChart(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            translate('dashboard.no_data'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      children: [
        _buildLegendItem(
          color: Colors.grey.shade600,
          label: translate('dashboard.raw_times'),
        ),
        const SizedBox(width: 16),
        if (analytics.hasEnoughDataForAo5)
          _buildLegendItem(
            color: Colors.blue.shade400,
            label: translate('dashboard.rolling_ao5'),
          ),
        if (analytics.hasEnoughDataForAo5) const SizedBox(width: 16),
        if (analytics.hasEnoughDataForAo12)
          _buildLegendItem(
            color: Colors.green.shade400,
            label: translate('dashboard.rolling_ao12'),
          ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildChart(ThemeData theme) {
    // Get last N solves to display
    final dataToShow = analytics.timeSeriesData.length > maxSolvesToShow
        ? analytics.timeSeriesData.sublist(
            analytics.timeSeriesData.length - maxSolvesToShow,
          )
        : analytics.timeSeriesData;

    // Extract raw times (in seconds)
    final rawTimes = dataToShow.map((d) => d.solveTime / 1000.0).toList();

    // Get corresponding Ao5 and Ao12 values
    final ao5Data = analytics.rollingAo5History.isNotEmpty
        ? _alignRollingData(analytics.rollingAo5History, dataToShow.length)
        : <double?>[];

    final ao12Data = analytics.rollingAo12History.isNotEmpty
        ? _alignRollingData(analytics.rollingAo12History, dataToShow.length)
        : <double?>[];

    // Find min/max for y-axis scaling
    final allValues = <double>[
      ...rawTimes,
      ...ao5Data.whereType<double>(),
      ...ao12Data.whereType<double>(),
    ];

    final minY = allValues.reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = allValues.reduce((a, b) => a > b ? a : b) * 1.1;

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        minX: 0,
        maxX: dataToShow.length.toDouble() - 1,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}s',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(
              translate('dashboard.solve_number'),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (dataToShow.length / 5).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= dataToShow.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${value.toInt() + 1}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400),
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        lineBarsData: [
          // Raw times line (gray)
          LineChartBarData(
            spots: List.generate(
              rawTimes.length,
              (i) => FlSpot(i.toDouble(), rawTimes[i]),
            ),
            isCurved: false,
            color: Colors.grey.shade600,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Colors.grey.shade600,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),

          // Ao5 line (blue)
          if (ao5Data.isNotEmpty)
            LineChartBarData(
              spots: List.generate(
                ao5Data.length,
                (i) => ao5Data[i] != null
                    ? FlSpot(i.toDouble(), ao5Data[i]!)
                    : null,
              ).whereType<FlSpot>().toList(),
              isCurved: true,
              color: Colors.blue.shade400,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),

          // Ao12 line (green)
          if (ao12Data.isNotEmpty)
            LineChartBarData(
              spots: List.generate(
                ao12Data.length,
                (i) => ao12Data[i] != null
                    ? FlSpot(i.toDouble(), ao12Data[i]!)
                    : null,
              ).whereType<FlSpot>().toList(),
              isCurved: true,
              color: Colors.green.shade400,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String label;
                if (spot.barIndex == 0) {
                  label = translate('dashboard.raw_times');
                } else if (spot.barIndex == 1) {
                  label = translate('dashboard.rolling_ao5');
                } else {
                  label = translate('dashboard.rolling_ao12');
                }

                return LineTooltipItem(
                  '$label\n${spot.y.toStringAsFixed(2)}s',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  /// Aligns rolling average data with the time series data
  /// Rolling averages start after enough data points are available
  List<double?> _alignRollingData(List<int> rollingData, int targetLength) {
    if (rollingData.isEmpty) return [];

    final result = <double?>[];
    final offset = targetLength - rollingData.length;

    // Add nulls for the initial period where rolling average isn't available
    for (int i = 0; i < offset; i++) {
      result.add(null);
    }

    // Add the rolling average data (convert milliseconds to seconds)
    for (final value in rollingData) {
      result.add(value / 1000.0);
    }

    return result;
  }
}
