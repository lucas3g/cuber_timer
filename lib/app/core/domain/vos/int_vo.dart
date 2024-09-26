import '../entities/either_of.dart';
import 'value_object.dart';

class IntVO extends ValueObject<int> {
  const IntVO(super.value);

  @override
  EitherOf<String, IntVO> validate([Object? object]) {
    if (value < 0) {
      return reject('$runtimeType não pode ser menor que zero');
    }
    return resolve(this);
  }
}
