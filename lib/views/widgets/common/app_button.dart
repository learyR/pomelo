import 'package:flutter/material.dart';

/// 通用按钮组件
/// 
/// 支持多种样式：primary、secondary、outline、text、danger
/// 可自定义尺寸、图标、加载状态等
class AppButton extends StatelessWidget {
  /// 按钮文本
  final String text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮样式类型
  final AppButtonType type;

  /// 按钮尺寸
  final AppButtonSize size;

  /// 是否全宽
  final bool isFullWidth;

  /// 是否显示加载状态
  final bool isLoading;

  /// 前置图标
  final IconData? leadingIcon;

  /// 后置图标
  final IconData? trailingIcon;

  /// 自定义背景颜色
  final Color? backgroundColor;

  /// 自定义文字颜色
  final Color? textColor;

  /// 自定义边框颜色
  final Color? borderColor;

  /// 是否启用
  final bool enabled;

  /// 圆角半径
  final double? borderRadius;

  /// 内边距
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.enabled = true,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !enabled || onPressed == null || isLoading;

    // 获取尺寸配置
    final sizeConfig = _getSizeConfig(size);
    
    // 获取样式配置
    final styleConfig = _getStyleConfig(
      context,
      theme,
      type,
      isDisabled,
      backgroundColor,
      textColor,
      borderColor,
    );

    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(styleConfig.textColor),
            ),
          ),
          SizedBox(width: sizeConfig.spacing),
        ] else if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: sizeConfig.iconSize,
            color: styleConfig.textColor,
          ),
          SizedBox(width: sizeConfig.spacing),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: sizeConfig.fontSize,
            fontWeight: FontWeight.w600,
            color: styleConfig.textColor,
          ),
        ),
        if (!isLoading && trailingIcon != null) ...[
          SizedBox(width: sizeConfig.spacing),
          Icon(
            trailingIcon,
            size: sizeConfig.iconSize,
            color: styleConfig.textColor,
          ),
        ],
      ],
    );

    // 根据类型构建不同的按钮
    Widget button;
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: styleConfig.backgroundColor,
            foregroundColor: styleConfig.textColor,
            padding: padding ?? sizeConfig.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              side: BorderSide.none,
            ),
            elevation: isDisabled ? 0 : 2,
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: styleConfig.backgroundColor,
            foregroundColor: styleConfig.textColor,
            padding: padding ?? sizeConfig.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
            elevation: 0,
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: styleConfig.textColor,
            padding: padding ?? sizeConfig.padding,
            side: BorderSide(
              color: styleConfig.borderColor!,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: styleConfig.textColor,
            padding: padding ?? sizeConfig.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: buttonContent,
        );
        break;
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  _SizeConfig _getSizeConfig(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return _SizeConfig(
          fontSize: 14,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconSize: 16,
          spacing: 8,
        );
      case AppButtonSize.medium:
        return _SizeConfig(
          fontSize: 16,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          iconSize: 20,
          spacing: 10,
        );
      case AppButtonSize.large:
        return _SizeConfig(
          fontSize: 18,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          iconSize: 24,
          spacing: 12,
        );
    }
  }

  _StyleConfig _getStyleConfig(
    BuildContext context,
    ThemeData theme,
    AppButtonType type,
    bool isDisabled,
    Color? customBg,
    Color? customText,
    Color? customBorder,
  ) {
    final colorScheme = theme.colorScheme;
    
    if (isDisabled) {
      return _StyleConfig(
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.grey.shade600,
        borderColor: Colors.grey.shade400,
      );
    }

    switch (type) {
      case AppButtonType.primary:
        return _StyleConfig(
          backgroundColor: customBg ?? colorScheme.primary,
          textColor: customText ?? Colors.white,
          borderColor: customBorder,
        );
      case AppButtonType.secondary:
        return _StyleConfig(
          backgroundColor: customBg ?? colorScheme.secondaryContainer,
          textColor: customText ?? colorScheme.onSecondaryContainer,
          borderColor: customBorder,
        );
      case AppButtonType.outline:
        return _StyleConfig(
          backgroundColor: Colors.transparent,
          textColor: customText ?? colorScheme.primary,
          borderColor: customBorder ?? colorScheme.primary,
        );
      case AppButtonType.text:
        return _StyleConfig(
          backgroundColor: Colors.transparent,
          textColor: customText ?? colorScheme.primary,
          borderColor: customBorder,
        );
      case AppButtonType.danger:
        return _StyleConfig(
          backgroundColor: customBg ?? colorScheme.error,
          textColor: customText ?? Colors.white,
          borderColor: customBorder,
        );
    }
  }
}

/// 按钮样式类型
enum AppButtonType {
  /// 主要按钮
  primary,
  /// 次要按钮
  secondary,
  /// 轮廓按钮
  outline,
  /// 文本按钮
  text,
  /// 危险按钮
  danger,
}

/// 按钮尺寸
enum AppButtonSize {
  /// 小号
  small,
  /// 中号
  medium,
  /// 大号
  large,
}

class _SizeConfig {
  final double fontSize;
  final EdgeInsets padding;
  final double iconSize;
  final double spacing;

  _SizeConfig({
    required this.fontSize,
    required this.padding,
    required this.iconSize,
    required this.spacing,
  });
}

class _StyleConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  _StyleConfig({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });
}

