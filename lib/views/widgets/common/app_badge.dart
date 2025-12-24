import 'package:flutter/material.dart';

/// 通用徽章组件
/// 
/// 用于显示数字、状态等标识
class AppBadge extends StatelessWidget {
  /// 显示的内容（数字或文本）
  final String text;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文字颜色
  final Color? textColor;

  /// 尺寸
  final AppBadgeSize size;

  /// 是否显示为圆点（无文字）
  final bool isDot;

  /// 最大显示数字（超过显示 99+）
  final int maxCount;

  /// 位置偏移
  final Offset? offset;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.size = AppBadgeSize.medium,
    this.isDot = false,
    this.maxCount = 99,
    this.offset,
  });

  /// 从数字创建徽章
  factory AppBadge.count({
    Key? key,
    required int count,
    Color? backgroundColor,
    Color? textColor,
    AppBadgeSize size = AppBadgeSize.medium,
    int maxCount = 99,
    Offset? offset,
  }) {
    String displayText = count > maxCount ? '$maxCount+' : count.toString();
    return AppBadge(
      key: key,
      text: displayText,
      backgroundColor: backgroundColor,
      textColor: textColor,
      size: size,
      maxCount: maxCount,
      offset: offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isDot) {
      return Container(
        width: _getSize(size).dotSize,
        height: _getSize(size).dotSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? colorScheme.error,
          shape: BoxShape.circle,
        ),
        margin: EdgeInsets.only(
          left: offset?.dx ?? 0,
          top: offset?.dy ?? 0,
        ),
      );
    }

    final sizeConfig = _getSize(size);
    final displayText = text;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.paddingHorizontal,
        vertical: sizeConfig.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.error,
        borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
      ),
      constraints: BoxConstraints(
        minWidth: sizeConfig.minWidth,
        minHeight: sizeConfig.minHeight,
      ),
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: offset?.dx ?? 0,
        top: offset?.dy ?? 0,
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: sizeConfig.fontSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _BadgeSizeConfig _getSize(AppBadgeSize size) {
    switch (size) {
      case AppBadgeSize.small:
        return _BadgeSizeConfig(
          fontSize: 10,
          paddingHorizontal: 4,
          paddingVertical: 2,
          minWidth: 16,
          minHeight: 16,
          borderRadius: 8,
          dotSize: 8,
        );
      case AppBadgeSize.medium:
        return _BadgeSizeConfig(
          fontSize: 12,
          paddingHorizontal: 6,
          paddingVertical: 3,
          minWidth: 20,
          minHeight: 20,
          borderRadius: 10,
          dotSize: 10,
        );
      case AppBadgeSize.large:
        return _BadgeSizeConfig(
          fontSize: 14,
          paddingHorizontal: 8,
          paddingVertical: 4,
          minWidth: 24,
          minHeight: 24,
          borderRadius: 12,
          dotSize: 12,
        );
    }
  }
}

/// 徽章尺寸
enum AppBadgeSize {
  /// 小号
  small,
  /// 中号
  medium,
  /// 大号
  large,
}

class _BadgeSizeConfig {
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final double minWidth;
  final double minHeight;
  final double borderRadius;
  final double dotSize;

  _BadgeSizeConfig({
    required this.fontSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.minWidth,
    required this.minHeight,
    required this.borderRadius,
    required this.dotSize,
  });
}

/// 通用标签组件
/// 
/// 用于显示标签、分类等信息
class AppTag extends StatelessWidget {
  /// 标签文本
  final String text;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文字颜色
  final Color? textColor;

  /// 边框颜色
  final Color? borderColor;

  /// 尺寸
  final AppTagSize size;

  /// 形状
  final AppTagShape shape;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否选中
  final bool selected;

  /// 选中时的背景颜色
  final Color? selectedBackgroundColor;

  /// 选中时的文字颜色
  final Color? selectedTextColor;

  /// 前置图标
  final IconData? icon;

  const AppTag({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.size = AppTagSize.medium,
    this.shape = AppTagShape.rounded,
    this.onTap,
    this.selected = false,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sizeConfig = _getSize(size);
    final bgColor = selected
        ? (selectedBackgroundColor ?? colorScheme.primary)
        : (backgroundColor ?? colorScheme.primaryContainer);
    final txtColor = selected
        ? (selectedTextColor ?? Colors.white)
        : (textColor ?? colorScheme.onPrimaryContainer);
    final border = borderColor ?? (selected ? bgColor : Colors.transparent);

    Widget tagContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.paddingHorizontal,
        vertical: sizeConfig.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          shape == AppTagShape.rounded
              ? sizeConfig.borderRadius
              : (shape == AppTagShape.square ? 4 : sizeConfig.paddingVertical),
        ),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: sizeConfig.iconSize,
              color: txtColor,
            ),
            SizedBox(width: sizeConfig.spacing),
          ],
          Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontSize: sizeConfig.fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          shape == AppTagShape.rounded
              ? sizeConfig.borderRadius
              : (shape == AppTagShape.square ? 4 : sizeConfig.paddingVertical),
        ),
        child: tagContent,
      );
    }

    return tagContent;
  }

  _TagSizeConfig _getSize(AppTagSize size) {
    switch (size) {
      case AppTagSize.small:
        return _TagSizeConfig(
          fontSize: 12,
          paddingHorizontal: 8,
          paddingVertical: 4,
          borderRadius: 12,
          iconSize: 14,
          spacing: 4,
        );
      case AppTagSize.medium:
        return _TagSizeConfig(
          fontSize: 14,
          paddingHorizontal: 12,
          paddingVertical: 6,
          borderRadius: 16,
          iconSize: 16,
          spacing: 6,
        );
      case AppTagSize.large:
        return _TagSizeConfig(
          fontSize: 16,
          paddingHorizontal: 16,
          paddingVertical: 8,
          borderRadius: 20,
          iconSize: 18,
          spacing: 8,
        );
    }
  }
}

/// 标签尺寸
enum AppTagSize {
  /// 小号
  small,
  /// 中号
  medium,
  /// 大号
  large,
}

/// 标签形状
enum AppTagShape {
  /// 圆角
  rounded,
  /// 方形
  square,
  /// 胶囊
  capsule,
}

class _TagSizeConfig {
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final double borderRadius;
  final double iconSize;
  final double spacing;

  _TagSizeConfig({
    required this.fontSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.borderRadius,
    required this.iconSize,
    required this.spacing,
  });
}

