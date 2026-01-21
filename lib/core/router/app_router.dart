import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_factory.dart';
import 'package:pomelo/services/local_storage.dart';
import 'package:pomelo/views/pages/auth/forgot_password_page.dart';
import 'package:pomelo/views/pages/auth/login_page.dart';
import 'package:pomelo/views/pages/auth/register_page.dart';
import 'package:pomelo/views/pages/auth/splash_page.dart';
import 'package:pomelo/views/pages/auth/verify_page.dart';
import 'package:pomelo/views/pages/auth/web_page.dart';
import 'package:pomelo/views/pages/home/home_page.dart';
import 'package:pomelo/views/pages/profile/profile_page.dart';
import 'package:pomelo/views/pages/tab/tab_page.dart';
import 'route_name.dart';
import 'route_observer.dart';

/// 路由配置
class AppRouter {
  AppRouter._(); // 私有构造函数，防止实例化

  /// GoRouter 实例
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splash,
    debugLogDiagnostics: true,
    observers: [routeObserver],
    routes: [
      // 启动页（无底部导航）
      RF.fade(
        path: RouteName.splash,
        name: 'splash',
        child: const SplashPage(),
      ),

      // 认证相关路由（无底部导航）
      RF.slideBottom(
        path: RouteName.login,
        name: 'login',
        child: const LoginPage(),
      ),
      RF.slideBottom(
        path: RouteName.verificationCodeLogin,
        name: 'verificationCodeLogin',
        child: const VerifyPage(),
      ),
      RF.slideBottom(
        path: RouteName.forgotPassword,
        name: 'forgotPassword',
        child: const ForgotPasswordPage(),
      ),
      RF.slideBottom(
        path: RouteName.register,
        name: 'register',
        child: const RegisterPage(),
      ),

      // Tab页面（主容器）
      RF.fade(
        path: RouteName.tab,
        name: 'tab',
        child: const TabPage(),
      ),

      // WebView 页面
      RF.slideRightBuilder(
        path: RouteName.web,
        name: 'web',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? '';
          final title = state.uri.queryParameters['title'];
          return WebPage(url: url, title: title);
        },
      ),
    ],

    // 路由重定向（用于登录校验）
    redirect: (context, state) {
      final route = state.uri.path;

      // 如果已经在登录页或启动页，不需要重定向
      if (route == RouteName.login || route == RouteName.splash) {
        return null;
      }

      // 检查是否需要登录认证
      final isLoggedIn = LocalStorage.getToken() != null;
      if (RouteName.requiresAuth(route) && !isLoggedIn) {
        // 保存原始路由路径，登录后可以返回
        final redirectUri = state.uri;
        return '${RouteName.login}?redirect=${Uri.encodeComponent(redirectUri.toString())}';
      }

      return null; // 不重定向
    },

    // 错误页面
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '页面未找到: ${state.uri.path}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteName.home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// 占位页面（用于开发阶段的页面占位）
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '页面开发中...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
