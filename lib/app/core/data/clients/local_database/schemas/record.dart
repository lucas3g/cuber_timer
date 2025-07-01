import 'package:isar/isar.dart';

part 'record.g.dart';

@collection
class RecordEntity {
  Id? id = Isar.autoIncrement;
  int timer;
  String group = 'Old Records';
  DateTime createdAt = DateTime.now();

  RecordEntity(
      {this.id,
      required this.timer,
      required this.group,
      required this.createdAt});
}
