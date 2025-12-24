import 'package:dio/dio.dart';
import '../../../services/network/api_define.dart';

/// 日志拦截器 - 记录请求和响应日志
/// 通过ApiDefine.logCallback输出日志，不依赖项目特定的日志工具
class LoggingInterceptor extends Interceptor {
  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;
  final bool error;
  final void Function(String level, String message)? logCallback;

  LoggingInterceptor({
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.logCallback,
  });

  void _log(String level, String message) {
    final callback = logCallback ?? ApiDefine.logCallback;
    if (callback != null) {
      callback(level, message);
    } else {
      // 如果没有配置日志回调，使用print作为fallback
      print('[$level] $message');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('debug', '┌─────────────────────────────────────────────────');
    _log('debug', '│ 请求: ${options.method} ${options.uri}');

    if (requestHeader && options.headers.isNotEmpty) {
      _log('debug', '│ 请求头: ${options.headers}');
    }

    if (requestBody && options.data != null) {
      _log('debug', '│ 请求体: ${options.data}');
    }

    if (options.queryParameters.isNotEmpty) {
      _log('debug', '│ 查询参数: ${options.queryParameters}');
    }

    _log('debug', '└─────────────────────────────────────────────────');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log('debug', '┌─────────────────────────────────────────────────');
    _log('debug', '│ 响应: ${response.requestOptions.method} ${response.requestOptions.uri}');
    _log('debug', '│ 状态码: ${response.statusCode}');

    if (responseHeader && response.headers.map.isNotEmpty) {
      _log('debug', '│ 响应头: ${response.headers.map}');
    }

    if (responseBody) {
      _log('debug', '│ 响应体: ${response.data}');
    }

    _log('debug', '└─────────────────────────────────────────────────');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      _log('error', '┌─────────────────────────────────────────────────');
      _log('error', '│ 错误: ${err.requestOptions.method} ${err.requestOptions.uri}');
      _log('error', '│ 错误类型: ${err.type}');
      _log('error', '│ 错误信息: ${err.message}');

      if (err.response != null) {
        _log('error', '│ 状态码: ${err.response?.statusCode}');
        _log('error', '│ 响应数据: ${err.response?.data}');
      }

      _log('error', '└─────────────────────────────────────────────────');
    }

    super.onError(err, handler);
  }
}

