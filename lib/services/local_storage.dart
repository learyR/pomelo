import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

/// 本地存储工具类
class LocalStorage {
  static SharedPreferences? _prefs;

  /// 初始化
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 保存字符串
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// 获取字符串
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// 保存整数
  static Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  /// 获取整数
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// 保存布尔值
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  /// 获取布尔值
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// 保存对象（JSON）
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    return await _prefs?.setString(key, jsonEncode(value)) ?? false;
  }

  /// 获取对象（JSON）
  static Map<String, dynamic>? getObject(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// 删除指定key
  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  /// 清空所有数据
  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  /// 保存Token
  static Future<bool> saveToken(String token) async {
    return await setString(AppConstants.tokenKey, token);
  }

  /// 获取Token
  static String? getToken() {
    return getString(AppConstants.tokenKey);
  }

  /// 删除Token
  static Future<bool> removeToken() async {
    return await remove(AppConstants.tokenKey);
  }
}

