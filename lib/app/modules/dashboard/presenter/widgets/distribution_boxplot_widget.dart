import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../shared/translate/translate.dart';
import '../../domain/entities/cube_performance_metrics.dart';
import '../../domain/entities/solve_analytics.dart';

/// Widget that displays boxplot-style distribution of solve times per cube model
/// Shows min, Q1, median, Q3, max for each cube type
class DistributionBoxplotWidget extends StatelessWidget {
  final SolveAnalytics analytics;

  const DistributionBoxplotWidget({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.cubeMetrics.isEmpty) {
      return _buildEmptyState(context);
    }

    final theme = Theme.of(context);
    final sortedMetrics = analytics.cubeMetrics.values.toList()
      ..sort((a, b) => a.medianTime.compareTo(b.medianTime));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.boxplot_title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translate('dashboard.boxplot_subtitle'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: context.screenHeight * 0.4,
              child: _buildChart(sortedMetrics, theme),
            ),
            _buildLegend(theme),
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

  Widget _buildChart(List<CubePerformanceMetrics> metrics, ThemeData theme) {
    // Calculate quartiles for each cube
    final boxPlotData = metrics.map((m) => _calculateQuartiles(m)).toList();

    // Find global min/max for y-axis
    final allValues = boxPlotData.expand(
      (data) => [
        data['min']!,
        data['q1']!,
        data['median']!,
        data['q3']!,
        data['max']!,
      ],
    );
    final minY = allValues.reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = allValues.reduce((a, b) => a > b ? a : b) * 1.1;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: minY,
        maxY: maxY,
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
                  '${(value / 1000).toStringAsFixed(1)}s',
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
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= metrics.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    metrics[index].cubeModel,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
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
        barGroups: List.generate(
          metrics.length,
          (index) => _createBoxPlotBarGroup(
            index,
            boxPlotData[index],
            _getCategoryColor(metrics[index].category),
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final metric = metrics[groupIndex];
              final data = boxPlotData[groupIndex];
              return BarTooltipItem(
                '${metric.cubeModel}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text:
                        '${translate('dashboard.min')}: '
                        '${(data['min']! / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.quartile_1')}: '
                        '${(data['q1']! / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.median')}: '
                        '${(data['median']! / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.quartile_3')}: '
                        '${(data['q3']! / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.max')}: '
                        '${(data['max']! / 1000).toStringAsFixed(2)}s',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Creates a bar group that visually represents a boxplot
  BarChartGroupData _createBoxPlotBarGroup(
    int x,
    Map<String, double> data,
    Color color,
  ) {
    final min = data['min']!;
    final q1 = data['q1']!;
    final median = data['median']!;
    final q3 = data['q3']!;
    final max = data['max']!;

    // Calculate a small offset for median line visibility
    final range = max - min;
    final medianLineThickness = range * 0.02; // 2% of range

    return BarChartGroupData(
      x: x,
      barRods: [
        // Main bar: full range with whiskers and box
        BarChartRodData(
          fromY: min,
          toY: max,
          width: 30,
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
          rodStackItems: [
            // Lower whisker (min to Q1) - thin, transparent
            BarChartRodStackItem(min, q1, color.withOpacity(0.4)),
            // Box (Q1 to Q3) - main colored area
            BarChartRodStackItem(q1, q3, color.withOpacity(0.8)),
            // Upper whisker (Q3 to max) - thin, transparent
            BarChartRodStackItem(q3, max, color.withOpacity(0.4)),
          ],
        ),
        // Median line - separate thin bar for better visibility
        BarChartRodData(
          fromY: median - medianLineThickness,
          toY: median + medianLineThickness,
          width: 30,
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
      ],
      showingTooltipIndicators: [],
    );
  }

  /// Calculates quartiles (Q1, median, Q3) from all times
  Map<String, double> _calculateQuartiles(CubePerformanceMetrics metrics) {
    final sortedTimes = List<int>.from(metrics.allTimes)..sort();
    final n = sortedTimes.length;

    double getPercentile(double percentile) {
      final index = (percentile / 100.0) * (n - 1);
      final lower = index.floor();
      final upper = index.ceil();
      final weight = index - lower;

      if (lower == upper) {
        return sortedTimes[lower].toDouble();
      }

      return sortedTimes[lower] * (1 - weight) + sortedTimes[upper] * weight;
    }

    return {
      'min': sortedTimes.first.toDouble(),
      'q1': getPercentile(25),
      'median': getPercentile(50),
      'q3': getPercentile(75),
      'max': sortedTimes.last.toDouble(),
    };
  }

  Color _getCategoryColor(PerformanceCategory category) {
    switch (category) {
      case PerformanceCategory.excellent:
        return Colors.green;
      case PerformanceCategory.good:
        return Colors.blue;
      case PerformanceCategory.average:
        return Colors.orange;
      case PerformanceCategory.needsImprovement:
        return Colors.red;
    }
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          color: Colors.green,
          label: translate('dashboard.category_excellent'),
        ),
        _buildLegendItem(
          color: Colors.blue,
          label: translate('dashboard.category_good'),
        ),
        _buildLegendItem(
          color: Colors.orange,
          label: translate('dashboard.category_average'),
        ),
        _buildLegendItem(
          color: Colors.red,
          label: translate('dashboard.category_needs_improvement'),
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
          height: 16,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
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
}
