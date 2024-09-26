import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';

abstract class RecordStates {
  final List<RecordEntity> records;

  RecordStates({required this.records});

  LoadingListRecordState loading() {
    return LoadingListRecordState(records: records);
  }

  SuccessGetListRecordState success({List<RecordEntity>? records}) {
    return SuccessGetListRecordState(records: records ?? this.records);
  }

  ErrorRecordState error(String message) {
    return ErrorRecordState(records: records, message: message);
  }
}

class InitialRecordState extends RecordStates {
  InitialRecordState() : super(records: []);
}

class LoadingListRecordState extends RecordStates {
  LoadingListRecordState({required super.records});
}

class SuccessGetListRecordState extends RecordStates {
  SuccessGetListRecordState({required super.records});
}

class ErrorRecordState extends RecordStates {
  final String message;

  ErrorRecordState({required super.records, required this.message});
}
