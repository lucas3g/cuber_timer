import '../entities/either_of.dart';
import 'value_object.dart';

class PasswordVO extends ValueObject<String> {
  const PasswordVO(super.value);

  @override
  EitherOf<String, PasswordVO> validate([Object? object]) {
    if (value.isEmpty) {
      return reject('$object não pode ser vazio');
    }

    return resolve(this);
  }
}
