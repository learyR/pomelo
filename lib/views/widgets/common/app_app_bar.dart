import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 通用 AppBar 组件
/// 
/// 提供统一的 AppBar 样式，支持多种配置和扩展
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题文本
  final String? title;

  /// 自定义标题组件
  final Widget? titleWidget;

  /// 是否自动显示返回按钮
  final bool automaticallyImplyLeading;

  /// 自定义返回按钮
  final Widget? leading;

  /// 返回按钮点击回调
  final VoidCallback? onBackPressed;

  /// 左侧组件列表（位于 leading 之后）
  final List<Widget>? leadingActions;

  /// 右侧操作按钮列表
  final List<Widget>? actions;

  /// 是否居中标题
  final bool? centerTitle;

  /// 背景颜色
  final Color? backgroundColor;

  /// 前景颜色（图标和文字）
  final Color? foregroundColor;

  /// 阴影高度
  final double? elevation;

  /// 底部边框
  final Border? bottom;

  /// 底部组件（如搜索框、Tab等）
  final Widget? bottomWidget;

  /// 底部组件高度
  final double? bottomHeight;

  /// 是否显示搜索框
  final bool showSearchBar;

  /// 搜索框占位符
  final String? searchHint;

  /// 搜索框文本变化回调
  final ValueChanged<String>? onSearchChanged;

  /// 搜索框提交回调
  final ValueChanged<String>? onSearchSubmitted;

  /// 是否透明背景
  final bool transparent;

  /// 背景渐变
  final Gradient? gradient;

  /// 底部边框颜色
  final Color? bottomBorderColor;

  /// 底部边框宽度
  final double bottomBorderWidth;

  /// 自定义背景组件
  final Widget? flexibleSpace;

  /// 系统状态栏样式
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// 标题间距
  final double? titleSpacing;

  /// 工具栏高度
  final double? toolbarHeight;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.onBackPressed,
    this.leadingActions,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    this.bottomWidget,
    this.bottomHeight,
    this.showSearchBar = false,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.transparent = false,
    this.gradient,
    this.flexibleSpace,
    this.systemOverlayStyle,
    this.titleSpacing,
    this.toolbarHeight,
    this.bottomBorderColor,
    this.bottomBorderWidth = 0.5,
  }) : assert(
          title != null || titleWidget != null || showSearchBar,
          '必须提供 title、titleWidget 或启用 showSearchBar',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    // 判断是否应该显示返回按钮
    final canPop = Navigator.canPop(context);
    final shouldShowLeading = automaticallyImplyLeading && canPop;

    // 构建标题
    Widget? titleWidget;
    if (showSearchBar) {
      // 搜索模式：显示搜索框作为标题
      titleWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: _buildSearchBar(context),
      );
    } else if (this.titleWidget != null) {
      titleWidget = this.titleWidget;
    } else if (title != null) {
      titleWidget = Text(
        title!,
        style: appBarTheme.titleTextStyle ??
            theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      );
    }

    // 构建 leading
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (shouldShowLeading) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      );
    }

    // 构建 leadingActions（如果有）
    List<Widget>? leadingActionsList;
    if (leadingActions != null && leadingActions!.isNotEmpty) {
      leadingActionsList = leadingActions;
    }

    // 构建背景
    Widget? backgroundWidget;
    if (flexibleSpace != null) {
      backgroundWidget = flexibleSpace;
    } else if (gradient != null) {
      backgroundWidget = Container(
        decoration: BoxDecoration(gradient: gradient),
      );
    } else if (transparent) {
      backgroundWidget = Container(color: Colors.transparent);
    }

    // 计算背景颜色
    Color? bgColor;
    if (transparent || gradient != null || flexibleSpace != null) {
      bgColor = Colors.transparent;
    } else {
      bgColor = backgroundColor ?? appBarTheme.backgroundColor;
    }

    // 计算前景颜色
    final fgColor = foregroundColor ?? appBarTheme.foregroundColor;

    // 计算阴影
    final appBarElevation = elevation ?? appBarTheme.elevation ?? 0.0;

    // 计算是否居中
    final isCenterTitle = centerTitle ?? appBarTheme.centerTitle ?? false;

    // 构建底部边框
    PreferredSizeWidget? bottomWidget;
    if (this.bottomWidget != null) {
      bottomWidget = PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight ?? 56),
        child: Container(
          decoration: bottomBorderColor != null
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: bottomBorderColor!,
                      width: bottomBorderWidth,
                    ),
                  ),
                )
              : null,
          child: this.bottomWidget!,
        ),
      );
    } else if (bottom != null) {
      bottomWidget = PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(decoration: BoxDecoration(border: bottom)),
      );
    } else if (bottomBorderColor != null && appBarElevation == 0) {
      bottomWidget = PreferredSize(
        preferredSize: Size.fromHeight(bottomBorderWidth),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: bottomBorderColor!,
                width: bottomBorderWidth,
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: titleWidget,
      leading: leadingWidget,
      automaticallyImplyLeading: false,
      actions: [
        if (leadingActionsList != null) ...leadingActionsList,
        ...?actions,
      ],
      centerTitle: isCenterTitle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: appBarElevation,
      bottom: bottomWidget,
      flexibleSpace: backgroundWidget,
      systemOverlayStyle: systemOverlayStyle ??
          ((transparent || gradient != null || flexibleSpace != null)
              ? SystemUiOverlayStyle.dark
              : null),
      titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      iconTheme: IconThemeData(color: fgColor),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        autofocus: true,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: searchHint ?? '搜索',
          hintStyle: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          isDense: true,
        ),
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
      ),
    );
  }

  @override
  Size get preferredSize {
    final height = toolbarHeight ?? kToolbarHeight;
    final bottomHeightValue = bottomHeight ?? (bottomWidget != null ? 56 : 0);
    return Size.fromHeight(height + bottomHeightValue);
  }
}

