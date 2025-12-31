import 'dart:async';

import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/services/local_storage.dart';
import 'package:pomelo/utils/logger_util.dart';
import 'package:pomelo/utils/update_util.dart';
import 'base_model/viewmodel.dart';

/// 闪屏页 ViewModel
///
/// 负责应用启动时的初始化逻辑：
/// - 检查服务协议确认状态
/// - 管理倒计时
/// - 检查应用更新
/// - 检查用户登录状态
/// - 决定跳转目标页面
class SplashViewModel extends BaseViewModel<void> {
  late final updateInfo = AsyncDataProperty<UpdateInfo>(this, 'updateInfo');

  late final isInitialized =
      SyncProperty<bool>(this, 'isInitialized', defaultValue: false);
  late final isLoggedIn =
      SyncProperty<bool>(this, 'isLoggedIn', defaultValue: false);
  late final agreementAccepted =
      SyncProperty<bool>(this, 'agreementAccepted', defaultValue: false);
  late final countdown = SyncProperty<int>(this, 'countdown', defaultValue: 3);

  Timer? _countdownTimer;

  @override
  BaseViewModelState<void> build() {
    return BaseViewModelState.initial();
  }

  /// 清理资源
  void cleanup() {
    _countdownTimer?.cancel();
  }

  /// 初始化应用
  ///
  /// 执行启动时的所有初始化任务
  Future<void> initialize() async {
    try {
      // 检查登录状态（同步操作，快速完成）
      _checkLoginStatus();
      // 检查应用更新（异步操作，需要等待完成以确保更新信息可用）
      await _checkUpdate();
      isInitialized.value = true;
    } catch (e) {
      // 即使初始化失败，也允许继续进入应用
      isInitialized.value = true;
    }
  }

  /// 检查应用更新
  Future<void> _checkUpdate() async {
    try {
      final update = await UpdateUtil.checkUpdate();
      if (update != null && update.hasUpdate) {
        // 直接设置值，因为数据已经获取到了
        updateInfo.value = update;
      }
    } catch (e) {
      // 更新检查失败不影响应用启动
      LoggerUtil.error('检查更新失败', e);
    }
  }

  /// 检查登录状态
  void _checkLoginStatus() {
    try {
      final token = LocalStorage.getToken();
      isLoggedIn.value = token != null && token.isNotEmpty;
    } catch (e) {
      // 登录状态检查失败，默认未登录
      isLoggedIn.value = false;
    }
  }

  /// 获取目标路由
  ///
  /// 根据初始化结果返回应该跳转的路由
  String getTargetRoute() {
    // 如果有强制更新，不跳转（等待用户处理更新）
    final update = updateInfo.value;
    if (update != null && update.forceUpdate) {
      return RouteName.splash; // 保持在闪屏页
    }
    // 检查登录状态
    if (isLoggedIn.value) {
      return RouteName.home; // 已登录，跳转到首页
    } else {
      return RouteName.login; // 未登录，跳转到登录页
    }
  }

  /// 检查是否需要显示更新对话框
  bool shouldShowUpdateDialog() {
    final update = updateInfo.value;
    return update != null && update.hasUpdate;
  }

  /// 获取更新信息
  UpdateInfo? getUpdateInfo() {
    return updateInfo.value;
  }

  /// 检查是否初始化完成
  bool get isInitComplete => isInitialized.value;

  /// 检查服务协议状态
  Future<bool> checkAgreementStatus() async {
    final accepted = LocalStorage.getBool('agreement_accepted') ?? false;
    agreementAccepted.value = accepted;
    return accepted;
  }

  /// 保存协议确认状态并开始倒计时
  Future<void> acceptAgreementAndStartCountdown() async {
    await LocalStorage.setBool('agreement_accepted', true);
    agreementAccepted.value = true;
    startCountdown();
  }

  /// 保存协议确认状态
  Future<void> saveAgreementStatus(bool accepted) async {
    await LocalStorage.setBool('agreement_accepted', accepted);
    agreementAccepted.value = accepted;
  }

  /// 开始倒计时
  void startCountdown() {
    _countdownTimer?.cancel();
    countdown.value = 3;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value = countdown.value - 1;
      } else {
        timer.cancel();
      }
    });
  }

  /// 停止倒计时
  void stopCountdown() {
    _countdownTimer?.cancel();
  }

  /// 检查倒计时是否结束
  bool get isCountdownFinished => countdown.value <= 0;

  /// 等待倒计时结束
  Future<void> waitForCountdown() async {
    while (!isCountdownFinished) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
