import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/translate/translate.dart';
import '../../domain/entities/cube_performance_metrics.dart';
import '../../domain/entities/solve_analytics.dart';

/// Widget that displays a heatmap of performance by day of week and hour of day
/// Darker colors indicate better (faster) times
class HeatmapWidget extends StatelessWidget {
  final SolveAnalytics analytics;

  const HeatmapWidget({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.heatmapData.isEmpty) {
      return _buildEmptyState(context);
    }

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('dashboard.heatmap_title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translate('dashboard.heatmap_subtitle'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            _buildHeatmap(theme),
            const SizedBox(height: 16),
            _buildColorLegend(theme),
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

  Widget _buildHeatmap(ThemeData theme) {
    // Create a map for quick lookup: (day, hour) -> HeatmapCell
    final cellMap = <String, HeatmapCell>{};
    for (final cell in analytics.heatmapData) {
      cellMap['${cell.dayOfWeek}-${cell.hourOfDay}'] = cell;
    }

    // Find min/max times for color scaling
    final allTimes = analytics.heatmapData.map((c) => c.averageTime).toList();
    final minTime = allTimes.reduce(math.min);
    final maxTime = allTimes.reduce(math.max);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with hour labels
          Row(
            children: [
              // Empty corner cell
              const SizedBox(width: 80, height: 30),
              // Hour labels (0-23)
              ...List.generate(24, (hour) {
                return SizedBox(
                  width: 32, // Matches cell width (30) + margin (1+1)
                  height: 30,
                  child: Center(
                    child: Text(
                      _formatHour(hour),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          // Heatmap grid (7 days x 24 hours)
          ...List.generate(7, (dayIndex) {
            final day = dayIndex + 1; // 1-7 (Monday-Sunday)
            return Row(
              children: [
                // Day label
                SizedBox(
                  width: 80,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _getDayName(day),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Hour cells
                ...List.generate(24, (hour) {
                  final cell = cellMap['$day-$hour'];
                  return _buildHeatmapCell(
                    cell: cell,
                    minTime: minTime,
                    maxTime: maxTime,
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeatmapCell({
    required HeatmapCell? cell,
    required double minTime,
    required double maxTime,
  }) {
    Color color;
    String? tooltipText;

    if (cell == null) {
      // No data for this cell
      color = Colors.grey.shade200;
    } else {
      // Calculate color intensity (better times = darker green)
      final normalized = (cell.averageTime - minTime) / (maxTime - minTime);
      final intensity = 1.0 - normalized; // Invert: better times = higher value

      // Color gradient: light green -> dark green
      color = Color.lerp(
        Colors.green.shade100,
        Colors.green.shade800,
        intensity,
      )!;

      tooltipText =
          '${(cell.averageTime / 1000).toStringAsFixed(2)}s\n'
          '${cell.solveCount} ${translate('dashboard.solves_count')}';
    }

    return Tooltip(
      message: tooltipText ?? translate('dashboard.no_data'),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return translate('dashboard.day_monday');
      case 2:
        return translate('dashboard.day_tuesday');
      case 3:
        return translate('dashboard.day_wednesday');
      case 4:
        return translate('dashboard.day_thursday');
      case 5:
        return translate('dashboard.day_friday');
      case 6:
        return translate('dashboard.day_saturday');
      case 7:
        return translate('dashboard.day_sunday');
      default:
        return '';
    }
  }

  /// Formats hour based on locale (12h for en_US, 24h for pt_BR)
  String _formatHour(int hour) {
    // Check locale using tagDateTime translation
    final locale = translate('home_page.tagDateTime').toLowerCase();
    final isEnglish = locale.contains('en');

    if (isEnglish) {
      // 12-hour format with AM/PM
      if (hour == 0) {
        return '12A';
      } else if (hour < 12) {
        return '${hour}A';
      } else if (hour == 12) {
        return '12P';
      } else {
        return '${hour - 12}P';
      }
    } else {
      // 24-hour format
      return hour.toString();
    }
  }

  Widget _buildColorLegend(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate('dashboard.worst_time'),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
            Text(
              translate('dashboard.best_time'),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ],
        ),
        // Color gradient bar
        Row(
          children: List.generate(10, (index) {
            final intensity = index / 9.0;
            final color = Color.lerp(
              Colors.green.shade100,
              Colors.green.shade800,
              intensity,
            )!;
            return Flexible(child: Container(height: 16, color: color));
          }),
        ),
      ],
    );
  }
}
