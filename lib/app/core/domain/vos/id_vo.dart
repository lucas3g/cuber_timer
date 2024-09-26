import '../entities/either_of.dart';
import 'value_object.dart';

class IdVO extends ValueObject<int> {
  const IdVO(super.value);

  @override
  EitherOf<String, IdVO> validate([Object? object]) {
    if (value < -1) {
      return reject('$runtimeType não pode ser menor que menos 1 (-1)');
    }
    return resolve(this);
  }
}
