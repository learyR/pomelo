import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/utils/logger_util.dart';
import 'package:pomelo/viewmodels/login_viewmodel.dart';

import '../../../viewmodels/provider/provider.dart';
import '../../widgets/common/common.dart';
import '../../widgets/helper/view_helper.dart';

/// 登录页 Provider
final loginProvider = createProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);

/// 登录页
///
/// 支持账号密码登录、验证码登录、第三方登录（微信、Apple ID）
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    // 预填充账号（可选，用于测试）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(loginProvider.notifier);
      if (viewModel.accountController.text.isEmpty) {
        viewModel.accountController.text = '17723848818';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final viewModel = ref.read(loginProvider.notifier);

    final accountError = state.syncStates['accountError'] as String?;
    final passwordError = state.syncStates['passwordError'] as String?;
    final isLoading = state.syncStates['isLoading'] as bool? ?? false;
    final isPasswordVisible =
        state.syncStates['isPasswordVisible'] as bool? ?? false;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部关闭按钮
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 0),
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        size: 28,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 应用标题
                _buildAppTitle(),

                const SizedBox(height: 60),

                // 账号输入框
                _buildAccountField(viewModel, accountError),

                const SizedBox(height: 24),

                // 密码输入框
                _buildPasswordField(
                  viewModel,
                  passwordError,
                  isPasswordVisible,
                ),

                const SizedBox(height: 32),

                // 登录按钮
                _buildLoginButton(viewModel, isLoading),

                const SizedBox(height: 24),

                // 其他登录选项
                _buildOtherOptions(),

                const SizedBox(height: 40),

                // 其他登录方式
                _buildOtherLoginMethods(viewModel, isLoading),

                const SizedBox(height: 24),

                // 底部提示和隐私政策
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建应用标题
  Widget _buildAppTitle() {
    return Column(
      children: [
        const Text(
          '购啦APP',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.errorLight,
          ),
        ),
        const SizedBox(height: 4),
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

  /// 构建账号输入框
  Widget _buildAccountField(LoginViewModel viewModel, String? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '账号',
          style: TextStyles.textDark,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: viewModel.accountController,
          keyboardType: TextInputType.phone,
          hintText: '请输入手机号',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              const Icon(
                CupertinoIcons.person,
                color: AppColors.textMediumGray,
                size: 20,
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 20,
                color: AppColors.borderGray,
              ),
              const SizedBox(width: 12),
            ],
          ),
          borderColor: error != null
              ? AppColors.error
              : (viewModel.accountController.text.isNotEmpty
                  ? AppColors.errorLight
                  : AppColors.borderGray),
          focusedBorderColor: AppColors.errorLight,
          errorBorderColor: AppColors.error,
          textStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          onChanged: (value) {
            if (error != null) {
              viewModel.validateAccount(value);
            }
          },
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  /// 构建密码输入框
  Widget _buildPasswordField(
    LoginViewModel viewModel,
    String? error,
    bool isPasswordVisible,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '密码',
          style: TextStyles.textDark,
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: viewModel.passwordController,
          obscureText: !isPasswordVisible,
          hintText: '请输入密码',
          prefix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              const Icon(
                CupertinoIcons.lock,
                color: AppColors.textMediumGray,
                size: 20,
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 20,
                color: AppColors.borderGray,
              ),
              const SizedBox(width: 12),
            ],
          ),
          suffixIcon:
              isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          onSuffixIconTap: viewModel.togglePasswordVisibility,
          borderColor: error != null ? AppColors.error : AppColors.borderGray,
          focusedBorderColor: AppColors.errorLight,
          errorBorderColor: AppColors.error,
          textStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          onChanged: (value) {
            if (error != null) {
              viewModel.validatePassword(value);
            }
          },
          onSubmitted: (_) => _handleLogin(viewModel),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  /// 构建登录按钮
  Widget _buildLoginButton(LoginViewModel viewModel, bool isLoading) {
    return AppButton(
      text: '登录',
      onPressed: isLoading ? null : () => _handleLogin(viewModel),
      isFullWidth: true,
      isLoading: isLoading,
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.white,
      borderRadius: 8,
      size: AppButtonSize.large,
    );
  }

  /// 构建其他登录选项
  Widget _buildOtherOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // TODO: 跳转到验证码登录页
            LoggerUtil.info('验证码登录');
          },
          child: const Text(
            '验证码登录',
            style: TextStyle(
              color: AppColors.textMediumGray,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          children: [
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
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                context.push(RouteName.forgotPassword);
              },
              child: const Text(
                '忘记密码',
                style: TextStyle(
                  color: AppColors.textMediumGray,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建其他登录方式
  Widget _buildOtherLoginMethods(LoginViewModel viewModel, bool isLoading) {
    return Column(
      children: [
        // 分隔线
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.borderGray,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyles.textHint14,
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.borderGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // 微信和Apple ID登录
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildThirdPartyLoginButton(
              icon: CupertinoIcons.chat_bubble_2,
              label: '微信登陆',
              color: const Color(0xFF07C160),
              onTap: isLoading ? null : () => viewModel.loginWithWeChat(),
            ),
            const SizedBox(width: 48),
            _buildThirdPartyLoginButton(
              icon: CupertinoIcons.app_badge,
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
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyles.textHint14,
          ),
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
        ),
        const SizedBox(height: 8),
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
    final success = await viewModel.login();
    if (success && mounted) {
      final targetRoute = viewModel.getTargetRoute();
      context.go(targetRoute);
    }
  }
}
