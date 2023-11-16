import 'package:isar/isar.dart';

part 'record.g.dart';

@collection
class RecordEntity {
  Id? id = Isar.autoIncrement;
  int timer;

  RecordEntity({required this.timer});
}
