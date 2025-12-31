import 'package:flutter/material.dart';

/// 路由观察者
///
/// 用于监听路由变化，可以用于统计、埋点、日志等
class AppRouteObserver extends NavigatorObserver {
  /// 路由栈变化时的回调
  final ValueChanged<Route<dynamic>>? onRoutePushed;
  final ValueChanged<Route<dynamic>>? onRoutePopped;
  final ValueChanged<Route<dynamic>>? onRouteRemoved;
  final ValueChanged<Route<dynamic>?>? onRouteReplaced;

  /// 路由生命周期回调
  final ValueChanged<String>? onRouteDidPush;
  final ValueChanged<String>? onRouteDidPop;
  final ValueChanged<String>? onRouteDidRemove;
  final ValueChanged<String>? onRouteDidReplace;
  final ValueChanged<Route<dynamic>>? onRouteDidStartUserGesture;
  final ValueChanged<Route<dynamic>>? onRouteDidStopUserGesture;

  AppRouteObserver({
    this.onRoutePushed,
    this.onRoutePopped,
    this.onRouteRemoved,
    this.onRouteReplaced,
    this.onRouteDidPush,
    this.onRouteDidPop,
    this.onRouteDidRemove,
    this.onRouteDidReplace,
    this.onRouteDidStartUserGesture,
    this.onRouteDidStopUserGesture,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = route.settings.name ?? route.toString();

    onRoutePushed?.call(route);
    onRouteDidPush?.call(routeName);

    // 可以在这里添加埋点、统计等逻辑
    _trackRouteChange(routeName, 'push', previousRoute?.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final routeName = route.settings.name ?? route.toString();

    onRoutePopped?.call(route);
    onRouteDidPop?.call(routeName);

    _trackRouteChange(routeName, 'pop', previousRoute?.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final routeName = route.settings.name ?? route.toString();

    onRouteRemoved?.call(route);
    onRouteDidRemove?.call(routeName);

    _trackRouteChange(routeName, 'remove', previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final newRouteName = newRoute?.settings.name ?? newRoute.toString();
    final oldRouteName = oldRoute?.settings.name ?? oldRoute.toString();

    onRouteReplaced?.call(newRoute);
    onRouteDidReplace?.call(newRouteName);

    _trackRouteChange(newRouteName, 'replace', oldRouteName);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    onRouteDidStartUserGesture?.call(route);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    // didStopUserGesture 没有 route 参数，需要通过其他方式获取
  }

  /// 追踪路由变化（可用于埋点、统计等）
  void _trackRouteChange(
    String routeName,
    String action,
    String? previousRouteName,
  ) {
    // 在这里可以实现埋点逻辑
    // 例如：Analytics.track('route_$action', {
    //   'route': routeName,
    //   'previous_route': previousRouteName,
    // });
  }
}

/// 简单的路由观察者实例
///
/// 用于 go_router 的 observers 配置
final routeObserver = AppRouteObserver();
