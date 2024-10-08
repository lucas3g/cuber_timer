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

      final records =
          result.map((e) => RecordEntity(id: e.id, timer: e.timer)).toList();

      emit(state.success(records: records));
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

  @computed
  int get bestTime {
    if (state.records.isEmpty) {
      return -1;
    }

    return state.records
        .reduce(
            (value, element) => value.timer < element.timer ? value : element)
        .timer;
  }

  @computed
  int get avgFive {
    if (state.records.isEmpty) {
      return -1;
    }

    final lenghList = state.records.length < 5 ? state.records.length : 5;

    final sum = state.records
        .take(lenghList)
        .map((e) => e.timer)
        .reduce((value, element) => value + element);

    return (sum ~/ lenghList);
  }

  @computed
  int get avgTwelve {
    if (state.records.isEmpty) {
      return -1;
    }

    final lenghList = state.records.length < 12 ? state.records.length : 12;

    final sum = state.records
        .take(lenghList)
        .map((e) => e.timer)
        .reduce((value, element) => value + element);

    return (sum ~/ lenghList);
  }
}
