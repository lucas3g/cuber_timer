import '../../../../core/data/clients/local_database/drift_database.dart';

abstract class RecordStates {
  final List<Record> records;

  RecordStates({required this.records});

  LoadingListRecordState loading() {
    return LoadingListRecordState(records: records);
  }

  SuccessGetListRecordState success({List<Record>? records}) {
    return SuccessGetListRecordState(records: records ?? this.records);
  }

  ErrorRecordState error(String message) {
    return ErrorRecordState(records: records, message: message);
  }

  SuccessDeleteRecordState successDelete(String groupDelete) {
    return SuccessDeleteRecordState(records: records, groupDelete: groupDelete);
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

class SuccessDeleteRecordState extends RecordStates {
  final String groupDelete;

  SuccessDeleteRecordState({required super.records, required this.groupDelete});
}

class ErrorRecordState extends RecordStates {
  final String message;

  ErrorRecordState({required super.records, required this.message});
}
