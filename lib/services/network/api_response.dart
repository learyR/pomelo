/// API统一响应模型
class ApiResponse<T> {
  /// 响应码
  final int code;

  /// 响应消息
  final String message;

  /// 响应数据
  final T? data;

  /// 时间戳
  final int? timestamp;

  /// 是否成功
  bool get isSuccess => code == 200 || code == 1;

  /// 是否失败
  bool get isFailure => !isSuccess;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.timestamp,
  });

  /// 从JSON创建ApiResponse
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? json['statusCode'] ?? 0,
      message: json['message'] ?? json['msg'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      timestamp: json['timestamp'] ?? json['time'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      if (timestamp != null) 'timestamp': timestamp,
    };
  }

  /// 创建成功响应
  factory ApiResponse.success(T data, {String? message, int? timestamp}) {
    return ApiResponse<T>(
      code: 200,
      message: message ?? '操作成功',
      data: data,
      timestamp: timestamp,
    );
  }

  /// 创建失败响应
  factory ApiResponse.failure(String message, {int code = -1, int? timestamp}) {
    return ApiResponse<T>(
      code: code,
      message: message,
      data: null,
      timestamp: timestamp,
    );
  }

  /// 复制并修改
  ApiResponse<T> copyWith({
    int? code,
    String? message,
    T? data,
    int? timestamp,
  }) {
    return ApiResponse<T>(
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(code: $code, message: $message, data: $data)';
  }
}

