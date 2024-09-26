import '../entities/either_of.dart';
import 'value_object.dart';

class TextVO extends ValueObject<String> {
  const TextVO(super.value);

  @override
  EitherOf<String, TextVO> validate([Object? object]) {
    if (value.isEmpty) {
      return reject('$object não pode ser vazio');
    }

    return resolve(this);
  }
}
