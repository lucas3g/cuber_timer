import '../entities/either_of.dart';
import 'value_object.dart';

class DoubleVO extends ValueObject<double> {
  const DoubleVO(super.value);

  @override
  EitherOf<String, DoubleVO> validate([Object? object]) {
    if (value < 0.0) {
      return reject('$runtimeType não pode ser menor que zero');
    }
    return resolve(this);
  }
}
