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
bestTimeByGroup: ${bestTimeByGroup}
    ''';
  }
}
