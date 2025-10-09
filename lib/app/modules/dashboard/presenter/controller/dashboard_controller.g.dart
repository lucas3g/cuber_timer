// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardController on DashboardControllerBase, Store {
  Computed<int>? _$totalSolvesComputed;

  @override
  int get totalSolves => (_$totalSolvesComputed ??= Computed<int>(
    () => super.totalSolves,
    name: 'DashboardControllerBase.totalSolves',
  )).value;
  Computed<int>? _$bestTimeOverallComputed;

  @override
  int get bestTimeOverall => (_$bestTimeOverallComputed ??= Computed<int>(
    () => super.bestTimeOverall,
    name: 'DashboardControllerBase.bestTimeOverall',
  )).value;
  Computed<int>? _$averageTimeComputed;

  @override
  int get averageTime => (_$averageTimeComputed ??= Computed<int>(
    () => super.averageTime,
    name: 'DashboardControllerBase.averageTime',
  )).value;
  Computed<Map<String, int>>? _$solvesByGroupComputed;

  @override
  Map<String, int> get solvesByGroup =>
      (_$solvesByGroupComputed ??= Computed<Map<String, int>>(
        () => super.solvesByGroup,
        name: 'DashboardControllerBase.solvesByGroup',
      )).value;
  Computed<String>? _$mostPracticedGroupComputed;

  @override
  String get mostPracticedGroup =>
      (_$mostPracticedGroupComputed ??= Computed<String>(
        () => super.mostPracticedGroup,
        name: 'DashboardControllerBase.mostPracticedGroup',
      )).value;
  Computed<List<String>>? _$practiceRecommendationsComputed;

  @override
  List<String> get practiceRecommendations =>
      (_$practiceRecommendationsComputed ??= Computed<List<String>>(
        () => super.practiceRecommendations,
        name: 'DashboardControllerBase.practiceRecommendations',
      )).value;
  Computed<Map<String, int>>? _$bestTimeByGroupComputed;

  @override
  Map<String, int> get bestTimeByGroup =>
      (_$bestTimeByGroupComputed ??= Computed<Map<String, int>>(
        () => super.bestTimeByGroup,
        name: 'DashboardControllerBase.bestTimeByGroup',
      )).value;
  Computed<SolveAnalytics>? _$analyticsComputed;

  @override
  SolveAnalytics get analytics =>
      (_$analyticsComputed ??= Computed<SolveAnalytics>(
        () => super.analytics,
        name: 'DashboardControllerBase.analytics',
      )).value;
  Computed<int?>? _$currentAo5Computed;

  @override
  int? get currentAo5 => (_$currentAo5Computed ??= Computed<int?>(
    () => super.currentAo5,
    name: 'DashboardControllerBase.currentAo5',
  )).value;
  Computed<int?>? _$currentAo12Computed;

  @override
  int? get currentAo12 => (_$currentAo12Computed ??= Computed<int?>(
    () => super.currentAo12,
    name: 'DashboardControllerBase.currentAo12',
  )).value;
  Computed<double>? _$consistencyScoreComputed;

  @override
  double get consistencyScore =>
      (_$consistencyScoreComputed ??= Computed<double>(
        () => super.consistencyScore,
        name: 'DashboardControllerBase.consistencyScore',
      )).value;
  Computed<double>? _$improvementRateComputed;

  @override
  double get improvementRate => (_$improvementRateComputed ??= Computed<double>(
    () => super.improvementRate,
    name: 'DashboardControllerBase.improvementRate',
  )).value;
  Computed<bool>? _$isImprovingComputed;

  @override
  bool get isImproving => (_$isImprovingComputed ??= Computed<bool>(
    () => super.isImproving,
    name: 'DashboardControllerBase.isImproving',
  )).value;
  Computed<TrendDirection>? _$overallTrendComputed;

  @override
  TrendDirection get overallTrend =>
      (_$overallTrendComputed ??= Computed<TrendDirection>(
        () => super.overallTrend,
        name: 'DashboardControllerBase.overallTrend',
      )).value;
  Computed<String?>? _$bestPerformingCubeComputed;

  @override
  String? get bestPerformingCube =>
      (_$bestPerformingCubeComputed ??= Computed<String?>(
        () => super.bestPerformingCube,
        name: 'DashboardControllerBase.bestPerformingCube',
      )).value;
  Computed<String?>? _$mostConsistentCubeComputed;

  @override
  String? get mostConsistentCube =>
      (_$mostConsistentCubeComputed ??= Computed<String?>(
        () => super.mostConsistentCube,
        name: 'DashboardControllerBase.mostConsistentCube',
      )).value;
  Computed<int>? _$outliersCountComputed;

  @override
  int get outliersCount => (_$outliersCountComputed ??= Computed<int>(
    () => super.outliersCount,
    name: 'DashboardControllerBase.outliersCount',
  )).value;
  Computed<int?>? _$bestDayOfWeekComputed;

  @override
  int? get bestDayOfWeek => (_$bestDayOfWeekComputed ??= Computed<int?>(
    () => super.bestDayOfWeek,
    name: 'DashboardControllerBase.bestDayOfWeek',
  )).value;
  Computed<int?>? _$bestHourOfDayComputed;

  @override
  int? get bestHourOfDay => (_$bestHourOfDayComputed ??= Computed<int?>(
    () => super.bestHourOfDay,
    name: 'DashboardControllerBase.bestHourOfDay',
  )).value;
  Computed<List<String>>? _$intelligentInsightsComputed;

  @override
  List<String> get intelligentInsights =>
      (_$intelligentInsightsComputed ??= Computed<List<String>>(
        () => super.intelligentInsights,
        name: 'DashboardControllerBase.intelligentInsights',
      )).value;
  Computed<List<CubeRecommendation>>? _$cubeRecommendationsComputed;

  @override
  List<CubeRecommendation> get cubeRecommendations =>
      (_$cubeRecommendationsComputed ??= Computed<List<CubeRecommendation>>(
        () => super.cubeRecommendations,
        name: 'DashboardControllerBase.cubeRecommendations',
      )).value;
  Computed<PerformanceSummary>? _$performanceSummaryComputed;

  @override
  PerformanceSummary get performanceSummary =>
      (_$performanceSummaryComputed ??= Computed<PerformanceSummary>(
        () => super.performanceSummary,
        name: 'DashboardControllerBase.performanceSummary',
      )).value;

  late final _$allRecordsAtom = Atom(
    name: 'DashboardControllerBase.allRecords',
    context: context,
  );

  @override
  List<Record> get allRecords {
    _$allRecordsAtom.reportRead();
    return super.allRecords;
  }

  @override
  set allRecords(List<Record> value) {
    _$allRecordsAtom.reportWrite(value, super.allRecords, () {
      super.allRecords = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'DashboardControllerBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'DashboardControllerBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadAllRecordsAsyncAction = AsyncAction(
    'DashboardControllerBase.loadAllRecords',
    context: context,
  );

  @override
  Future<void> loadAllRecords() {
    return _$loadAllRecordsAsyncAction.run(() => super.loadAllRecords());
  }

  @override
  String toString() {
    return '''
allRecords: ${allRecords},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
totalSolves: ${totalSolves},
bestTimeOverall: ${bestTimeOverall},
averageTime: ${averageTime},
solvesByGroup: ${solvesByGroup},
mostPracticedGroup: ${mostPracticedGroup},
practiceRecommendations: ${practiceRecommendations},
bestTimeByGroup: ${bestTimeByGroup},
analytics: ${analytics},
currentAo5: ${currentAo5},
currentAo12: ${currentAo12},
consistencyScore: ${consistencyScore},
improvementRate: ${improvementRate},
isImproving: ${isImproving},
overallTrend: ${overallTrend},
bestPerformingCube: ${bestPerformingCube},
mostConsistentCube: ${mostConsistentCube},
outliersCount: ${outliersCount},
bestDayOfWeek: ${bestDayOfWeek},
bestHourOfDay: ${bestHourOfDay},
intelligentInsights: ${intelligentInsights},
cubeRecommendations: ${cubeRecommendations},
performanceSummary: ${performanceSummary}
    ''';
  }
}
