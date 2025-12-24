import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 通用搜索框组件
/// 
/// 提供统一的搜索输入体验
class AppSearchBar extends StatefulWidget {
  /// 控制器
  final TextEditingController? controller;

  /// 占位符文本
  final String hintText;

  /// 初始值
  final String? initialValue;

  /// 搜索回调
  final ValueChanged<String>? onSearch;

  /// 文本变化回调
  final ValueChanged<String>? onChanged;

  /// 清除回调
  final VoidCallback? onClear;

  /// 取消回调
  final VoidCallback? onCancel;

  /// 是否显示取消按钮
  final bool showCancelButton;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 是否启用
  final bool enabled;

  /// 只读模式
  final bool readOnly;

  /// 点击回调（只读模式下使用）
  final VoidCallback? onTap;

  /// 边框半径
  final double? borderRadius;

  /// 背景颜色
  final Color? backgroundColor;

  /// 高度
  final double? height;

  /// 内容内边距
  final EdgeInsetsGeometry? contentPadding;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = '搜索',
    this.initialValue,
    this.onSearch,
    this.onChanged,
    this.onClear,
    this.onCancel,
    this.showCancelButton = false,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.height,
    this.contentPadding,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
      widget.onChanged?.call(_controller.text);
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
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearch() {
    widget.onSearch?.call(_controller.text);
    _focusNode.unfocus();
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = widget.backgroundColor ?? theme.inputDecorationTheme.fillColor ?? Colors.grey.shade100;
    final borderRadius = widget.borderRadius ?? 24.0;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: widget.height ?? 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              onTap: widget.readOnly ? widget.onTap : null,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _handleSearch(),
              inputFormatters: widget.readOnly ? null : [],
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                suffixIcon: _hasText && !widget.readOnly
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: _handleClear,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
            ),
          ),
        ),
        if (widget.showCancelButton) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              _focusNode.unfocus();
              widget.onCancel?.call();
            },
            child: const Text('取消'),
          ),
        ],
      ],
    );
  }
}

