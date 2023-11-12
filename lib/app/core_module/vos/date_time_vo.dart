// ignore_for_file: unused_local_variable

import 'package:cuber_timer/app/core_module/vos/value_object.dart';
import 'package:result_dart/result_dart.dart';

class DateTimeVO extends ValueObject<DateTime> {
  const DateTimeVO(super.value);

  bool isDateValid(DateTime date) {
    DateTime? validateDate = DateTime.tryParse(date.toString());

    return validateDate != null;
  }

  @override
  Result<DateTimeVO, String> validate([Object? object]) {
    if (!isDateValid(value)) {
      return '$object em branco ou inválida'.toFailure();
    }
    return Success(this);
  }
}
