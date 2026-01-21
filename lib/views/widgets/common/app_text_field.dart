import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 通用输入框组件
///
/// 支持多种样式、验证、图标等配置
class AppTextField extends StatefulWidget {
  /// 控制器
  final TextEditingController? controller;

  /// 占位符文本
  final String? hintText;

  /// 标签文本
  final String? labelText;

  /// 初始值
  final String? initialValue;

  /// 输入类型
  final TextInputType? keyboardType;

  /// 是否密码输入
  final bool obscureText;

  /// 是否只读
  final bool readOnly;

  /// 是否启用
  final bool enabled;

  /// 最大行数
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 最大字符数
  final int? maxLength;

  /// 是否显示字符计数
  final bool showCounter;

  /// 前置图标
  final IconData? prefixIcon;

  /// 后置图标
  final IconData? suffixIcon;

  /// 后置图标点击回调
  final VoidCallback? onSuffixIconTap;

  /// 前置组件
  final Widget? prefix;

  /// 后置组件
  final Widget? suffix;

  /// 输入变化回调
  final ValueChanged<String>? onChanged;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 焦点变化回调
  final ValueChanged<bool>? onFocusChange;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 验证函数
  final String? Function(String?)? validator;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// 文本对齐方式
  final TextAlign textAlign;

  /// 文本样式
  final TextStyle? textStyle;

  /// 填充颜色
  final Color? fillColor;

  /// 边框颜色
  final Color? borderColor;

  /// 焦点边框颜色
  final Color? focusedBorderColor;

  /// 错误边框颜色
  final Color? errorBorderColor;

  /// 圆角半径
  final double? borderRadius;

  /// 内容内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 文本输入动作
  final TextInputAction? textInputAction;

  /// 自动校正
  final bool autocorrect;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChange,
    this.focusNode,
    this.validator,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.autofocus = false,
    this.textInputAction,
    this.autocorrect = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _isFocused = false;
  bool _isOwnFocusNode = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _isOwnFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _isOwnFocusNode = true;
    }
    _obscureText = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      widget.onFocusChange?.call(_isFocused);
    });

    if (widget.initialValue != null && widget.controller == null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (_isOwnFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 构建前缀图标
    Widget? prefixIconWidget;
    if (widget.prefixIcon != null) {
      prefixIconWidget = Icon(
        widget.prefixIcon,
        color: _isFocused
            ? (widget.focusedBorderColor ?? colorScheme.primary)
            : Colors.grey.shade600,
      );
    }

    // 构建后缀图标
    Widget? suffixIconWidget;
    if (widget.obscureText) {
      // 密码输入框显示眼睛图标
      suffixIconWidget = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey.shade600,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      suffixIconWidget = widget.onSuffixIconTap != null
          ? IconButton(
              icon: Icon(widget.suffixIcon, color: Colors.grey.shade600),
              onPressed: widget.onSuffixIconTap,
            )
          : Icon(widget.suffixIcon, color: Colors.grey.shade600);
    }

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      autocorrect: widget.autocorrect,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      style: widget.textStyle ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefix ?? prefixIconWidget,
        suffixIcon: widget.suffix ?? suffixIconWidget,
        // suffixIconConstraints: BoxConstraints(minHeight: 36),
        filled: true,
        fillColor: widget.fillColor ??
            (widget.enabled
                ? (theme.inputDecorationTheme.fillColor ?? Colors.white)
                : Colors.grey.shade200),
        counterText: widget.showCounter ? null : '',
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.borderColor ?? Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? colorScheme.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(
            color: widget.errorBorderColor ?? colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
