class ApiResponse<T> {
  final String? message;
  final T? data;

  ApiResponse({
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse<T>(
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}