/// 带搜索功能的 AppBar Builder
/// 
/// 用于在普通模式和搜索模式之间切换
class AppAppBarWithSearch extends StatefulWidget implements PreferredSizeWidget {
  /// 标题文本
  final String? title;

  /// 自定义标题组件
  final Widget? titleWidget;

  /// 是否自动显示返回按钮
  final bool automaticallyImplyLeading;

  /// 自定义返回按钮
  final Widget? leading;

  /// 返回按钮点击回调
  final ValueChanged<bool>? onSearchModeChanged;

  /// 右侧操作按钮列表（普通模式）
  final List<Widget>? actions;

  /// 右侧操作按钮列表（搜索模式）
  final List<Widget>? searchActions;

  /// 搜索框占位符
  final String? searchHint;

  /// 搜索框文本变化回调
  final ValueChanged<String>? onSearchChanged;

  /// 搜索框提交回调
  final ValueChanged<String>? onSearchSubmitted;

  /// 其他 AppAppBar 参数
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool? centerTitle;
  final Widget? bottomWidget;
  final double? bottomHeight;

  const AppAppBarWithSearch({
    super.key,
    this.title,
    this.titleWidget,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.onSearchModeChanged,
    this.actions,
    this.searchActions,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.bottomWidget,
    this.bottomHeight,
  });

  @override
  State<AppAppBarWithSearch> createState() => _AppAppBarWithSearchState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppAppBarWithSearchState extends State<AppAppBarWithSearch> {
  bool _isSearchMode = false;

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
    });
    widget.onSearchModeChanged?.call(_isSearchMode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearchMode) {
      return AppAppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        leading: widget.leading,
        onBackPressed: _toggleSearchMode,
        showSearchBar: true,
        searchHint: widget.searchHint,
        onSearchChanged: widget.onSearchChanged,
        onSearchSubmitted: widget.onSearchSubmitted,
        actions: [
          ...?widget.searchActions,
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _toggleSearchMode,
            tooltip: '关闭搜索',
          ),
        ],
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        elevation: widget.elevation,
        centerTitle: widget.centerTitle,
        bottomWidget: widget.bottomWidget,
        bottomHeight: widget.bottomHeight,
      );
    }

    return AppAppBar(
      title: widget.title,
      titleWidget: widget.titleWidget,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: widget.leading,
      actions: [
        ...?widget.actions,
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _toggleSearchMode,
          tooltip: '搜索',
        ),
      ],
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      centerTitle: widget.centerTitle,
      bottomWidget: widget.bottomWidget,
      bottomHeight: widget.bottomHeight,
    );
  }
}

