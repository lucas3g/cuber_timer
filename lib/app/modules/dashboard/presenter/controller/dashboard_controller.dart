import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/data/clients/local_database/drift_database.dart';
import '../../../../core/data/clients/local_database/helpers/tables.dart';
import '../../../../core/data/clients/local_database/local_database.dart';
import '../../../../core/data/clients/local_database/params/local_database_params.dart';
import '../../../../shared/translate/translate.dart';

part 'dashboard_controller.g.dart';

@Singleton()
class DashboardController = DashboardControllerBase with _$DashboardController;

abstract class DashboardControllerBase with Store {
  final ILocalDatabase localDatabase;

  DashboardControllerBase({required this.localDatabase});

  @observable
  List<Record> allRecords = [];

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadAllRecords() async {
    try {
      isLoading = true;
      errorMessage = null;

      final params = GetDataParams(table: Tables.records);
      final result = await localDatabase.get(params: params) as List<Record>;

      allRecords = result;
      isLoading = false;
    } catch (e) {
      errorMessage = translate('dashboard.error_loading');
      isLoading = false;
    }
  }

  @computed
  int get totalSolves => allRecords.length;

  @computed
  int get bestTimeOverall {
    if (allRecords.isEmpty) return -1;
    return allRecords
        .reduce((value, element) => value.timer < element.timer ? value : element)
        .timer;
  }

  @computed
  int get averageTime {
    if (allRecords.isEmpty) return -1;
    final sum = allRecords.map((e) => e.timer).reduce((a, b) => a + b);
    return sum ~/ allRecords.length;
  }

  @computed
  Map<String, int> get solvesByGroup {
    final Map<String, int> groupCounts = {};
    for (var record in allRecords) {
      groupCounts[record.group] = (groupCounts[record.group] ?? 0) + 1;
    }
    return groupCounts;
  }

  @computed
  String get mostPracticedGroup {
    if (solvesByGroup.isEmpty) return '';

    return solvesByGroup.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  @computed
  List<String> get practiceRecommendations {
    final recommendations = <String>[];

    if (totalSolves == 0) {
      recommendations.add(translate('dashboard.recommendation_start_practicing'));
      return recommendations;
    }

    // Encontrar grupos com menos prática
    final sortedGroups = solvesByGroup.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    if (sortedGroups.length > 1) {
      final leastPracticed = sortedGroups.first.key;
      recommendations.add('${translate('dashboard.recommendation_practice_more')} $leastPracticed');
    }

    // Verificar se há progresso recente
    if (allRecords.length >= 5) {
      final recentRecords = allRecords.take(5).toList();
      final recentAvg = recentRecords.map((e) => e.timer).reduce((a, b) => a + b) ~/ 5;

      if (recentAvg < averageTime) {
        recommendations.add(translate('dashboard.recommendation_great_progress'));
      } else {
        recommendations.add(translate('dashboard.recommendation_keep_practicing'));
      }
    }

    // Adicionar dica sobre consistência
    if (mostPracticedGroup.isNotEmpty) {
      recommendations.add('${translate('dashboard.recommendation_doing_great')} $mostPracticedGroup!');
    }

    return recommendations;
  }

  @computed
  Map<String, int> get bestTimeByGroup {
    final Map<String, int> bestTimes = {};

    for (var group in solvesByGroup.keys) {
      final groupRecords = allRecords.where((r) => r.group == group).toList();
      if (groupRecords.isNotEmpty) {
        bestTimes[group] = groupRecords
            .reduce((a, b) => a.timer < b.timer ? a : b)
            .timer;
      }
    }

    return bestTimes;
  }
}
