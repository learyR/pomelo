import 'package:flutter/material.dart';

/// 通用卡片组件
/// 
/// 提供统一的卡片样式，支持点击、阴影、圆角等配置
class AppCard extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 点击回调
  final VoidCallback? onTap;

  /// 长按回调
  final VoidCallback? onLongPress;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 背景颜色
  final Color? color;

  /// 阴影高度
  final double? elevation;

  /// 圆角半径
  final double? borderRadius;

  /// 边框颜色
  final Color? borderColor;

  /// 边框宽度
  final double borderWidth;

  /// 高度
  final double? height;

  /// 宽度
  final double? width;

  /// 形状
  final ShapeBorder? shape;

  /// 是否裁剪内容
  final bool clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 0,
    this.height,
    this.width,
    this.shape,
    this.clipBehavior = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;

    Widget cardContent = Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation!),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// 带标题的卡片组件
class AppCardWithTitle extends StatelessWidget {
  /// 标题
  final String title;

  /// 子组件
  final Widget child;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 标题右侧组件
  final Widget? titleTrailing;

  /// 点击回调
  final VoidCallback? onTap;

  /// 标题点击回调
  final VoidCallback? onTitleTap;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 背景颜色
  final Color? color;

  /// 阴影高度
  final double? elevation;

  /// 圆角半径
  final double? borderRadius;

  /// 标题间距
  final double titleSpacing;

  const AppCardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.titleTrailing,
    this.onTap,
    this.onTitleTap,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.titleSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      color: color,
      elevation: elevation,
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTitleTap ?? onTap,
                child: Text(
                  title,
                  style: titleStyle ??
                      theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (titleTrailing != null) titleTrailing!,
            ],
          ),
          SizedBox(height: titleSpacing),
          child,
        ],
      ),
    );
  }
}

