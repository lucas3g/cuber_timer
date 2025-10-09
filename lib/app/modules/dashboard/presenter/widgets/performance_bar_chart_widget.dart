import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../shared/translate/translate.dart';
import '../../domain/entities/cube_performance_metrics.dart';
import '../../domain/entities/solve_analytics.dart';

/// Widget that displays a horizontal bar chart comparing average times across cube models
/// Sorted from fastest to slowest with color-coded performance categories
class PerformanceBarChartWidget extends StatelessWidget {
  final SolveAnalytics analytics;

  const PerformanceBarChartWidget({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.cubeMetrics.isEmpty) {
      return _buildEmptyState(context);
    }

    final theme = Theme.of(context);

    // Sort by median time (fastest first)
    final sortedMetrics = analytics.cubeMetrics.values.toList()
      ..sort((a, b) => a.medianTime.compareTo(b.medianTime));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.bar_chart_title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translate('dashboard.bar_chart_subtitle'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: context.screenHeight * .27,
              child: _buildChart(sortedMetrics, theme),
            ),
            const SizedBox(height: 16),
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
    final maxValue = metrics
        .map((m) => m.medianTime.toDouble())
        .reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          verticalInterval: maxValue / 5,
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          drawHorizontalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= metrics.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    metrics[index].cubeModel,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
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
              translate('dashboard.time_seconds'),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: maxValue / 5,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    (value / 1000).toStringAsFixed(1),
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
        barGroups: List.generate(
          metrics.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: metrics[index].medianTime.toDouble(),
                color: _getCategoryColor(metrics[index].category),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxValue * 1.1,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final metric = metrics[groupIndex];
              return BarTooltipItem(
                '${metric.cubeModel}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text:
                        '${translate('dashboard.median')}: '
                        '${(metric.medianTime / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.mean')}: '
                        '${(metric.averageTime / 1000).toStringAsFixed(2)}s\n',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  TextSpan(
                    text:
                        '${translate('dashboard.total_solves')}: '
                        '${metric.totalSolves}\n',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  if (metric.percentDifferenceFromBest > 0)
                    TextSpan(
                      text: translate('dashboard.percent_from_best').replaceAll(
                        '{percent}',
                        metric.percentDifferenceFromBest.toStringAsFixed(1),
                      ),
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(PerformanceCategory category) {
    switch (category) {
      case PerformanceCategory.excellent:
        return Colors.green.shade600;
      case PerformanceCategory.good:
        return Colors.blue.shade600;
      case PerformanceCategory.average:
        return Colors.orange.shade600;
      case PerformanceCategory.needsImprovement:
        return Colors.red.shade600;
    }
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildLegendItem(
          color: Colors.green.shade600,
          label: translate('dashboard.category_excellent'),
        ),
        _buildLegendItem(
          color: Colors.blue.shade600,
          label: translate('dashboard.category_good'),
        ),
        _buildLegendItem(
          color: Colors.orange.shade600,
          label: translate('dashboard.category_average'),
        ),
        _buildLegendItem(
          color: Colors.red.shade600,
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
}
