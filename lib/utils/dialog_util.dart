import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 对话框工具类
///
/// 封装常用的 iOS 风格对话框
class DialogUtil {
  DialogUtil._(); // 私有构造函数，防止实例化

  /// 显示确认对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [content] 内容
  /// [confirmText] 确认按钮文本，默认为"确定"
  /// [cancelText] 取消按钮文本，默认为"取消"
  /// [onConfirm] 确认回调
  /// [onCancel] 取消回调
  /// [barrierDismissible] 点击外部是否关闭，默认为 true
  ///
  /// 返回：true 表示确认，false 表示取消
  static Future<bool?> showConfirm(
    BuildContext context, {
    String? title,
    String? content,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    return await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// 显示提示对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [content] 内容
  /// [confirmText] 确认按钮文本，默认为"确定"
  /// [onConfirm] 确认回调
  /// [barrierDismissible] 点击外部是否关闭，默认为 true
  static Future<void> showAlert(
    BuildContext context, {
    String? title,
    String? content,
    String confirmText = '确定',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    await showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// 显示输入对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [hintText] 输入框提示文本
  /// [initialValue] 初始值
  /// [keyboardType] 键盘类型
  /// [maxLength] 最大长度
  /// [confirmText] 确认按钮文本，默认为"确定"
  /// [cancelText] 取消按钮文本，默认为"取消"
  /// [onConfirm] 确认回调，参数为输入的文本
  /// [onCancel] 取消回调
  /// [validator] 输入验证函数，返回 null 表示验证通过，返回字符串表示错误信息
  ///
  /// 返回：输入的文本，如果取消则返回 null
  static Future<String?> showInput(
    BuildContext context, {
    String? title,
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    int? maxLength,
    String confirmText = '确定',
    String cancelText = '取消',
    void Function(String value)? onConfirm,
    VoidCallback? onCancel,
    String? Function(String? value)? validator,
  }) async {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    String? errorText;

    return await showCupertinoDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: controller,
              placeholder: hintText,
              keyboardType: keyboardType,
              maxLength: maxLength,
              autofocus: true,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              onChanged: (value) {
                if (validator != null) {
                  final error = validator(value);
                  setState(() {
                    errorText = error;
                  });
                }
              },
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: false,
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: errorText == null && controller.text.isNotEmpty
                  ? () {
                      final value = controller.text;
                      Navigator.of(context).pop(value);
                      onConfirm?.call(value);
                    }
                  : null,
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示选择对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [options] 选项列表
  /// [cancelText] 取消按钮文本，默认为"取消"
  /// [onSelected] 选择回调，参数为选中的索引和文本
  /// [barrierDismissible] 点击外部是否关闭，默认为 true
  ///
  /// 返回：选中的索引，如果取消则返回 null
  static Future<int?> showActionSheet(
    BuildContext context, {
    String? title,
    required List<String> options,
    String cancelText = '取消',
    void Function(int index, String option)? onSelected,
    bool barrierDismissible = true,
  }) async {
    return await showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        actions: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(index);
              onSelected?.call(index, option);
            },
            child: Text(option),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(cancelText),
        ),
      ),
    );
  }

  /// 显示加载对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [message] 提示信息
  /// [barrierDismissible] 点击外部是否关闭，默认为 false
  ///
  /// 返回：用于关闭对话框的 OverlayEntry 对象
  static OverlayEntry? showLoading(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withValues(alpha: 0.3),
        child: GestureDetector(
          onTap: barrierDismissible
              ? () {
                  overlayEntry.remove();
                }
              : null,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CupertinoActivityIndicator(
                    radius: 16,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.label,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    return overlayEntry;
  }

  /// 关闭加载对话框
  ///
  /// [overlayEntry] 加载对话框的 OverlayEntry
  static void hideLoading(OverlayEntry? overlayEntry) {
    overlayEntry?.remove();
  }

  /// 显示自定义对话框（iOS 风格）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [content] 内容 Widget
  /// [actions] 操作按钮列表
  /// [barrierDismissible] 点击外部是否关闭，默认为 true
  static Future<T?> showCustom<T>(
    BuildContext context, {
    String? title,
    Widget? content,
    List<CupertinoDialogAction>? actions,
    bool barrierDismissible = true,
  }) async {
    return await showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content,
        actions: actions ?? [],
      ),
    );
  }

  /// 显示删除确认对话框（iOS 风格，删除按钮为红色）
  ///
  /// [context] BuildContext
  /// [title] 标题
  /// [content] 内容
  /// [deleteText] 删除按钮文本，默认为"删除"
  /// [cancelText] 取消按钮文本，默认为"取消"
  /// [onDelete] 删除回调
  /// [onCancel] 取消回调
  /// [barrierDismissible] 点击外部是否关闭，默认为 true
  ///
  /// 返回：true 表示删除，false 表示取消
  static Future<bool?> showDeleteConfirm(
    BuildContext context, {
    String? title,
    String? content,
    String deleteText = '删除',
    String cancelText = '取消',
    VoidCallback? onDelete,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    return await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete?.call();
            },
            child: Text(deleteText),
          ),
        ],
      ),
    );
  }

  /// 显示底部选择器（iOS 风格）
  ///
  /// [context] BuildContext
  /// [options] 选项列表
  /// [selectedIndex] 当前选中的索引
  /// [onSelected] 选择回调，参数为选中的索引和文本
  /// [cancelText] 取消按钮文本，默认为"取消"
  ///
  /// 返回：选中的索引，如果取消则返回 null
  static Future<int?> showPicker(
    BuildContext context, {
    required List<String> options,
    int? selectedIndex,
    void Function(int index, String option)? onSelected,
    String cancelText = '取消',
  }) async {
    int? currentIndex = selectedIndex;

    return await showCupertinoModalPopup<int>(
      context: context,
      builder: (context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部工具栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(cancelText),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (currentIndex != null) {
                          final index = currentIndex!;
                          Navigator.of(context).pop(index);
                          onSelected?.call(index, options[index]);
                        }
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 选择器
              Expanded(
                child: CupertinoPicker(
                  scrollController: currentIndex != null
                      ? FixedExtentScrollController(initialItem: currentIndex!)
                      : null,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    currentIndex = index;
                  },
                  children: options
                      .map((option) => Center(
                            child: Text(option),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
