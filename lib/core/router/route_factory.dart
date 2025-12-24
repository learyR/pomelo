import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_name.dart';
import 'route_transitions.dart';
import '../../services/local_storage.dart';

/// 路由配置选项
class RouteConfig {
  /// 路由路径
  final String path;

  /// 路由名称
  final String name;

  /// 页面构建器
  final Widget Function(BuildContext, GoRouterState) builder;

  /// 是否需要认证
  final bool requiresAuth;

  /// 转场动画类型
  final RouteTransitionType transitionType;

  /// 转场动画时长
  final Duration transitionDuration;

  /// 自定义页面构建器（返回 Page 对象）
  final Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder;

  const RouteConfig({
    required this.path,
    required this.name,
    required this.builder,
    this.requiresAuth = false,
    this.transitionType = RouteTransitionType.slideRight,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.pageBuilder,
  });
}

/// 路由工厂类
/// 
/// 用于简化路由创建和统一处理路由认证
class RouteFactory {
  RouteFactory._(); // 私有构造函数，防止实例化

  /// 检查用户是否已登录
  static bool _isAuthenticated() {
    // 检查本地存储中是否有 token
    final token = LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// 创建需要认证的路由
  /// 
  /// 如果用户未登录，会自动重定向到登录页
  static GoRoute authenticated({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
  }) {
    return _createRoute(
      config: RouteConfig(
        path: path,
        name: name,
        builder: builder,
        requiresAuth: true,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        pageBuilder: pageBuilder,
      ),
    );
  }

  /// 创建公开路由（无需认证）
  static GoRoute public({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
  }) {
    return _createRoute(
      config: RouteConfig(
        path: path,
        name: name,
        builder: builder,
        requiresAuth: false,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        pageBuilder: pageBuilder,
      ),
    );
  }

  /// 从 RouteConfig 创建路由
  static GoRoute _createRoute({required RouteConfig config}) {
    return GoRoute(
      path: config.path,
      name: config.name,
      pageBuilder: config.pageBuilder ??
          (context, state) {
            return RouteTransitions.buildPage(
              child: config.builder(context, state),
              transitionType: config.transitionType,
              duration: config.transitionDuration,
            );
          },
      redirect: (context, state) {
        // 如果路由需要认证且用户未登录，重定向到登录页
        if (config.requiresAuth && !_isAuthenticated()) {
          // 保存原始路由路径，登录后可以返回
          return '${RouteName.login}?redirect=${Uri.encodeComponent(state.uri.path)}';
        }
        return null; // 不重定向
      },
    );
  }

  /// 创建带参数的路由
  static GoRoute withParams({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    bool requiresAuth = false,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) {
        return RouteTransitions.buildPage(
          child: builder(context, state),
          transitionType: transitionType,
          duration: transitionDuration,
        );
      },
      redirect: (context, state) {
        if (requiresAuth && !_isAuthenticated()) {
          return '${RouteName.login}?redirect=${Uri.encodeComponent(state.uri.path)}';
        }
        return null;
      },
    );
  }

  /// 创建 ShellRoute（用于底部导航栏等容器）
  static ShellRoute shell({
    required Widget Function(BuildContext, GoRouterState, Widget) builder,
    required List<RouteBase> routes,
  }) {
    return ShellRoute(
      builder: builder,
      routes: routes,
    );
  }

  /// 创建路由组（批量创建路由）
  static List<RouteBase> group({
    required List<RouteConfig> configs,
  }) {
    return configs.map((config) => _createRoute(config: config)).toList();
  }

  /// 批量创建公开路由
  /// 
  /// 使用 RouteConfig 列表批量创建路由
  static List<RouteBase> publicGroup({
    required List<RouteConfig> configs,
  }) {
    return configs.map((config) {
      return public(
        path: config.path,
        name: config.name,
        builder: config.builder,
        transitionType: config.transitionType,
        transitionDuration: config.transitionDuration,
        pageBuilder: config.pageBuilder,
      );
    }).toList();
  }

  /// 批量创建需要认证的路由
  /// 
  /// 使用 RouteConfig 列表批量创建路由
  static List<RouteBase> authenticatedGroup({
    required List<RouteConfig> configs,
  }) {
    return configs.map((config) {
      return authenticated(
        path: config.path,
        name: config.name,
        builder: config.builder,
        transitionType: config.transitionType,
        transitionDuration: config.transitionDuration,
        pageBuilder: config.pageBuilder,
      );
    }).toList();
  }
}

/// 路由认证守卫
/// 
/// 用于在路由跳转前进行认证检查
class RouteAuthGuard {
  RouteAuthGuard._();

  /// 检查路由是否需要认证
  static bool requiresAuth(String route) {
    return RouteName.requiresAuth(route);
  }

  /// 检查用户是否已认证
  static bool isAuthenticated() {
    return RouteFactory._isAuthenticated();
  }

  /// 获取登录后应该跳转的路由
  /// 
  /// 从 URL 参数中获取 redirect 参数，如果不存在则返回默认路由
  static String? getRedirectRoute(GoRouterState state) {
    final redirect = state.uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      return Uri.decodeComponent(redirect);
    }
    return null;
  }

  /// 检查并处理认证
  /// 
  /// 如果需要认证且用户未登录，返回登录页路径
  /// 否则返回 null（不重定向）
  static String? checkAuth(String route) {
    if (requiresAuth(route) && !isAuthenticated()) {
      return '${RouteName.login}?redirect=${Uri.encodeComponent(route)}';
    }
    return null;
  }
}

