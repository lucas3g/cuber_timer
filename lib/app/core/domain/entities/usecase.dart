import 'either_of.dart';
import 'failure.dart';

abstract class UseCase<ReturnType, Args> {
  Future<EitherOf<AppFailure, ReturnType>> call(Args args);
}

abstract class StreamUsecase<ReturnType, Args> {
  Stream<EitherOf<AppFailure, ReturnType>> call(Args args);
}

class NoArgs {
  const NoArgs();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoArgs && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
