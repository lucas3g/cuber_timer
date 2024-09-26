class HttpResponseEntity<T> {
  final int statusCode;
  final T? data;

  HttpResponseEntity({required this.statusCode, this.data});
}
