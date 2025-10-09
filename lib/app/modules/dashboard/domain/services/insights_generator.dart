import 'package:injectable/injectable.dart';

import '../../../../shared/translate/translate.dart';
import '../entities/cube_performance_metrics.dart';
import '../entities/solve_analytics.dart';

/// Service responsible for generating intelligent insights from solve analytics
@injectable
class InsightsGenerator {
  /// Generates a list of actionable insights from the analytics data
  List<String> generateInsights(SolveAnalytics analytics) {
    if (analytics.totalSolves == 0) {
      return [translate('dashboard.recommendation_start_practicing')];
    }

    final insights = <String>[];

    // 1. Best performing cube insight
    if (analytics.bestPerformingCube != null) {
      final bestMetrics = analytics.cubeMetrics[analytics.bestPerformingCube]!;
      insights.add(
        translate('dashboard.best_model_insight')
            .replaceAll('{model}', analytics.bestPerformingCube!)
            .replaceAll(
              '{time}',
              '${(bestMetrics.medianTime / 1000).toStringAsFixed(2)}s',
            ),
      );
    }

    // 2. Inconsistent cube warning
    final inconsistentCubes = analytics.cubeMetrics.values
        .where((m) => m.consistencyScore < 0.7 && m.totalSolves >= 10)
        .toList()
      ..sort((a, b) => a.consistencyScore.compareTo(b.consistencyScore));

    if (inconsistentCubes.isNotEmpty) {
      final worst = inconsistentCubes.first;
      insights.add(
        translate('dashboard.inconsistent_model')
            .replaceAll('{model}', worst.cubeModel)
            .replaceAll(
              '{std}',
              '${(worst.stdDeviation / 1000).toStringAsFixed(2)}s',
            ),
      );
    }

    // 3. Improvement trend insight
    if (analytics.hasEnoughDataForTrends) {
      if (analytics.improvementRate < -2) {
        // Improving (negative rate means getting faster)
        insights.add(
          translate('dashboard.improvement_trend')
              .replaceAll(
                '{percent}',
                analytics.improvementRate.abs().toStringAsFixed(1),
              )
              .replaceAll('{days}', '7'),
        );
      } else if (analytics.improvementRate.abs() < 2) {
        // Plateauing
        insights.add(translate('dashboard.no_improvement'));
      }
    }

    // 4. Consistency feedback
    if (analytics.consistencyScoreOverall >= 0.85) {
      insights.add(translate('dashboard.consistency_excellent'));
    } else if (analytics.consistencyScoreOverall < 0.7 &&
        analytics.totalSolves >= 20) {
      insights.add(translate('dashboard.consistency_needs_work'));
    }

    // 5. Outlier detection warning
    if (analytics.hasOutliers) {
      insights.add(
        translate('dashboard.outlier_detected')
            .replaceAll('{count}', analytics.outliers.length.toString()),
      );
    }

    // 6. Best day/hour insights
    if (analytics.bestDayOfWeek != null && analytics.totalSolves >= 20) {
      insights.add(
        translate('dashboard.best_day_insight')
            .replaceAll('{day}', _getDayName(analytics.bestDayOfWeek!)),
      );
    }

    if (analytics.bestHourOfDay != null && analytics.totalSolves >= 30) {
      insights.add(
        translate('dashboard.best_hour_insight')
            .replaceAll('{hour}', analytics.bestHourOfDay.toString()),
      );
    }

    // 7. Most consistent cube
    if (analytics.mostConsistentCube != null && analytics.cubeMetrics.length > 1) {
      final consistentMetrics =
          analytics.cubeMetrics[analytics.mostConsistentCube]!;
      final score = (consistentMetrics.consistencyScore * 100).toStringAsFixed(0);
      insights.add(
        translate('dashboard.most_consistent_cube')
            .replaceAll('{model}', analytics.mostConsistentCube!)
            .replaceAll('{score}', score),
      );
    }

    // 8. Cube-specific practice recommendations
    final needsPractice = analytics.cubeMetrics.values
        .where((m) =>
            m.category == PerformanceCategory.needsImprovement ||
            m.category == PerformanceCategory.average)
        .toList()
      ..sort((a, b) =>
          b.percentDifferenceFromBest.compareTo(a.percentDifferenceFromBest));

    if (needsPractice.isNotEmpty && analytics.cubeMetrics.length > 1) {
      final worstCube = needsPractice.first;
      insights.add(
        translate('dashboard.practice_focus')
            .replaceAll('{model}', worstCube.cubeModel),
      );
    }

    return insights;
  }

  /// Generates performance recommendations for specific cube models
  List<CubeRecommendation> generateCubeRecommendations(
    SolveAnalytics analytics,
  ) {
    final recommendations = <CubeRecommendation>[];

    for (final metrics in analytics.cubeMetrics.values) {
      final suggestions = <String>[];

      // Check consistency
      if (metrics.consistencyScore < 0.7 && metrics.totalSolves >= 10) {
        suggestions.add(translate('dashboard.suggestion_practice_more'));
      }

      // Check if significantly slower than best
      if (metrics.percentDifferenceFromBest > 15) {
        suggestions.add(translate('dashboard.suggestion_check_tension'));
        suggestions.add(translate('dashboard.suggestion_technique'));
      }

      if (suggestions.isNotEmpty) {
        recommendations.add(
          CubeRecommendation(
            cubeModel: metrics.cubeModel,
            category: metrics.category,
            suggestions: suggestions,
          ),
        );
      }
    }

    return recommendations;
  }

  /// Generates a performance summary with best and worst performers
  PerformanceSummary generatePerformanceSummary(SolveAnalytics analytics) {
    if (analytics.cubeMetrics.isEmpty) {
      return PerformanceSummary(
        bestPerformers: [],
        needsPractice: [],
      );
    }

    final sorted = analytics.cubeMetrics.values.toList()
      ..sort((a, b) => a.medianTime.compareTo(b.medianTime));

    // Best performers: top 2 or excellent/good categories
    final bestPerformers = sorted
        .where((m) =>
            m.category == PerformanceCategory.excellent ||
            m.category == PerformanceCategory.good)
        .take(2)
        .toList();

    // Needs practice: bottom 2 or needs improvement category
    final needsPractice = sorted.reversed
        .where((m) =>
            m.category == PerformanceCategory.needsImprovement ||
            m.category == PerformanceCategory.average)
        .take(2)
        .toList();

    return PerformanceSummary(
      bestPerformers: bestPerformers,
      needsPractice: needsPractice.toList(),
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
}

/// Recommendation for a specific cube model
class CubeRecommendation {
  final String cubeModel;
  final PerformanceCategory category;
  final List<String> suggestions;

  CubeRecommendation({
    required this.cubeModel,
    required this.category,
    required this.suggestions,
  });
}

/// Summary of best and worst performing cube models
class PerformanceSummary {
  final List<CubePerformanceMetrics> bestPerformers;
  final List<CubePerformanceMetrics> needsPractice;

  PerformanceSummary({
    required this.bestPerformers,
    required this.needsPractice,
  });
}
