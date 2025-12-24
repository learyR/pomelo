// import 'package:validators/validators.dart' as validator;

/// 表单验证工具类
class Validators {
  /// 验证手机号
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    // 简单的手机号验证（11位数字，以1开头）
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '请输入正确的手机号';
    }
    return null;
  }

  /// 验证邮箱
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入正确的邮箱';
    }
    return null;
  }

  /// 验证密码
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度至少6位';
    }
    return null;
  }

  /// 验证必填项
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '请输入$fieldName' : '此字段为必填项';
    }
    return null;
  }

  /// 验证确认密码
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != password) {
      return '两次密码输入不一致';
    }
    return null;
  }
}
