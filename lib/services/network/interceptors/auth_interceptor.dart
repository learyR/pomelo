import 'package:dio/dio.dart';
import '../../../services/network/api_define.dart';

/// 认证拦截器 - 自动添加Token
/// 通过ApiDefine.getTokenCallback获取Token，不依赖项目特定的存储
class AuthInterceptor extends Interceptor {
  final String? Function()? getTokenCallback;
  final void Function()? clearTokenCallback;

  AuthInterceptor({
    this.getTokenCallback,
    this.clearTokenCallback,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加Token
    final callback = getTokenCallback ?? ApiDefine.getTokenCallback;
    if (callback != null) {
      final token = callback();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    // 添加通用请求头
    options.headers['Content-Type'] ??= 'application/json';
    options.headers['Accept'] ??= 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Token过期处理
    if (err.response?.statusCode == 401) {
      final callback = clearTokenCallback ?? ApiDefine.clearTokenCallback;
      if (callback != null) {
        callback();
      }
      // 可以在这里触发重新登录逻辑
      // 例如：通过EventBus或Provider通知应用
    }

    super.onError(err, handler);
  }
}

