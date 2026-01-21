import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:pomelo/core/constants/app_constants.dart';
import 'package:pomelo/utils/logger_util.dart';
import '../models/user_model.dart';
import '../services/local_storage.dart';
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
  late final verificationCodeController = TextEditingController();
  late final invitationCodeController = TextEditingController();

  late final isLoading = syncBool('isLoading');
  late final isPasswordVisible = syncBool('isPasswordVisible');
  late final accountError = syncString('accountError');
  late final passwordError = syncString('passwordError');
  late final verificationCodeError = syncString('verificationCodeError');

  // 验证码倒计时相关
  late final countdownSeconds = syncInt('countdownSeconds', defaultValue: 0);
  Timer? _countdownTimer;

  @override
  BaseViewModelState<void> build() {
    return BaseViewModelState.initial();
  }

  /// 清理资源
  void cleanup() {
    accountController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    invitationCodeController.dispose();
    _countdownTimer?.cancel();
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
    accountError.value = '';
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
    passwordError.value = '';
    return true;
  }

  /// 账号密码登录
  Future<bool> login() async {
    // 清除之前的错误
    accountError.value = '';
    passwordError.value = '';

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
      await LocalStorage.saveToken("testToken");
      await LocalStorage.setObject(
          AppConstants.userInfoKey,
          UserModel(
                  id: "No1",
                  username: "leary",
                  nickname: "拍肩大帝",
                  avatar: "",
                  phone: "18583289318",
                  email: "leary_e@qq.com")
              .toJson());
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

  /// 验证验证码格式
  bool validateVerificationCode(String? code) {
    if (code == null || code.isEmpty) {
      verificationCodeError.value = '请输入验证码';
      return false;
    }
    // 验证码通常是4-6位数字
    if (code.length < 4 || !RegExp(r'^\d+$').hasMatch(code)) {
      verificationCodeError.value = '请输入正确的验证码';
      return false;
    }
    verificationCodeError.value = '';
    return true;
  }

  /// 发送验证码
  Future<bool> sendVerificationCode() async {
    // 先验证手机号
    if (!validateAccount(accountController.text)) {
      return false;
    }

    try {
      // TODO: 调用发送验证码API
      // await ApiClient.instance.post('/send-verification-code', data: {
      //   'phone': accountController.text,
      // });

      // 模拟发送验证码请求
      await Future.delayed(const Duration(milliseconds: 500));

      // 开始倒计时（60秒）
      startCountdown(60);
      LoggerUtil.info('验证码已发送到: ${accountController.text}');
      return true;
    } catch (e) {
      LoggerUtil.error('发送验证码失败', e);
      accountError.value = '发送验证码失败，请稍后重试';
      return false;
    }
  }

  /// 开始倒计时
  void startCountdown(int seconds) {
    _countdownTimer?.cancel();
    countdownSeconds.value = seconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        _countdownTimer = null;
      }
    });
  }

  /// 验证码登录
  Future<bool> loginWithVerificationCode() async {
    // 清除之前的错误
    accountError.value = '';
    verificationCodeError.value = '';

    // 验证表单
    final accountValid = validateAccount(accountController.text);
    final codeValid = validateVerificationCode(verificationCodeController.text);

    if (!accountValid || !codeValid) {
      return false;
    }

    try {
      isLoading.value = true;
      // TODO: 调用验证码登录API
      // final response = await ApiClient.instance.post('/login-with-code', data: {
      //   'phone': accountController.text,
      //   'code': verificationCodeController.text,
      // });

      // 模拟登录请求
      await Future.delayed(const Duration(seconds: 1));

      // 假设登录成功，保存token
      // await LocalStorage.setToken(response.data['token']);
      // await LocalStorage.setUserInfo(response.data['userInfo']);

      LoggerUtil.info('验证码登录成功: ${accountController.text}');
      return true;
    } catch (e) {
      LoggerUtil.error('验证码登录失败', e);
      // 显示错误信息
      verificationCodeError.value = '验证码错误或已过期';
      return false;
    } finally {
      isLoading.value = false;
    }
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

  /// 重置密码（忘记密码功能）
  Future<bool> resetPassword() async {
    // 清除之前的错误
    accountError.value = '';
    verificationCodeError.value = '';
    passwordError.value = '';

    // 验证表单
    final accountValid = validateAccount(accountController.text);
    final codeValid = validateVerificationCode(verificationCodeController.text);
    final passwordValid = validatePassword(passwordController.text);

    if (!accountValid || !codeValid || !passwordValid) {
      return false;
    }

    try {
      isLoading.value = true;
      // TODO: 调用重置密码API
      // final response = await ApiClient.instance.post('/forgot-password/reset', data: {
      //   'phone': accountController.text,
      //   'code': verificationCodeController.text,
      //   'newPassword': passwordController.text,
      // });

      // 模拟重置密码请求
      await Future.delayed(const Duration(seconds: 1));

      LoggerUtil.info('密码重置成功: ${accountController.text}');
      return true;
    } catch (e) {
      LoggerUtil.error('密码重置失败', e);
      // 显示错误信息
      verificationCodeError.value = '验证码错误或已过期';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 注册
  ///
  /// 通过手机号 + 验证码 + 密码创建账号；邀请码可选。
  Future<bool> register() async {
    // 清除之前的错误
    accountError.value = '';
    verificationCodeError.value = '';
    passwordError.value = '';

    // 验证表单
    final accountValid = validateAccount(accountController.text);
    final codeValid = validateVerificationCode(verificationCodeController.text);
    final passwordValid = validatePassword(passwordController.text);

    if (!accountValid || !codeValid || !passwordValid) {
      return false;
    }

    try {
      isLoading.value = true;
      // TODO: 调用注册 API
      // final response = await ApiClient.instance.post('/register', data: {
      //   'phone': accountController.text,
      //   'code': verificationCodeController.text,
      //   'password': passwordController.text,
      //   if (invitationCodeController.text.isNotEmpty)
      //     'invitationCode': invitationCodeController.text,
      // });

      // 模拟注册请求
      await Future.delayed(const Duration(seconds: 1));

      LoggerUtil.info(
        '注册成功: phone=${accountController.text}, invitationCode=${invitationCodeController.text.isEmpty ? '' : invitationCodeController.text}',
      );
      return true;
    } catch (e) {
      LoggerUtil.error('注册失败', e);
      verificationCodeError.value = '注册失败，请稍后重试';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
