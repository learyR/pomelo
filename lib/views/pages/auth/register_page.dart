import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/utils/status_bar_util.dart';
import 'package:pomelo/viewmodels/login_viewmodel.dart';

import '../../../viewmodels/provider/provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/helper/view_helper.dart';

/// 注册页 Provider
final registerProvider = createProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);

/// 注册页
///
/// 支持手机号 + 验证码 + 密码注册，邀请码可选
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watchViewModel(registerProvider);
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
                      Gaps.vGap8,
                      _buildPhoneField(viewModel),
                      Gaps.vGap24,
                      _buildVerificationCodeField(viewModel),
                      Gaps.vGap24,
                      _buildPasswordField(viewModel),
                      Gaps.vGap24,
                      _buildInvitationCodeField(viewModel),
                      Gaps.vGap32,
                      _buildRegisterButton(viewModel),
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

  /// 构建手机号输入框
  Widget _buildPhoneField(LoginViewModel viewModel) {
    final error = viewModel.accountError.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('手机号', style: TextStyles.textDark),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.accountController,
          keyboardType: TextInputType.phone,
          hintText: '请输入手机号',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.hGap12,
              const Icon(CupertinoIcons.phone,
                  color: AppColors.errorLight, size: 20),
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
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: canSendCode && !isLoading ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                canSendCode ? AppColors.textDarkGray : AppColors.textMediumGray,
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

  /// 构建密码输入框
  Widget _buildPasswordField(LoginViewModel viewModel) {
    final error = viewModel.passwordError.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('密码设置', style: TextStyles.textDark),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.passwordController,
          obscureText: !viewModel.isPasswordVisible.value,
          hintText: '请输入密码',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.hGap12,
              const Icon(CupertinoIcons.lock,
                  color: AppColors.textMediumGray, size: 20),
              Gaps.hGap12,
              Container(width: 1, height: 20, color: AppColors.borderGray),
              Gaps.hGap12,
            ],
          ),
          suffixIcon: viewModel.isPasswordVisible.value
              ? CupertinoIcons.eye
              : CupertinoIcons.eye_slash,
          onSuffixIconTap: viewModel.togglePasswordVisibility,
          borderColor:
              error.isNotEmpty ? AppColors.error : AppColors.borderGray,
          focusedBorderColor: AppColors.errorLight,
          errorBorderColor: AppColors.error,
          textStyle: TextStyles.text,
          onChanged: (value) {
            if (error.isNotEmpty) {
              viewModel.validatePassword(value);
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

  /// 构建邀请码输入框
  Widget _buildInvitationCodeField(LoginViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.square_grid_2x2,
              color: AppColors.textMediumGray,
              size: 16,
            ),
            Gaps.hGap4,
            const Text('输入邀请码', style: TextStyles.textDark),
          ],
        ),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.invitationCodeController,
          hintText: '请输入邀请码（可选）',
          borderColor: AppColors.borderGray,
          focusedBorderColor: AppColors.errorLight,
          textStyle: TextStyles.text,
        ),
        Gaps.vGap4,
        const Text(
          '(输入邀请码可领取红包 可跳过)',
          style: TextStyle(
            color: AppColors.textLightGray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// 构建注册按钮
  Widget _buildRegisterButton(LoginViewModel viewModel) {
    final isLoading = viewModel.isLoading.value;
    return AppButton(
      text: '注册',
      onPressed: isLoading ? null : () => _handleRegister(viewModel),
      isFullWidth: true,
      isLoading: isLoading,
      gradient: const LinearGradient(
        colors: [AppColors.errorLight, AppColors.errorPink],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.white,
      size: AppButtonSize.medium,
      boxShadow: [
        BoxShadow(
          color: AppColors.errorLight.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
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
            text: '请仔细阅读',
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
                      '${RouteName.web}?url=$encodedUrl&title=${Uri.encodeComponent('购啦隐私政策')}',
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 处理注册
  Future<void> _handleRegister(LoginViewModel viewModel) async {
    final success = await viewModel.register();
    if (success && mounted) {
      context.go(RouteName.tab);
    }
  }
}
