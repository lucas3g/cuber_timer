A id<A>(A a) => a;

class VoidSuccess {
  const VoidSuccess();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoidSuccess && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

const VoidSuccess voidSuccess = VoidSuccess();

abstract class EitherOf<Failure, Success> {
  bool get isLeft => this is Reject<Failure, Success>;
  bool get isRight => this is Resolve<Failure, Success>;

  const EitherOf();

  T get<T>(
    T Function(Failure reject) ifReject,
    T Function(Success resolve) ifResolve,
  );

  Success getOrElse(Success Function() orElse) => get((_) => orElse(), id);

  String? exceptionOrNull() =>
      get((failure) => failure.toString(), (_) => null);
}

class Reject<Failure, Success> extends EitherOf<Failure, Success> {
  final Failure _failure;
  const Reject(this._failure);

  @override
  T get<T>(
    T Function(Failure reject) ifReject,
    T Function(Success resolve) ifResolve,
  ) =>
      ifReject(_failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reject<Failure, Success> && _failure == other._failure;

  @override
  int get hashCode => _failure.hashCode;
}

class Resolve<Failure, Success> extends EitherOf<Failure, Success> {
  final Success _success;
  const Resolve(this._success);

  @override
  T get<T>(
    T Function(Failure reject) ifReject,
    T Function(Success resolve) ifResolve,
  ) =>
      ifResolve(_success);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resolve<Failure, Success> && _success == other._success;

  @override
  int get hashCode => _success.hashCode;
}

EitherOf<Failure, Success> reject<Failure, Success>(Failure reject) =>
    Reject<Failure, Success>(reject);
EitherOf<Failure, Success> resolve<Failure, Success>(Success resolve) =>
    Resolve<Failure, Success>(resolve);
