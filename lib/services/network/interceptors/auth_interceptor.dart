import 'package:dio/dio.dart';
import '../../../services/network/api_define.dart';

/// 全局登录过期通知回调（由应用层设置）
/// 使用dynamic避免依赖Flutter UI层
void Function(dynamic)? _globalLoginExpiredCallback;

/// 设置全局登录过期通知回调
void setGlobalLoginExpiredCallback(void Function(dynamic)? callback) {
  _globalLoginExpiredCallback = callback;
}

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
      final clearCallback = clearTokenCallback ?? ApiDefine.clearTokenCallback;
      if (clearCallback != null) {
        clearCallback();
      }
      // 通知登录过期（通过全局回调）
      final expiredCallback = _globalLoginExpiredCallback;
      if (expiredCallback != null) {
        // 延迟执行通知，避免在拦截器中直接调用UI
        Future.microtask(() {
          // 获取当前上下文（需要通过NavigatorKey或其他方式）
          // 这里暂时不传递context，由回调函数自己获取
          expiredCallback(null);
        });
      }
    }

    super.onError(err, handler);
  }

}

