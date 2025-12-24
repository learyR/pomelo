/// String扩展方法
extension StringExtension on String {
  /// 判断是否为空（包括空白字符）
  bool get isNullOrEmpty => isEmpty || trim().isEmpty;

  /// 判断是否为有效字符串
  bool get isNotEmpty => !isNullOrEmpty;

  /// 格式化手机号显示（中间四位用*代替）
  String get maskPhone {
    if (length != 11) return this;
    return '${substring(0, 3)}****${substring(7)}';
  }

  /// 首字母大写
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

