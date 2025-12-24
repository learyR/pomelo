import 'package:flutter/material.dart';

/// 通用图标按钮组件
/// 
/// 提供统一的图标按钮样式
class AppIconButton extends StatelessWidget {
  /// 图标
  final IconData icon;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 尺寸
  final AppIconButtonSize size;

  /// 背景颜色
  final Color? backgroundColor;

  /// 图标颜色
  final Color? iconColor;

  /// 边框颜色
  final Color? borderColor;

  /// 是否显示边框
  final bool showBorder;

  /// 形状
  final BoxShape shape;

  /// 圆角半径（shape 为 BoxShape.rectangle 时有效）
  final double? borderRadius;

  /// 工具提示文本
  final String? tooltip;

  /// 是否启用
  final bool enabled;

  /// 是否显示加载状态
  final bool isLoading;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppIconButtonSize.medium,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.showBorder = false,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.tooltip,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDisabled = !enabled || onPressed == null || isLoading;
    final sizeConfig = _getSizeConfig(size);

    Widget button = Container(
      width: sizeConfig.size,
      height: sizeConfig.size,
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey.shade200
            : (backgroundColor ?? Colors.transparent),
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius ?? 8)
            : null,
        border: showBorder
            ? Border.all(
                color: isDisabled
                    ? Colors.grey.shade300
                    : (borderColor ?? colorScheme.outline),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius ?? 8)
              : BorderRadius.circular(sizeConfig.size / 2),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: sizeConfig.iconSize,
                    height: sizeConfig.iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDisabled
                            ? Colors.grey.shade600
                            : (iconColor ?? colorScheme.onSurface),
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    size: sizeConfig.iconSize,
                    color: isDisabled
                        ? Colors.grey.shade600
                        : (iconColor ?? colorScheme.onSurface),
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null && !isDisabled) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  _IconButtonSizeConfig _getSizeConfig(AppIconButtonSize size) {
    switch (size) {
      case AppIconButtonSize.small:
        return _IconButtonSizeConfig(
          size: 32,
          iconSize: 18,
        );
      case AppIconButtonSize.medium:
        return _IconButtonSizeConfig(
          size: 40,
          iconSize: 24,
        );
      case AppIconButtonSize.large:
        return _IconButtonSizeConfig(
          size: 48,
          iconSize: 28,
        );
    }
  }
}

/// 图标按钮尺寸
enum AppIconButtonSize {
  /// 小号（32x32）
  small,
  /// 中号（40x40）
  medium,
  /// 大号（48x48）
  large,
}

class _IconButtonSizeConfig {
  final double size;
  final double iconSize;

  _IconButtonSizeConfig({
    required this.size,
    required this.iconSize,
  });
}

