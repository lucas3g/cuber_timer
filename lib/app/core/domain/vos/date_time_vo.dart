import '../entities/either_of.dart';
import 'value_object.dart';

class DateTimeVO extends ValueObject<DateTime> {
  const DateTimeVO(super.value);

  bool isDateValid(DateTime date) {
    final DateTime? validateDate = DateTime.tryParse(date.toString());

    return validateDate != null;
  }

  @override
  EitherOf<String, DateTimeVO> validate([Object? object]) {
    if (!isDateValid(value)) {
      return reject('$object em branco ou inválida');
    }
    return resolve(this);
  }
}
