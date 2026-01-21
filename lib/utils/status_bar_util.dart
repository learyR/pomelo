import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 状态栏工具类
/// 
/// 提供统一的状态栏样式管理和便捷的配置方法
class StatusBarUtil {
  StatusBarUtil._();

  /// 默认状态栏样式（深色图标，适用于浅色背景）
  static const SystemUiOverlayStyle defaultStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// 浅色状态栏样式（浅色图标，适用于深色背景）
  static const SystemUiOverlayStyle lightStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// 设置全局默认状态栏样式
  static void setDefaultStyle() {
    SystemChrome.setSystemUIOverlayStyle(defaultStyle);
  }

  /// 设置浅色状态栏样式
  static void setLightStyle() {
    SystemChrome.setSystemUIOverlayStyle(lightStyle);
  }

  /// 根据背景亮度自动设置状态栏样式
  static void setStyleByBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setLightStyle();
    } else {
      setDefaultStyle();
    }
  }
}

/// 状态栏包装器 Widget
/// 
/// 用于在页面级别设置状态栏样式，使用 AnnotatedRegion 实现
/// 这样可以在页面切换时自动恢复默认样式
class StatusBarWrapper extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 状态栏样式
  final SystemUiOverlayStyle? style;

  /// 是否使用浅色图标（适用于深色背景）
  final bool lightIcons;

  const StatusBarWrapper({
    super.key,
    required this.child,
    this.style,
    this.lightIcons = false,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = style ??
        (lightIcons ? StatusBarUtil.lightStyle : StatusBarUtil.defaultStyle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }
}
