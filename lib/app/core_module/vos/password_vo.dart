import 'package:result_dart/result_dart.dart';

import 'value_object.dart';

class PasswordVO extends ValueObject<String> {
  const PasswordVO(super.value);

  @override
  Result<PasswordVO, String> validate([Object? object]) {
    if (value.isEmpty) {
      return '$object não pode ser vazio'.toFailure();
    }

    if (value.length < 6) {
      return '$object deve conter pelo menos 6 caracteres'.toFailure();
    }

    return Success(this);
  }
}
