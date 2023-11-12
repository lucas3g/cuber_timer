abstract class IMyException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const IMyException({
    required this.message,
    this.stackTrace,
  });
}

class MyException extends IMyException {
  const MyException({required String message, StackTrace? stackTrace})
      : super(message: message, stackTrace: stackTrace);
}
