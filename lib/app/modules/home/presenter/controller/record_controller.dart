import 'package:cuber_timer/app/core_module/services/local_database/helpers/tables.dart';
import 'package:cuber_timer/app/core_module/services/local_database/local_database.dart';
import 'package:cuber_timer/app/core_module/services/local_database/params/local_database_params.dart';
import 'package:cuber_timer/app/core_module/services/local_database/schemas/record.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:mobx/mobx.dart';

part 'record_controller.g.dart';

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

      final records = result.map((e) => RecordEntity(timer: e.timer)).toList();

      records.sort((a, b) => a.timer.compareTo(b.timer));

      emit(state.success(records: records));
    } catch (e) {
      emit(state.error('Error when trying to load the highscore list'));
    }
  }
}
