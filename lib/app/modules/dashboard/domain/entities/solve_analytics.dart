import 'package:equatable/equatable.dart';
import 'cube_performance_metrics.dart';

/// Comprehensive analytics data for all solves
class SolveAnalytics extends Equatable {
  // Overall statistics
  final int totalSolves;
  final int bestSingleOverall;
  final int worstSingleOverall;
  final int medianTimeOverall;
  final int averageTimeOverall;
  final double stdDeviationOverall;
  final double consistencyScoreOverall;

  // Rolling averages
  final int? currentAo5;
  final int? currentAo12;
  final List<int> rollingAo5History;
  final List<int> rollingAo12History;

  // Trend analysis
  final TrendDirection overallTrend;
  final double improvementRate; // Percentage change per week
  final double last7DaysAverage;
  final double last30DaysAverage;

  // Per-cube analysis
  final Map<String, CubePerformanceMetrics> cubeMetrics;
  final String? bestPerformingCube;
  final String? worstPerformingCube;
  final String? mostConsistentCube;

  // Time series data
  final List<TimeSeriesDataPoint> timeSeriesData;
  final List<OutlierPoint> outliers;

  // Time-based patterns
  final Map<int, double> averageByDayOfWeek; // 1-7 -> average time
  final Map<int, double> averageByHourOfDay; // 0-23 -> average time
  final List<HeatmapCell> heatmapData;

  // Best performance periods
  final int? bestDayOfWeek; // 1-7
  final int? bestHourOfDay; // 0-23

  const SolveAnalytics({
    required this.totalSolves,
    required this.bestSingleOverall,
    required this.worstSingleOverall,
    required this.medianTimeOverall,
    required this.averageTimeOverall,
    required this.stdDeviationOverall,
    required this.consistencyScoreOverall,
    this.currentAo5,
    this.currentAo12,
    required this.rollingAo5History,
    required this.rollingAo12History,
    required this.overallTrend,
    required this.improvementRate,
    required this.last7DaysAverage,
    required this.last30DaysAverage,
    required this.cubeMetrics,
    this.bestPerformingCube,
    this.worstPerformingCube,
    this.mostConsistentCube,
    required this.timeSeriesData,
    required this.outliers,
    required this.averageByDayOfWeek,
    required this.averageByHourOfDay,
    required this.heatmapData,
    this.bestDayOfWeek,
    this.bestHourOfDay,
  });

  bool get hasEnoughDataForTrends => totalSolves >= 20;
  bool get hasEnoughDataForAo5 => totalSolves >= 5;
  bool get hasEnoughDataForAo12 => totalSolves >= 12;
  bool get isImproving => improvementRate < 0; // Negative rate = getting faster
  bool get hasOutliers => outliers.isNotEmpty;

  @override
  List<Object?> get props => [
        totalSolves,
        bestSingleOverall,
        medianTimeOverall,
        averageTimeOverall,
        improvementRate,
      ];
}

/// Trend direction enum
enum TrendDirection {
  improving, // Times getting faster
  plateauing, // No significant change
  declining; // Times getting slower

  String getTranslationKey() {
    switch (this) {
      case TrendDirection.improving:
        return 'dashboard.trend_improving';
      case TrendDirection.plateauing:
        return 'dashboard.trend_plateauing';
      case TrendDirection.declining:
        return 'dashboard.trend_declining';
    }
  }
}

/// Empty analytics instance for initialization
class EmptyAnalytics extends SolveAnalytics {
  const EmptyAnalytics()
      : super(
          totalSolves: 0,
          bestSingleOverall: 0,
          worstSingleOverall: 0,
          medianTimeOverall: 0,
          averageTimeOverall: 0,
          stdDeviationOverall: 0.0,
          consistencyScoreOverall: 0.0,
          rollingAo5History: const [],
          rollingAo12History: const [],
          overallTrend: TrendDirection.plateauing,
          improvementRate: 0.0,
          last7DaysAverage: 0.0,
          last30DaysAverage: 0.0,
          cubeMetrics: const {},
          timeSeriesData: const [],
          outliers: const [],
          averageByDayOfWeek: const {},
          averageByHourOfDay: const {},
          heatmapData: const [],
        );
}
