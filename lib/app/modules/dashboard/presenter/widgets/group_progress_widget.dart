import 'package:flutter/material.dart';
import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GroupProgressWidget extends StatelessWidget {
  final String group;
  final int solveCount;
  final int bestTime;
  final int maxSolves;

  const GroupProgressWidget({
    super.key,
    required this.group,
    required this.solveCount,
    required this.bestTime,
    required this.maxSolves,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxSolves > 0 ? solveCount / maxSolves : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.myTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.myTheme.onSurface.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$solveCount solves',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.myTheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: context.myTheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                context.myTheme.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best time:',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.myTheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                bestTime > 0
                    ? StopWatchTimer.getDisplayTime(bestTime, hours: false)
                    : '-',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
