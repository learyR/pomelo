import 'package:dio/dio.dart';

/// API异常基类
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// 网络连接异常
class ApiConnectionException extends ApiException {
  const ApiConnectionException({
    String message = '网络连接失败，请检查网络设置',
    super.originalError,
  }) : super(message: message);
}

/// 网络超时异常
class ApiTimeoutException extends ApiException {
  const ApiTimeoutException({
    String message = '请求超时，请稍后重试',
    super.originalError,
  }) : super(message: message);
}

/// 服务器异常
class ApiServerException extends ApiException {
  const ApiServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// 认证异常（401）
class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException({
    String message = '登录已过期，请重新登录',
    super.statusCode = 401,
    super.originalError,
  }) : super(message: message);
}

/// 禁止访问异常（403）
class ApiForbiddenException extends ApiException {
  const ApiForbiddenException({
    String message = '无权访问该资源',
    super.statusCode = 403,
    super.originalError,
  }) : super(message: message);
}

/// 资源不存在异常（404）
class ApiNotFoundException extends ApiException {
  const ApiNotFoundException({
    String message = '请求的资源不存在',
    super.statusCode = 404,
    super.originalError,
  }) : super(message: message);
}

/// 请求参数异常（400）
class ApiBadRequestException extends ApiException {
  const ApiBadRequestException({
    String message = '请求参数错误',
    super.statusCode = 400,
    super.originalError,
  }) : super(message: message);
}

/// 服务器内部错误（500）
class ApiInternalServerException extends ApiException {
  const ApiInternalServerException({
    String message = '服务器内部错误，请稍后重试',
    super.statusCode = 500,
    super.originalError,
  }) : super(message: message);
}

/// 未知异常
class ApiUnknownException extends ApiException {
  const ApiUnknownException({
    String message = '未知错误，请稍后重试',
    super.originalError,
  }) : super(message: message);
}

/// API异常工厂类
class ApiExceptionFactory {
  /// 从DioException创建API异常
  static ApiException fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiTimeoutException(originalError: error);

      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return ApiConnectionException(originalError: error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);

        switch (statusCode) {
          case 400:
            return ApiBadRequestException(
              message: message ?? '请求参数错误',
              originalError: error,
            );
          case 401:
            return ApiUnauthorizedException(
              message: message ?? '登录已过期，请重新登录',
              originalError: error,
            );
          case 403:
            return ApiForbiddenException(
              message: message ?? '无权访问该资源',
              originalError: error,
            );
          case 404:
            return ApiNotFoundException(
              message: message ?? '请求的资源不存在',
              originalError: error,
            );
          case 500:
          case 502:
          case 503:
            return ApiInternalServerException(
              message: message ?? '服务器错误，请稍后重试',
              originalError: error,
            );
          default:
            return ApiServerException(
              message: message ?? '服务器错误，请稍后重试',
              statusCode: statusCode,
              originalError: error,
            );
        }

      case DioExceptionType.cancel:
        return ApiUnknownException(
          message: '请求已取消',
          originalError: error,
        );

      default:
        return ApiUnknownException(originalError: error);
    }
  }

  /// 提取错误消息
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // 优先使用message字段
      if (data['message'] != null) {
        return data['message'].toString();
      }
      // 其次使用error字段
      if (data['error'] != null) {
        return data['error'].toString();
      }
      // 再次使用msg字段
      if (data['msg'] != null) {
        return data['msg'].toString();
      }
    }

    if (data is String) {
      return data;
    }

    return null;
  }

  /// 从通用异常创建API异常
  static ApiException fromException(Exception exception) {
    if (exception is ApiException) {
      return exception;
    }

    if (exception is DioException) {
      return fromDioException(exception);
    }

    return ApiUnknownException(
      message: exception.toString(),
      originalError: exception,
    );
  }
}

