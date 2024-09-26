import 'failure.dart';

class NetworkFailure extends AppFailure {
  NetworkFailure(String message) : super(message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NetworkFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
