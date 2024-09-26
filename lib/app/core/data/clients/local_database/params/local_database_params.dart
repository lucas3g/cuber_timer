import '../helpers/tables.dart';

class GetDataParams {
  final Tables table;
  final String? filter;

  GetDataParams({required this.table, this.filter});
}

class UpdateOrInsertDataParams {
  final Tables table;
  final dynamic data;

  UpdateOrInsertDataParams({required this.table, required this.data});
}

class RemoveDataParams {
  final Tables table;
  final int? id;

  RemoveDataParams({required this.table, required this.id});
}
