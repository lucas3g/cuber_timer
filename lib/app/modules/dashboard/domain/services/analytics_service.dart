import 'dart:math' as math;
import 'package:injectable/injectable.dart';
import 'package:collection/collection.dart';

import '../../../../core/data/clients/local_database/drift_database.dart';
import '../entities/cube_performance_metrics.dart';
import '../entities/solve_analytics.dart';

/// Service responsible for processing solve data and generating analytics
@injectable
class AnalyticsService {
  /// Processes a list of records and returns comprehensive analytics
  SolveAnalytics processRecords(
    List<Record> records, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? cubeFilter,
  }) {
    if (records.isEmpty) {
      return const EmptyAnalytics();
    }

    // Apply filters
    var filteredRecords = records.where((r) {
      if (startDate != null && r.createdAt.isBefore(startDate)) return false;
      if (endDate != null && r.createdAt.isAfter(endDate)) return false;
      if (cubeFilter != null &&
          cubeFilter.isNotEmpty &&
          !cubeFilter.contains(r.group)) return false;
      return true;
    }).toList();

    if (filteredRecords.isEmpty) {
      return const EmptyAnalytics();
    }

    // Sort by timestamp (oldest first) for proper trend calculation
    filteredRecords.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Calculate overall statistics
    final times = filteredRecords.map((r) => r.timer).toList();
    final totalSolves = times.length;
    final bestSingle = times.reduce(math.min);
    final worstSingle = times.reduce(math.max);
    final averageTime = (times.reduce((a, b) => a + b) / times.length).round();
    final medianTime = _calculateMedian(times);
    final stdDev = _calculateStdDeviation(times);
    final consistency = _calculateConsistencyScore(times, stdDev);

    // Rolling averages
    final ao5History = calculateRollingAo5(filteredRecords);
    final ao12History = calculateRollingAo12(filteredRecords);
    final currentAo5 = ao5History.isNotEmpty ? ao5History.last : null;
    final currentAo12 = ao12History.isNotEmpty ? ao12History.last : null;

    // Trend analysis
    final improvementRate = calculateImprovementRate(filteredRecords);
    final last7Days = _getRecordsSince(
      filteredRecords,
      DateTime.now().subtract(const Duration(days: 7)),
    );
    final last30Days = _getRecordsSince(
      filteredRecords,
      DateTime.now().subtract(const Duration(days: 30)),
    );
    final last7DaysAvg = last7Days.isNotEmpty
        ? last7Days.map((r) => r.timer).reduce((a, b) => a + b) / last7Days.length
        : 0.0;
    final last30DaysAvg = last30Days.isNotEmpty
        ? last30Days.map((r) => r.timer).reduce((a, b) => a + b) / last30Days.length
        : 0.0;

    final trend = _determineTrend(improvementRate);

    // Per-cube analysis
    final cubeMetrics = analyzeCubePerformance(filteredRecords);
    final sortedCubes = cubeMetrics.values.toList()
      ..sort((a, b) => a.medianTime.compareTo(b.medianTime));

    final bestCube = sortedCubes.isNotEmpty ? sortedCubes.first.cubeModel : null;
    final worstCube = sortedCubes.isNotEmpty ? sortedCubes.last.cubeModel : null;
    final mostConsistent = cubeMetrics.values
        .reduce((a, b) => a.consistencyScore > b.consistencyScore ? a : b)
        .cubeModel;

    // Time series data
    final timeSeriesData = filteredRecords
        .map((r) => TimeSeriesDataPoint(
              timestamp: r.createdAt,
              solveTime: r.timer,
              cubeModel: r.group,
            ))
        .toList();

    // Outliers
    final outliers = detectOutliers(filteredRecords);

    // Time-based patterns
    final avgByDay = _calculateAverageByDayOfWeek(filteredRecords);
    final avgByHour = _calculateAverageByHourOfDay(filteredRecords);
    final heatmapData = _generateHeatmapData(filteredRecords);

    final bestDay = avgByDay.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
    final bestHour = avgByHour.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    return SolveAnalytics(
      totalSolves: totalSolves,
      bestSingleOverall: bestSingle,
      worstSingleOverall: worstSingle,
      medianTimeOverall: medianTime,
      averageTimeOverall: averageTime,
      stdDeviationOverall: stdDev,
      consistencyScoreOverall: consistency,
      currentAo5: currentAo5,
      currentAo12: currentAo12,
      rollingAo5History: ao5History,
      rollingAo12History: ao12History,
      overallTrend: trend,
      improvementRate: improvementRate,
      last7DaysAverage: last7DaysAvg,
      last30DaysAverage: last30DaysAvg,
      cubeMetrics: cubeMetrics,
      bestPerformingCube: bestCube,
      worstPerformingCube: worstCube,
      mostConsistentCube: mostConsistent,
      timeSeriesData: timeSeriesData,
      outliers: outliers,
      averageByDayOfWeek: avgByDay,
      averageByHourOfDay: avgByHour,
      heatmapData: heatmapData,
      bestDayOfWeek: bestDay,
      bestHourOfDay: bestHour,
    );
  }

  /// Calculates rolling Average of 5 (Ao5) for all solve sequences
  /// Ao5 = average of 5 solves, removing best and worst
  List<int> calculateRollingAo5(List<Record> records) {
    if (records.length < 5) return [];

    final ao5List = <int>[];
    for (int i = 0; i <= records.length - 5; i++) {
      final slice = records.skip(i).take(5).map((r) => r.timer).toList()..sort();
      // Remove best and worst, average the middle 3
      final middle3 = slice.sublist(1, 4);
      final ao5 = (middle3.reduce((a, b) => a + b) / 3).round();
      ao5List.add(ao5);
    }
    return ao5List;
  }

  /// Calculates rolling Average of 12 (Ao12)
  /// Ao12 = average of 12 solves, removing best and worst
  List<int> calculateRollingAo12(List<Record> records) {
    if (records.length < 12) return [];

    final ao12List = <int>[];
    for (int i = 0; i <= records.length - 12; i++) {
      final slice = records.skip(i).take(12).map((r) => r.timer).toList()..sort();
      // Remove best and worst, average the middle 10
      final middle10 = slice.sublist(1, 11);
      final ao12 = (middle10.reduce((a, b) => a + b) / 10).round();
      ao12List.add(ao12);
    }
    return ao12List;
  }

  /// Calculates improvement rate as percentage change per week using linear regression
  double calculateImprovementRate(List<Record> records) {
    if (records.length < 10) return 0.0;

    // Use linear regression on time series
    final n = records.length;
    final times = records.map((r) => r.timer.toDouble()).toList();
    final indices = List.generate(n, (i) => i.toDouble());

    final sumX = indices.reduce((a, b) => a + b);
    final sumY = times.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => indices[i] * times[i]).reduce((a, b) => a + b);
    final sumXX = indices.map((x) => x * x).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);

    // Convert slope to % change per week (assuming solves spread over time)
    final daysSpan = records.last.createdAt.difference(records.first.createdAt).inDays;
    if (daysSpan == 0) return 0.0;

    final slopesPerWeek = slope * (7.0 * n / daysSpan);
    final avgTime = times.reduce((a, b) => a + b) / n;
    return (slopesPerWeek / avgTime) * 100; // % change per week
  }

  /// Detects outliers using z-score method (> 3 standard deviations)
  List<OutlierPoint> detectOutliers(List<Record> records) {
    if (records.length < 10) return [];

    final times = records.map((r) => r.timer.toDouble()).toList();
    final mean = times.reduce((a, b) => a + b) / times.length;
    final stdDev = _calculateStdDeviation(records.map((r) => r.timer).toList());

    final outliers = <OutlierPoint>[];
    for (final record in records) {
      final zScore = (record.timer - mean) / stdDev;
      if (zScore.abs() > 3.0) {
        outliers.add(OutlierPoint(
          timestamp: record.createdAt,
          solveTime: record.timer,
          cubeModel: record.group,
          zScore: zScore,
        ));
      }
    }
    return outliers;
  }

  /// Analyzes performance metrics for each cube model
  Map<String, CubePerformanceMetrics> analyzeCubePerformance(List<Record> records) {
    final cubeGroups = groupBy(records, (Record r) => r.group);
    final allMedians = cubeGroups.values
        .map((records) => _calculateMedian(records.map((r) => r.timer).toList()))
        .toList()
      ..sort();
    final bestMedian = allMedians.isNotEmpty ? allMedians.first : 1;

    return cubeGroups.map((cubeModel, cubeRecords) {
      final times = cubeRecords.map((r) => r.timer).toList()..sort();
      final totalSolves = times.length;
      final best = times.first;
      final worst = times.last;
      final median = _calculateMedian(times);
      final average = (times.reduce((a, b) => a + b) / times.length).round();
      final stdDev = _calculateStdDeviation(times);
      final consistency = _calculateConsistencyScore(times, stdDev);

      final ao5 = calculateRollingAo5(cubeRecords).lastOrNull;
      final ao12 = calculateRollingAo12(cubeRecords).lastOrNull;

      final percentDiff = ((median - bestMedian) / bestMedian * 100);
      final category = _categorizePerformance(percentDiff);

      return MapEntry(
        cubeModel,
        CubePerformanceMetrics(
          cubeModel: cubeModel,
          totalSolves: totalSolves,
          bestSingle: best,
          worstSingle: worst,
          medianTime: median,
          averageTime: average,
          stdDeviation: stdDev,
          consistencyScore: consistency,
          currentAo5: ao5,
          currentAo12: ao12,
          allTimes: times,
          category: category,
          percentDifferenceFromBest: percentDiff,
        ),
      );
    });
  }

  // Private helper methods

  int _calculateMedian(List<int> numbers) {
    final sorted = List<int>.from(numbers)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      return ((sorted[mid - 1] + sorted[mid]) / 2).round();
    }
    return sorted[mid];
  }

  double _calculateStdDeviation(List<int> numbers) {
    if (numbers.isEmpty) return 0.0;
    final mean = numbers.reduce((a, b) => a + b) / numbers.length;
    final variance = numbers
            .map((n) => math.pow(n - mean, 2))
            .reduce((a, b) => a + b) /
        numbers.length;
    return math.sqrt(variance);
  }

  double _calculateConsistencyScore(List<int> times, double stdDev) {
    if (times.isEmpty) return 0.0;
    final mean = times.reduce((a, b) => a + b) / times.length;
    if (mean == 0) return 0.0;
    return math.max(0.0, 1.0 - (stdDev / mean));
  }

  PerformanceCategory _categorizePerformance(double percentDiff) {
    if (percentDiff <= 5) return PerformanceCategory.excellent;
    if (percentDiff <= 10) return PerformanceCategory.good;
    if (percentDiff <= 20) return PerformanceCategory.average;
    return PerformanceCategory.needsImprovement;
  }

  TrendDirection _determineTrend(double improvementRate) {
    if (improvementRate < -2) return TrendDirection.improving; // Getting faster
    if (improvementRate > 2) return TrendDirection.declining; // Getting slower
    return TrendDirection.plateauing;
  }

  List<Record> _getRecordsSince(List<Record> records, DateTime since) {
    return records.where((r) => r.createdAt.isAfter(since)).toList();
  }

  Map<int, double> _calculateAverageByDayOfWeek(List<Record> records) {
    final grouped = groupBy(records, (Record r) => r.createdAt.weekday);
    return grouped.map((day, dayRecords) {
      final avg = dayRecords.map((r) => r.timer).reduce((a, b) => a + b) / dayRecords.length;
      return MapEntry(day, avg);
    });
  }

  Map<int, double> _calculateAverageByHourOfDay(List<Record> records) {
    final grouped = groupBy(records, (Record r) => r.createdAt.hour);
    return grouped.map((hour, hourRecords) {
      final avg = hourRecords.map((r) => r.timer).reduce((a, b) => a + b) / hourRecords.length;
      return MapEntry(hour, avg);
    });
  }

  List<HeatmapCell> _generateHeatmapData(List<Record> records) {
    final cells = <HeatmapCell>[];
    for (int day = 1; day <= 7; day++) {
      for (int hour = 0; hour < 24; hour++) {
        final filtered = records.where((r) =>
            r.createdAt.weekday == day && r.createdAt.hour == hour);
        if (filtered.isNotEmpty) {
          final avg = filtered.map((r) => r.timer).reduce((a, b) => a + b) / filtered.length;
          cells.add(HeatmapCell(
            dayOfWeek: day,
            hourOfDay: hour,
            averageTime: avg,
            solveCount: filtered.length,
          ));
        }
      }
    }
    return cells;
  }
}
