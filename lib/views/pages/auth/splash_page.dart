import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/utils/dialog_util.dart';
import 'package:pomelo/utils/image_util.dart';
import 'package:pomelo/utils/update_util.dart';
import 'package:pomelo/utils/status_bar_util.dart';
import 'package:pomelo/viewmodels/splash_viewmodel.dart';

import '../../../viewmodels/provider/provider.dart';
import '../../widgets/helper/view_helper.dart';

/// 闪屏页 Provider
final splashProvider = createProvider<SplashViewModel, void>(
  () => SplashViewModel(),
);

/// 闪屏页
///
/// 负责应用启动时的闪屏展示、更新检测、登录状态检查等
/// 根据初始化结果自动跳转到相应页面（登录页或主页）
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;
  static const _minDisplayDuration = Duration(milliseconds: 1500);
  static const _navigationDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  /// 初始化应用流程
  Future<void> _initialize() async {
    final viewModel = ref.read(splashProvider.notifier);

    // 1. 处理服务协议
    await _handleAgreement(viewModel);
    if (!mounted) return;

    // 2. 执行初始化并确保最小显示时长
    final startTime = DateTime.now();
    await viewModel.initialize();
    if (!mounted) return;

    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < _minDisplayDuration) {
      await Future.delayed(_minDisplayDuration - elapsed);
    }
    if (!mounted) return;

    // 3. 处理更新对话框
    if (viewModel.shouldShowUpdateDialog()) {
      final updateInfo = viewModel.getUpdateInfo();
      if (updateInfo != null) {
        await UpdateUtil.handleUpdate(context, updateInfo);
        if (updateInfo.forceUpdate || !mounted) return;
      }
    }

    // 4. 等待倒计时结束并导航
    if (mounted && !_hasNavigated) {
      await viewModel.waitForCountdown();
      if (mounted && !_hasNavigated) {
        _navigate(viewModel);
      }
    }
  }

  /// 处理服务协议确认
  Future<void> _handleAgreement(SplashViewModel viewModel) async {
    final accepted = await viewModel.checkAgreementStatus();
    if (accepted) {
      viewModel.startCountdown();
      return;
    }

    // 显示协议对话框，直到用户同意
    while (!viewModel.agreementAccepted.value && mounted) {
      final result = await showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => _AgreementDialog(viewModel),
      );

      if (result == true && mounted) {
        await viewModel.acceptAgreementAndStartCountdown();
      } else if (mounted) {
        await DialogUtil.showAlert(
          context,
          title: '提示',
          content: '需要同意服务协议才能使用应用',
          confirmText: '重新查看',
        );
      }
    }
  }

  /// 跳过闪屏
  void _skip() {
    if (_hasNavigated) return;
    final viewModel = ref.read(splashProvider.notifier);
    viewModel.stopCountdown();
    _navigate(viewModel);
  }

  /// 导航到目标页面
  void _navigate(SplashViewModel viewModel) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    Future.delayed(_navigationDelay, () {
      if (mounted) {
        context.go(viewModel.getTargetRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watchViewModel(splashProvider);

    return StatusBarWrapper(
      lightIcons: true, // 使用浅色图标（适用于深色背景）
      child: PopScope(
        canPop: false, // 禁止返回
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              ImageUtil.buildImage(AppImages.bgSplash),
              // 右上角倒计时和跳过按钮
              if (viewModel.isAgreementAccepted)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: _buildCountdownWidget(viewModel.countDownValue),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建倒计时和跳过按钮
  Widget _buildCountdownWidget(int countdown) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 倒计时
          Text('$countdown',
              style:
                  TextStyles.textHint14.copyWith(fontWeight: FontWeight.w500)),
          Gaps.hGap8,
          // 跳过按钮
          GestureDetector(
            onTap: _skip,
            child: const Text('跳过', style: TextStyles.textHint14),
          ),
        ],
      ),
    );
  }
}

/// 服务协议确认对话框（iOS 风格）
class _AgreementDialog extends StatelessWidget {
  final SplashViewModel viewModel;
  static const _privacyUrl =
      'https://vis.bmetech.com/standard/vis/page/organized/userPrivacyAgreement.html';

  const _AgreementDialog(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('服务协议与隐私政策'),
      content: RichText(
        text: TextSpan(
          text:
              "请你务必审慎阅读，充分理解\"服务协议\"和\"隐私政策\"各条款，包括但不限于:为了向你提供厂区环境监测，闭环处理等服务，我们需要收集你的设备信息，操作日志等个人信息。你可以在\"设置\"中 查看、变更、删除个人信息并管理你的授权。同时，我们接入了第三方推送服务，推送SDK可能会会以一定频率收集设备信息，具体内容详见隐私协议。",
          style: TextStyles.textDark,
          children: [
            const TextSpan(text: "你可以阅读", style: TextStyles.textDark),
            _buildLink(context, '《服务协议》', '服务协议'),
            const TextSpan(text: "和", style: TextStyles.textDark),
            _buildLink(context, '《隐私政策》', '隐私政策'),
            const TextSpan(
              text: "了解详细信息。如你同意，请点击\"同意\"开始接受我们的服务。",
              style: TextStyles.textDark,
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: false,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('不同意'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('同意并继续'),
        ),
      ],
    );
  }

  /// 构建协议链接
  TextSpan _buildLink(BuildContext context, String text, String title) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        color: AppColors.primaryLight,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          final encodedUrl = Uri.encodeComponent(_privacyUrl);
          context.push('${RouteName.web}?url=$encodedUrl&title=$title');
        },
    );
  }
}
