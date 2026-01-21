import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/utils/image_util.dart';
import 'package:pomelo/utils/status_bar_util.dart';
import 'package:pomelo/viewmodels/login_viewmodel.dart';

import '../../../viewmodels/provider/provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/common.dart';
import '../../widgets/helper/view_helper.dart';

/// 验证码登录页 Provider
final verifyProvider = createProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);

/// 验证码登录页
///
/// 支持手机号验证码登录、第三方登录（微信、Apple ID）
class VerifyPage extends ConsumerStatefulWidget {
  const VerifyPage({super.key});

  @override
  ConsumerState<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends ConsumerState<VerifyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watchViewModel(verifyProvider);
    return StatusBarWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 顶部关闭按钮
              _buildCloseButton(),
              // 滚动内容
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAppTitle(),
                      Gaps.vGap40,
                      _buildAccountField(viewModel),
                      Gaps.vGap24,
                      _buildVerificationCodeField(viewModel),
                      Gaps.vGap32,
                      _buildLoginButton(viewModel),
                      Gaps.vGap24,
                      _buildOtherOptions(),
                      Gaps.vGap32,
                      _buildOtherLoginMethods(viewModel),
                      Gaps.vGap24,
                      _buildFooter(context),
                      Gaps.vGap32,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建关闭按钮
  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: AppColors.backgroundGray, shape: BoxShape.circle),
            child: const Icon(CupertinoIcons.xmark,
                size: 18, color: AppColors.textDark),
          ),
        ),
      ),
    );
  }

  /// 构建应用标题
  Widget _buildAppTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '购啦APP',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.errorLight),
        ),
        Gaps.vGap8,
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(2)),
        ),
      ],
    );
  }

  /// 构建账号输入框
  Widget _buildAccountField(LoginViewModel viewModel) {
    final error = viewModel.accountError.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('账号', style: TextStyles.textDark),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.accountController,
          keyboardType: TextInputType.phone,
          hintText: '请输入手机号',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.hGap12,
              const Icon(CupertinoIcons.person,
                  color: AppColors.textMediumGray, size: 20),
              Gaps.hGap12,
              Container(width: 1, height: 20, color: AppColors.borderGray),
              Gaps.hGap12,
            ],
          ),
          borderColor: error.isNotEmpty
              ? AppColors.error
              : (viewModel.accountController.text.isNotEmpty
                  ? AppColors.errorLight
                  : AppColors.borderGray),
          focusedBorderColor: AppColors.errorLight,
          errorBorderColor: AppColors.error,
          textStyle: TextStyles.text,
          onChanged: (value) {
            if (error.isNotEmpty) {
              viewModel.validateAccount(value);
            }
          },
        ),
        if (error.isNotEmpty) ...[
          Gaps.vGap4,
          Text(
            error,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  /// 构建发送验证码按钮
  Widget _buildSendCodeButton({
    required int countdown,
    required bool canSendCode,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: canSendCode && !isLoading ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: canSendCode ? AppColors.textDarkGray : AppColors.textMediumGray,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            countdown > 0 ? '${countdown}s' : '发送验证码',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建验证码输入框
  Widget _buildVerificationCodeField(LoginViewModel viewModel) {
    final error = viewModel.verificationCodeError.value;
    final countdown = viewModel.countdownSeconds.value;
    final canSendCode = countdown == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('验证码', style: TextStyles.textDark),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.verificationCodeController,
          keyboardType: TextInputType.number,
          hintText: '请输入验证码',
          maxLength: 6,
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.hGap12,
              const Icon(
                CupertinoIcons.mail,
                color: AppColors.textMediumGray,
                size: 20,
              ),
              Gaps.hGap12,
              Container(
                width: 1,
                height: 20,
                color: AppColors.borderGray,
              ),
              Gaps.hGap12,
            ],
          ),
          suffix: _buildSendCodeButton(
            countdown: countdown,
            canSendCode: canSendCode,
            isLoading: viewModel.isLoading.value,
            onTap: () => viewModel.sendVerificationCode(),
          ),
          borderColor:
              error.isNotEmpty ? AppColors.error : AppColors.borderGray,
          focusedBorderColor: AppColors.errorLight,
          errorBorderColor: AppColors.error,
          textStyle: TextStyles.text,
          onChanged: (value) {
            if (error.isNotEmpty) {
              viewModel.validateVerificationCode(value);
            }
          },
        ),
        if (error.isNotEmpty) ...[
          Gaps.vGap4,
          Text(
            error,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  /// 构建登录按钮
  Widget _buildLoginButton(LoginViewModel viewModel) {
    final isLoading = viewModel.isLoading.value;
    return AppButton(
      text: '登录',
      onPressed: isLoading ? null : () => _handleLogin(viewModel),
      isFullWidth: true,
      isLoading: isLoading,
      gradient: const LinearGradient(
        colors: [AppColors.errorLight, AppColors.errorPink],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      textColor: AppColors.white,
      borderRadius: 25,
      height: 50,
      boxShadow: [
        BoxShadow(
          color: AppColors.errorLight.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// 构建其他登录选项
  Widget _buildOtherOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // 跳转到密码登录页
            context.pop();
          },
          child: const Text(
            '忘记密码',
            style: TextStyle(
              color: AppColors.textMediumGray,
              fontSize: 14,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push(RouteName.register);
          },
          child: const Text(
            '新用户注册',
            style: TextStyle(
              color: AppColors.textMediumGray,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建其他登录方式
  Widget _buildOtherLoginMethods(LoginViewModel viewModel) {
    final isLoading = viewModel.isLoading.value;
    return Column(
      children: [
        // 分隔线
        Row(
          children: [
            Expanded(
              child: Container(height: 1, color: AppColors.borderGray),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyles.textHint14,
              ),
            ),
            Expanded(
              child: Container(height: 1, color: AppColors.borderGray),
            ),
          ],
        ),
        Gaps.vGap32,
        // 微信和Apple ID登录
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildThirdPartyLoginButton(
              icon: AppImages.iconWechat,
              label: '微信登陆',
              color: const Color(0xFF07C160),
              onTap: isLoading ? null : () => viewModel.loginWithWeChat(),
            ),
            Gaps.hGap40,
            _buildThirdPartyLoginButton(
              icon: AppImages.iconApple,
              label: 'IPhone ID',
              color: AppColors.textPrimary,
              onTap: isLoading ? null : () => viewModel.loginWithApple(),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建第三方登录按钮
  Widget _buildThirdPartyLoginButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return  GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: ImageUtil.buildImage(icon),
          ),
          Gaps.vGap8,
          Text(label, style: TextStyles.textHint14),
        ],
      ),
    );
  }

  /// 构建底部提示和隐私政策
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          '未注册的手机号验证后将自动创建账号',
          style: TextStyles.textHint14,
          textAlign: TextAlign.center,
        ),
        Gaps.vGap8,
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '登录及代表同意',
            style: TextStyles.textHint14,
            children: [
              TextSpan(
                text: '《购啦隐私政策》',
                style: const TextStyle(
                  color: AppColors.errorLight,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final encodedUrl = Uri.encodeComponent(
                        'https://vis.bmetech.com/standard/vis/page/organized/userPrivacyAgreement.html');
                    context.push(
                      '${RouteName.web}?url=$encodedUrl&title=${'购啦隐私政策'}',
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 处理登录
  Future<void> _handleLogin(LoginViewModel viewModel) async {
    final success = await viewModel.loginWithVerificationCode();
    if (success && mounted) {
      context.go(RouteName.tab);
    }
  }
}
