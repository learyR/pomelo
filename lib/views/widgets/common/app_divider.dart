import 'package:flutter/material.dart';

/// 通用分隔线组件
/// 
/// 提供统一的分隔线样式
class AppDivider extends StatelessWidget {
  /// 高度
  final double height;

  /// 颜色
  final Color? color;

  /// 左边距
  final double? indent;

  /// 右边距
  final double? endIndent;

  /// 粗细
  final double thickness;

  const AppDivider({
    super.key,
    this.height = 1.0,
    this.color,
    this.indent,
    this.endIndent,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.dividerColor;

    return Divider(
      height: height,
      thickness: thickness,
      color: dividerColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

/// 带文本的分隔线
class AppDividerWithText extends StatelessWidget {
  /// 文本
  final String text;

  /// 文本样式
  final TextStyle? textStyle;

  /// 线条颜色
  final Color? lineColor;

  /// 文本边距
  final double textPadding;

  /// 线条粗细
  final double thickness;

  const AppDividerWithText({
    super.key,
    required this.text,
    this.textStyle,
    this.lineColor,
    this.textPadding = 16,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = lineColor ?? theme.dividerColor;

    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: textPadding),
          child: Text(
            text,
            style: textStyle ?? theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}

/// 通用间距组件
/// 
/// 用于快速添加标准间距
class AppSpacing {
  /// 微小间距 (4.0)
  static const double xs = 4.0;

  /// 小间距 (8.0)
  static const double small = 8.0;

  /// 中等间距 (16.0)
  static const double medium = 16.0;

  /// 大间距 (24.0)
  static const double large = 24.0;

  /// 超大间距 (32.0)
  static const double xl = 32.0;

  /// 水平间距组件
  static Widget horizontal(double width) => SizedBox(width: width);

  /// 垂直间距组件
  static Widget vertical(double height) => SizedBox(height: height);

  /// 微小水平间距
  static Widget hXs() => horizontal(xs);

  /// 小水平间距
  static Widget hSmall() => horizontal(small);

  /// 中等水平间距
  static Widget hMedium() => horizontal(medium);

  /// 大水平间距
  static Widget hLarge() => horizontal(large);

  /// 超大水平间距
  static Widget hXl() => horizontal(xl);

  /// 微小垂直间距
  static Widget vXs() => vertical(xs);

  /// 小垂直间距
  static Widget vSmall() => vertical(small);

  /// 中等垂直间距
  static Widget vMedium() => vertical(medium);

  /// 大垂直间距
  static Widget vLarge() => vertical(large);

  /// 超大垂直间距
  static Widget vXl() => vertical(xl);
}

