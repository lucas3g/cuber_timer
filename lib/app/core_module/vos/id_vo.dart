import 'package:result_dart/result_dart.dart';

import 'value_object.dart';

class IdVO extends ValueObject<int> {
  const IdVO(super.value);

  @override
  Result<IdVO, String> validate([Object? object]) {
    if (value < -1) {
      return '$runtimeType não pode ser menor que menos 1 (-1)'.toFailure();
    }
    return Success(this);
  }
}
