import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_transitions.dart';

/// 路由构建器类
///
/// 提供简化的路由创建方法，统一管理路由配置
/// 自动处理 key 和 name 的设置，简化路由配置代码
class RF {
  RF._();

  /// 创建简单的路由（无动画）
  ///
  /// [path] 路由路径
  /// [name] 路由名称
  /// [builder] 页面构建器
  static GoRoute route({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      name: name,
      builder: builder,
    );
  }

  /// 创建带转场动画的路由
  ///
  /// [path] 路由路径
  /// [name] 路由名称
  /// [child] 页面组件
  /// [transitionType] 转场动画类型，默认为从右侧滑入
  /// [duration] 动画时长
  static GoRoute routeWithTransition({
    required String path,
    required String name,
    required Widget child,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration? duration,
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) {
        return RouteTransitions.buildPage(
          key: ValueKey(state.uri.toString()),
          name: state.name,
          child: child,
          transitionType: transitionType,
          duration: duration ?? const Duration(milliseconds: 300),
        );
      },
    );
  }

  /// 创建带转场动画的路由（支持动态构建页面）
  ///
  /// [path] 路由路径
  /// [name] 路由名称
  /// [builder] 页面构建器
  /// [transitionType] 转场动画类型，默认为从右侧滑入
  /// [duration] 动画时长
  static GoRoute routeWithTransitionBuilder({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration? duration,
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) {
        final child = builder(context, state);
        return RouteTransitions.buildPage(
          key: ValueKey(state.uri.toString()),
          name: state.name,
          child: child,
          transitionType: transitionType,
          duration: duration ?? const Duration(milliseconds: 300),
        );
      },
    );
  }

  /// 创建淡入淡出动画路由
  static GoRoute fade({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.fade,
      duration: duration,
    );
  }

  /// 创建从右侧滑入动画路由
  static GoRoute slideRight({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.slideRight,
      duration: duration,
    );
  }

  /// 创建从左侧滑入动画路由
  static GoRoute slideLeft({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.slideLeft,
      duration: duration,
    );
  }

  /// 创建从底部滑入动画路由
  static GoRoute slideBottom({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.slideBottom,
      duration: duration,
    );
  }

  /// 创建从顶部滑入动画路由
  static GoRoute slideTop({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.slideTop,
      duration: duration,
    );
  }

  /// 创建缩放动画路由
  static GoRoute scale({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.scale,
      duration: duration,
    );
  }

  /// 创建缩放+淡入动画路由
  static GoRoute scaleFade({
    required String path,
    required String name,
    required Widget child,
    Duration? duration,
  }) {
    return routeWithTransition(
      path: path,
      name: name,
      child: child,
      transitionType: RouteTransitionType.scaleFade,
      duration: duration,
    );
  }

  /// 创建淡入淡出动画路由（支持动态构建页面）
  static GoRoute fadeBuilder({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration? duration,
  }) {
    return routeWithTransitionBuilder(
      path: path,
      name: name,
      builder: builder,
      transitionType: RouteTransitionType.fade,
      duration: duration,
    );
  }

  /// 创建从右侧滑入动画路由（支持动态构建页面）
  static GoRoute slideRightBuilder({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration? duration,
  }) {
    return routeWithTransitionBuilder(
      path: path,
      name: name,
      builder: builder,
      transitionType: RouteTransitionType.slideRight,
      duration: duration,
    );
  }

  /// 创建从底部滑入动画路由（支持动态构建页面）
  static GoRoute slideBottomBuilder({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration? duration,
  }) {
    return routeWithTransitionBuilder(
      path: path,
      name: name,
      builder: builder,
      transitionType: RouteTransitionType.slideBottom,
      duration: duration,
    );
  }
}
