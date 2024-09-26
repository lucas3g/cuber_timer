import '../entities/either_of.dart';
import 'value_object.dart';

class BoolVO extends ValueObject<bool> {
  const BoolVO(super.value);

  @override
  EitherOf<String, BoolVO> validate([Object? object]) {
    return resolve(this);
  }
}
