import 'package:result_dart/result_dart.dart';

import '../vos/id_vo.dart';

abstract class Entity {
  final IdVO id;

  Result<Entity, String> validate([Object? object]) {
    return id.validate().pure(this);
  }

  const Entity({required this.id});

  @override
  bool operator ==(covariant Entity other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
