import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
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
            ],
          ),
        ),
        SizedBox(
          height: context.screenHeight * .45,
          child: SuperListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: sortedMetrics.length,
            itemBuilder: (context, index) {
              return _buildCubeBoxplotCard(sortedMetrics[index], theme);
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: _buildLegend(theme),
        ),
      ],
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

  Widget _buildCubeBoxplotCard(
    CubePerformanceMetrics metrics,
    ThemeData theme,
  ) {
    final data = _calculateQuartiles(metrics);
    final color = _getCategoryColor(metrics.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 2,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cube name
            Text(
              metrics.cubeModel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Solve count
            Text(
              '${metrics.totalSolves} ${translate('dashboard.solves')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            // Boxplot chart
            Expanded(child: _buildSingleBoxplot(data, color, theme)),
            const SizedBox(height: 12),
            // Statistics
            _buildStatistics(data, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleBoxplot(
    Map<String, double> data,
    Color color,
    ThemeData theme,
  ) {
    final min = data['min']!;
    final q1 = data['q1']!;
    final median = data['median']!;
    final q3 = data['q3']!;
    final max = data['max']!;

    // Calculate range and ensure it's not zero
    final range = max - min;
    final safeRange = range > 0 ? range : max * 0.1;
    final interval = safeRange / 4;

    // Adjust min/max Y for better visualization
    final minY = min > 0 ? min * 0.9 : min - safeRange * 0.1;
    final maxY = max * 1.1;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
            dashArray: [3, 3],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value / 1000).toStringAsFixed(1)}s',
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
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
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              // Whisker inferior (min to Q1)
              BarChartRodData(
                fromY: min,
                toY: q1,
                width: 2,
                color: color.withOpacity(0.6),
                borderRadius: BorderRadius.zero,
              ),
              // Box (Q1 to median)
              BarChartRodData(
                fromY: q1,
                toY: median,
                width: 40,
                color: color.withOpacity(0.7),
                borderRadius: BorderRadius.zero,
              ),
              // Box (median to Q3)
              BarChartRodData(
                fromY: median,
                toY: q3,
                width: 40,
                color: color.withOpacity(0.5),
                borderRadius: BorderRadius.zero,
              ),
              // Whisker superior (Q3 to max)
              BarChartRodData(
                fromY: q3,
                toY: max,
                width: 2,
                color: color.withOpacity(0.6),
                borderRadius: BorderRadius.zero,
              ),
              // Median line
              BarChartRodData(
                fromY: median - safeRange * 0.01,
                toY: median + safeRange * 0.01,
                width: 42,
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
            ],
          ),
        ],
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }

  Widget _buildStatistics(Map<String, double> data, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow('Min', data['min']!, theme),
        _buildStatRow('Q1', data['q1']!, theme),
        _buildStatRow('Median', data['median']!, theme, highlight: true),
        _buildStatRow('Q3', data['q3']!, theme),
        _buildStatRow('Max', data['max']!, theme),
      ],
    );
  }

  Widget _buildStatRow(
    String label,
    double value,
    ThemeData theme, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight
                  ? theme.colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
          Text(
            '${(value / 1000).toStringAsFixed(2)}s',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight
                  ? theme.colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
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
