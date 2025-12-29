class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? code;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });
}
