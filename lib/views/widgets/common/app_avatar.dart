import 'package:flutter/material.dart';

/// 通用头像组件
/// 
/// 支持图片、文字、图标等多种显示方式
class AppAvatar extends StatelessWidget {
  /// 图片地址（网络或本地）
  final String? imageUrl;

  /// 显示的文字
  final String? text;

  /// 显示的文字（取首字符）
  final String? name;

  /// 图标
  final IconData? icon;

  /// 尺寸
  final double size;

  /// 背景颜色
  final Color? backgroundColor;

  /// 文字颜色
  final Color? textColor;

  /// 图标颜色
  final Color? iconColor;

  /// 边框颜色
  final Color? borderColor;

  /// 边框宽度
  final double borderWidth;

  /// 形状
  final BoxShape shape;

  /// 占位符图标
  final IconData placeholderIcon;

  /// 错误时的占位符图标
  final IconData? errorIcon;

  /// 点击回调
  final VoidCallback? onTap;

  /// 长按回调
  final VoidCallback? onLongPress;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.text,
    this.name,
    this.icon,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 0,
    this.shape = BoxShape.circle,
    this.placeholderIcon = Icons.person,
    this.errorIcon,
    this.onTap,
    this.onLongPress,
  }) : assert(
          imageUrl != null || text != null || name != null || icon != null,
          '至少需要提供一个：imageUrl、text、name 或 icon',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget avatarContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        shape: shape,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: _buildContent(colorScheme),
    );

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: avatarContent,
      );
    }

    return avatarContent;
  }

  Widget _buildContent(ColorScheme colorScheme) {
    // 优先显示图片
    if (imageUrl != null) {
      if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
        // 网络图片
        return ClipOval(
          child: Image.network(
            imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(colorScheme);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        );
      } else {
        // 本地图片
        return ClipOval(
          child: Image.asset(
            imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(colorScheme);
            },
          ),
        );
      }
    }

    // 显示文字
    if (text != null) {
      return Center(
        child: Text(
          text!,
          style: TextStyle(
            color: textColor ?? colorScheme.onPrimaryContainer,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // 显示名称首字符
    if (name != null && name!.isNotEmpty) {
      final firstChar = name!.trim().substring(0, 1).toUpperCase();
      return Center(
        child: Text(
          firstChar,
          style: TextStyle(
            color: textColor ?? colorScheme.onPrimaryContainer,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // 显示图标
    if (icon != null) {
      return Icon(
        icon,
        size: size * 0.5,
        color: iconColor ?? colorScheme.onPrimaryContainer,
      );
    }

    return _buildPlaceholder(colorScheme);
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Icon(
      errorIcon ?? placeholderIcon,
      size: size * 0.5,
      color: iconColor ?? colorScheme.onPrimaryContainer.withOpacity(0.6),
    );
  }
}

/// 头像组组件（用于显示多个头像）
class AppAvatarGroup extends StatelessWidget {
  /// 头像列表
  final List<AppAvatar> avatars;

  /// 重叠宽度
  final double overlap;

  /// 最大显示数量（超出部分显示数字）
  final int? maxCount;

  /// 剩余数量显示样式
  final TextStyle? remainingTextStyle;

  /// 剩余数量背景颜色
  final Color? remainingBackgroundColor;

  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.overlap = 8,
    this.maxCount,
    this.remainingTextStyle,
    this.remainingBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayAvatars = maxCount != null && avatars.length > maxCount!
        ? avatars.take(maxCount!).toList()
        : avatars;
    final remainingCount = maxCount != null && avatars.length > maxCount!
        ? avatars.length - maxCount!
        : 0;

    return SizedBox(
      height: displayAvatars.first.size,
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;
            return Positioned(
              left: index * (avatar.size - overlap),
              child: avatar,
            );
          }),
          if (remainingCount > 0)
            Positioned(
              left: displayAvatars.length * (displayAvatars.first.size - overlap),
              child: Container(
                width: displayAvatars.first.size,
                height: displayAvatars.first.size,
                decoration: BoxDecoration(
                  color: remainingBackgroundColor ?? colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: remainingTextStyle ??
                        TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: displayAvatars.first.size * 0.3,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

