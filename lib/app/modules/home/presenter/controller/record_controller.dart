import 'package:cuber_timer/app/core/data/clients/local_database/helpers/tables.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/local_database.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/params/local_database_params.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'record_controller.g.dart';

@Singleton()
class RecordController = RecordControllerBase with _$RecordController;

abstract class RecordControllerBase with Store {
  final ILocalDatabase localDatabase;

  RecordControllerBase({required this.localDatabase});

  @observable
  RecordStates state = InitialRecordState();

  @action
  RecordStates emit(RecordStates newState) {
    return state = newState;
  }

  @action
  Future getAllRecords() async {
    try {
      emit(state.loading());

      final params = GetDataParams(table: Tables.records);

      final result =
          await localDatabase.get(params: params) as List<RecordEntity>;

      final records = result
          .map(
            (e) => RecordEntity(
              id: e.id,
              timer: e.timer,
              group: e.group,
              createdAt: e.createdAt,
            ),
          )
          .toList();

      emit(state.success(records: records));
    } catch (e) {
      emit(state.error('Error when trying to load the highscore list'));
    }
  }

  @action
  Future getFiveRecordsByGroup() async {
    try {
      emit(state.loading());

      final params = GetDataParams(table: Tables.records);

      final result =
          await localDatabase.get(params: params) as List<RecordEntity>;

      // Cria um Map para agrupar os registros por grupo
      final Map<String, List<RecordEntity>> grouped = {};

      for (final record in result) {
        grouped.putIfAbsent(record.group, () => []).add(record);
      }

      // Filtra os 5 melhores por grupo
      final List<RecordEntity> filteredRecords = [];

      grouped.forEach((group, groupRecords) {
        final sorted = [...groupRecords]
          ..sort((a, b) => a.timer.compareTo(b.timer));
        filteredRecords.addAll(sorted.take(5));
      });

      emit(state.success(records: filteredRecords));
    } catch (e) {
      emit(state.error('Error when trying to load the highscore list'));
    }
  }

  @action
  Future deleteRecord(RecordEntity record) async {
    final params = RemoveDataParams(table: Tables.records, id: record.id);

    await localDatabase.remove(params: params);

    state.records.remove(record);

    emit(state.success());
  }

  @action
  int bestTime(String group) {
    if (state.records.where((e) => e.group.contains(group)).isEmpty) {
      return -1;
    }

    return state.records
        .where((e) => e.group == group)
        .reduce(
            (value, element) => value.timer < element.timer ? value : element)
        .timer;
  }

  @action
  int avgFive(String group) {
    if (state.records.where((e) => e.group.contains(group)).isEmpty) {
      return -1;
    }

    final lenghList = state.records.length < 5 ? state.records.length : 5;

    final sum = state.records
        .where((e) => e.group == group)
        .take(lenghList)
        .map((e) => e.timer)
        .reduce((value, element) => value + element);

    return (sum ~/ lenghList);
  }

  @action
  int avgTwelve(String group) {
    if (state.records.where((e) => e.group.contains(group)).isEmpty) {
      return -1;
    }

    final lenghList = state.records.length < 12 ? state.records.length : 12;

    final sum = state.records
        .where((e) => e.group == group)
        .take(lenghList)
        .map((e) => e.timer)
        .reduce((value, element) => value + element);

    return (sum ~/ lenghList);
  }

  @action
  Future<void> getAllRecordsByGroup(String group) async {
    try {
      emit(state.loading());

      final params = GetDataParams(
        table: Tables.records,
        filter: group,
      );

      final result =
          await localDatabase.get(params: params) as List<RecordEntity>;

      final records = result
          .map(
            (e) => RecordEntity(
              id: e.id,
              timer: e.timer,
              group: e.group,
              createdAt: e.createdAt,
            ),
          )
          .toList();

      emit(state.success(records: records));
    } catch (e) {
      emit(state.error('Error when trying to load the highscore list'));
    }
  }
}
