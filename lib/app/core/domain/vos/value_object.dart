import '../entities/either_of.dart';

abstract class ValueObject<T> {
  final T value;

  const ValueObject(this.value);

  EitherOf<String, ValueObject<T>> validate([Object? object]);

  @override
  bool operator ==(covariant ValueObject<T> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return '$runtimeType: $value';
  }
}
