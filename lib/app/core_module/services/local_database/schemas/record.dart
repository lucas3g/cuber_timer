import 'package:isar/isar.dart';

part 'record.g.dart';

@collection
class Record {
  Id? id = Isar.autoIncrement;
  int timer;

  Record({required this.timer});
}
