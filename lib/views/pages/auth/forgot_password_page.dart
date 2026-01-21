import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/utils/status_bar_util.dart';
import 'package:pomelo/viewmodels/login_viewmodel.dart';

import '../../../viewmodels/provider/provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/helper/view_helper.dart';
import 'login_page.dart'; // 导入 loginProvider

/// 忘记密码页
///
/// 支持通过手机号和验证码重置密码
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watchViewModel(loginProvider);
    return StatusBarWrapper(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部关闭按钮
                _buildCloseButton(),
                // 滚动内容
                _buildAppTitle(),
                Gaps.vGap8,
                _buildPhoneField(viewModel),
                Gaps.vGap24,
                _buildVerificationCodeField(viewModel),
                Gaps.vGap24,
                _buildPasswordField(viewModel),
                Expanded(child: Gaps.vGap10),
                _buildConfirmButton(viewModel),
                Gaps.vGap80,
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.backgroundGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: AppColors.textDark,
            ),
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
            color: AppColors.errorLight,
          ),
        ),
        Gaps.vGap8,
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(2),
          ),
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
              const Icon(
                CupertinoIcons.phone,
                color: AppColors.errorLight,
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
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: canSendCode && !isLoading ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: canSendCode
                ? AppColors.textMediumGray
                : AppColors.backgroundDisabled,
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
              const Icon(CupertinoIcons.mail,
                  color: AppColors.textMediumGray, size: 20),
              Gaps.hGap12,
              Container(width: 1, height: 20, color: AppColors.borderGray),
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
        const Text('重新设置密码', style: TextStyles.textDark),
        Gaps.vGap8,
        AppTextField(
          controller: viewModel.passwordController,
          obscureText: !viewModel.isPasswordVisible.value,
          hintText: '请输入新密码',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.hGap12,
              const Icon(
                CupertinoIcons.lock,
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

  /// 构建确认按钮
  Widget _buildConfirmButton(LoginViewModel viewModel) {
    final isLoading = viewModel.isLoading.value;
    return AppButton(
      text: '确认',
      onPressed: isLoading ? null : () => _handleResetPassword(viewModel),
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

  /// 处理重置密码
  Future<void> _handleResetPassword(LoginViewModel viewModel) async {
    final success = await viewModel.resetPassword();
    if (success && mounted) {
      // 显示成功提示并返回登录页
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('密码重置成功，请使用新密码登录'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      // 延迟返回，让用户看到成功提示
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.pop();
        }
      });
    }
  }
}
