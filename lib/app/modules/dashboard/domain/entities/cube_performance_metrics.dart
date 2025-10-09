import 'package:equatable/equatable.dart';

/// Represents comprehensive performance metrics for a specific cube model
class CubePerformanceMetrics extends Equatable {
  final String cubeModel;
  final int totalSolves;
  final int bestSingle;
  final int worstSingle;
  final int medianTime;
  final int averageTime;
  final double stdDeviation;
  final double consistencyScore; // 1 - (std / mean), higher is better
  final int? currentAo5;
  final int? currentAo12;
  final List<int> allTimes;
  final PerformanceCategory category;
  final double percentDifferenceFromBest;

  const CubePerformanceMetrics({
    required this.cubeModel,
    required this.totalSolves,
    required this.bestSingle,
    required this.worstSingle,
    required this.medianTime,
    required this.averageTime,
    required this.stdDeviation,
    required this.consistencyScore,
    this.currentAo5,
    this.currentAo12,
    required this.allTimes,
    required this.category,
    required this.percentDifferenceFromBest,
  });

  bool get hasEnoughDataForAo5 => totalSolves >= 5;
  bool get hasEnoughDataForAo12 => totalSolves >= 12;
  bool get isConsistent => consistencyScore >= 0.85;

  @override
  List<Object?> get props => [
        cubeModel,
        totalSolves,
        bestSingle,
        medianTime,
        averageTime,
        stdDeviation,
        consistencyScore,
      ];
}

/// Performance categories for cube models
enum PerformanceCategory {
  excellent, // Within 5% of best
  good, // Within 5-10% of best
  average, // Within 10-20% of best
  needsImprovement; // More than 20% slower than best

  String getTranslationKey() {
    switch (this) {
      case PerformanceCategory.excellent:
        return 'dashboard.category_excellent';
      case PerformanceCategory.good:
        return 'dashboard.category_good';
      case PerformanceCategory.average:
        return 'dashboard.category_average';
      case PerformanceCategory.needsImprovement:
        return 'dashboard.category_needs_improvement';
    }
  }
}

/// Data point for time series charts
class TimeSeriesDataPoint extends Equatable {
  final DateTime timestamp;
  final int solveTime;
  final String cubeModel;
  final bool isOutlier;

  const TimeSeriesDataPoint({
    required this.timestamp,
    required this.solveTime,
    required this.cubeModel,
    this.isOutlier = false,
  });

  @override
  List<Object?> get props => [timestamp, solveTime, cubeModel];
}

/// Outlier data point with context
class OutlierPoint extends Equatable {
  final DateTime timestamp;
  final int solveTime;
  final String cubeModel;
  final double zScore; // How many standard deviations from mean

  const OutlierPoint({
    required this.timestamp,
    required this.solveTime,
    required this.cubeModel,
    required this.zScore,
  });

  bool get isSevereOutlier => zScore.abs() > 3;

  @override
  List<Object?> get props => [timestamp, solveTime, cubeModel, zScore];
}

/// Heatmap cell data for day x hour analysis
class HeatmapCell extends Equatable {
  final int dayOfWeek; // 1-7 (Monday-Sunday)
  final int hourOfDay; // 0-23
  final double averageTime;
  final int solveCount;

  const HeatmapCell({
    required this.dayOfWeek,
    required this.hourOfDay,
    required this.averageTime,
    required this.solveCount,
  });

  @override
  List<Object?> get props => [dayOfWeek, hourOfDay, averageTime, solveCount];
}
