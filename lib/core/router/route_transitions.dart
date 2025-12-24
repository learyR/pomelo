import 'package:flutter/material.dart';

/// 页面转场动画类型
enum RouteTransitionType {
  /// 无动画
  none,
  /// 淡入淡出
  fade,
  /// 从右侧滑入
  slideRight,
  /// 从左侧滑入
  slideLeft,
  /// 从底部滑入
  slideBottom,
  /// 从顶部滑入
  slideTop,
  /// 缩放
  scale,
  /// 旋转
  rotation,
  /// 组合动画（缩放+淡入）
  scaleFade,
}

/// 页面转场动画工具类
class RouteTransitions {
  RouteTransitions._();

  /// 创建自定义页面转场动画
  static Page<T> buildPage<T extends Object?>({
    required Widget child,
    RouteTransitionType transitionType = RouteTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionType: transitionType,
      duration: duration,
      curve: curve,
    );
  }

  /// 淡入淡出动画
  static Page<T> fade<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.fade,
      duration: duration,
    );
  }

  /// 从右侧滑入动画
  static Page<T> slideRight<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.slideRight,
      duration: duration,
    );
  }

  /// 从左侧滑入动画
  static Page<T> slideLeft<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.slideLeft,
      duration: duration,
    );
  }

  /// 从底部滑入动画
  static Page<T> slideBottom<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.slideBottom,
      duration: duration,
    );
  }

  /// 从顶部滑入动画
  static Page<T> slideTop<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.slideTop,
      duration: duration,
    );
  }

  /// 缩放动画
  static Page<T> scale<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.scale,
      duration: duration,
    );
  }

  /// 缩放+淡入动画
  static Page<T> scaleFade<T extends Object?>(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildPage<T>(
      child: child,
      transitionType: RouteTransitionType.scaleFade,
      duration: duration,
    );
  }
}

/// 自定义转场页面
class CustomTransitionPage<T extends Object?> extends Page<T> {
  final Widget child;
  final RouteTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  const CustomTransitionPage({
    required this.child,
    this.transitionType = RouteTransitionType.slideRight,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return _CustomPageRoute<T>(
      page: this,
      transitionType: transitionType,
      duration: duration,
      curve: curve,
    );
  }
}

/// 自定义页面路由
class _CustomPageRoute<T extends Object?> extends PageRoute<T> {
  final CustomTransitionPage<T> page;
  final RouteTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  _CustomPageRoute({
    required this.page,
    required this.transitionType,
    required this.duration,
    required this.curve,
  }) : super(settings: page);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page.child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (transitionType == RouteTransitionType.none) {
      return child;
    }

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (transitionType) {
      case RouteTransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case RouteTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransitionType.slideBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransitionType.slideTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case RouteTransitionType.scale:
        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );

      case RouteTransitionType.rotation:
        return RotationTransition(
          turns: curvedAnimation,
          child: child,
        );

      case RouteTransitionType.scaleFade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: child,
          ),
        );

      case RouteTransitionType.none:
        return child;
    }
  }
}

