import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../../shared/translate/translate.dart';
import '../../domain/entities/cube_performance_metrics.dart';
import '../../domain/entities/solve_analytics.dart';

/// Widget that displays performance metrics as a list of cards
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
            const SizedBox(height: 16),
            _buildCardsList(sortedMetrics, theme),
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

  Widget _buildCardsList(
    List<CubePerformanceMetrics> metrics,
    ThemeData theme,
  ) {
    return SizedBox(
      height: 170,
      child: SuperListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: metrics.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final metric = metrics[index];
          final categoryColor = _getCategoryColor(metric.category);
          final isFirst = index == 0;

          return SizedBox(
            width: 280,
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: categoryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com nome do cubo e posição
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (isFirst)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            if (isFirst) const SizedBox(width: 8),
                            Text(
                              metric.cubeModel,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: categoryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _getCategoryLabel(metric.category),
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Métricas principais
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            icon: Icons.timer,
                            label: translate('dashboard.median'),
                            value: StopWatchTimer.getDisplayTime(
                              metric.medianTime,
                              hours: false,
                            ),
                            color: categoryColor,
                          ),
                        ),
                        Expanded(
                          child: _buildMetricItem(
                            icon: Icons.trending_up,
                            label: translate('dashboard.mean'),
                            value: StopWatchTimer.getDisplayTime(
                              metric.averageTime,
                              hours: false,
                            ),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            icon: Icons.format_list_numbered,
                            label: translate('dashboard.total_solves'),
                            value: '${metric.totalSolves}',
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (metric.percentDifferenceFromBest > 0)
                          Expanded(
                            child: _buildMetricItem(
                              icon: Icons.compare_arrows,
                              label: translate('dashboard.from_best'),
                              value:
                                  '+${metric.percentDifferenceFromBest.toStringAsFixed(1)}%',
                              color: Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryLabel(PerformanceCategory category) {
    switch (category) {
      case PerformanceCategory.excellent:
        return translate('dashboard.category_excellent');
      case PerformanceCategory.good:
        return translate('dashboard.category_good');
      case PerformanceCategory.average:
        return translate('dashboard.category_average');
      case PerformanceCategory.needsImprovement:
        return translate('dashboard.category_needs_improvement');
    }
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
