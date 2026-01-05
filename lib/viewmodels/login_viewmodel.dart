import 'package:flutter/cupertino.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/utils/logger_util.dart';
import 'base_model/viewmodel.dart';

/// 登录页 ViewModel
///
/// 负责登录相关的业务逻辑：
/// - 账号密码登录
/// - 验证码登录
/// - 第三方登录（微信、Apple ID）
/// - 表单验证
class LoginViewModel extends BaseViewModel<void> {
  late final accountController = TextEditingController();
  late final passwordController = TextEditingController();

  late final isLoading =
      SyncProperty<bool>(this, 'isLoading', defaultValue: false);
  late final isPasswordVisible =
      SyncProperty<bool>(this, 'isPasswordVisible', defaultValue: false);
  late final accountError =
      SyncProperty<String?>(this, 'accountError', defaultValue: null);
  late final passwordError =
      SyncProperty<String?>(this, 'passwordError', defaultValue: null);

  @override
  BaseViewModelState<void> build() {
    return BaseViewModelState.initial();
  }

  /// 清理资源
  void cleanup() {
    accountController.dispose();
    passwordController.dispose();
  }

  /// 切换密码显示/隐藏
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// 验证账号格式
  bool validateAccount(String? account) {
    if (account == null || account.isEmpty) {
      accountError.value = '请输入账号';
      return false;
    }
    // 验证手机号格式（11位数字）
    if (account.length != 11 || !RegExp(r'^\d+$').hasMatch(account)) {
      accountError.value = '请输入正确的手机号';
      return false;
    }
    accountError.value = null;
    return true;
  }

  /// 验证密码格式
  bool validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      passwordError.value = '请输入密码';
      return false;
    }
    if (password.length < 6) {
      passwordError.value = '密码长度至少6位';
      return false;
    }
    passwordError.value = null;
    return true;
  }

  /// 账号密码登录
  Future<bool> login() async {
    // 清除之前的错误
    accountError.value = null;
    passwordError.value = null;

    // 验证表单
    final accountValid = validateAccount(accountController.text);
    final passwordValid = validatePassword(passwordController.text);

    if (!accountValid || !passwordValid) {
      return false;
    }

    try {
      isLoading.value = true;
      // TODO: 调用登录API
      // final response = await ApiClient.instance.post('/login', data: {
      //   'account': accountController.text,
      //   'password': passwordController.text,
      // });

      // 模拟登录请求
      await Future.delayed(const Duration(seconds: 1));

      // 假设登录成功，保存token
      // await LocalStorage.setToken(response.data['token']);
      // await LocalStorage.setUserInfo(response.data['userInfo']);

      LoggerUtil.info('登录成功: ${accountController.text}');
      return true;
    } catch (e) {
      LoggerUtil.error('登录失败', e);
      // 显示错误信息
      passwordError.value = '账号或密码错误';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 验证码登录
  Future<void> loginWithVerificationCode() async {
    // TODO: 实现验证码登录逻辑
    LoggerUtil.info('验证码登录');
  }

  /// 微信登录
  Future<void> loginWithWeChat() async {
    try {
      isLoading.value = true;
      // TODO: 实现微信登录逻辑
      // await WeChatLogin.login();
      LoggerUtil.info('微信登录');
    } catch (e) {
      LoggerUtil.error('微信登录失败', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Apple ID 登录
  Future<void> loginWithApple() async {
    try {
      isLoading.value = true;
      // TODO: 实现Apple ID登录逻辑
      // await AppleSignIn.signIn();
      LoggerUtil.info('Apple ID登录');
    } catch (e) {
      LoggerUtil.error('Apple ID登录失败', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 获取目标路由（登录成功后跳转）
  String getTargetRoute() {
    return RouteName.home;
  }
}
