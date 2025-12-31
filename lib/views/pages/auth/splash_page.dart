import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/utils/image_util.dart';
import 'package:pomelo/utils/update_util.dart';
import 'package:pomelo/viewmodels/splash_viewmodel.dart';

import '../../../utils/logger_util.dart';
import '../../../viewmodels/provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    // 页面加载后开始初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  /// 初始化应用
  Future<void> _initialize() async {
    final startTime = DateTime.now();
    final viewModel = ref.read(splashProvider.notifier);
    // 执行初始化
    await viewModel.initialize();
    if (!mounted) return;
    // 确保闪屏页至少显示 1.5 秒，提升用户体验
    final elapsed = DateTime.now().difference(startTime);
    const minDisplayDuration = Duration(milliseconds: 1500);
    if (elapsed < minDisplayDuration) {
      await Future.delayed(minDisplayDuration - elapsed);
    }
    if (!mounted) return;
    // 检查是否需要显示更新对话框
    if (viewModel.shouldShowUpdateDialog()) {
      final updateInfo = viewModel.getUpdateInfo();
      if (updateInfo != null) {
        await _showUpdateDialog(context, updateInfo, viewModel);
      }
    }
    // 导航到目标页面
    if (mounted && !_hasNavigated) {
      _navigateToTarget(context, viewModel);
    }
  }

  /// 显示更新对话框
  Future<void> _showUpdateDialog(
    BuildContext context,
    UpdateInfo updateInfo,
    SplashViewModel viewModel,
  ) async {
    // 处理更新（显示对话框）
    await UpdateUtil.handleUpdate(context, updateInfo);

    // 如果是强制更新，不继续导航（等待用户更新）
    if (updateInfo.forceUpdate) {
      return;
    }

    // 更新对话框关闭后，继续导航
    if (mounted && !_hasNavigated) {
      _navigateToTarget(context, viewModel);
    }
  }

  /// 导航到目标页面
  void _navigateToTarget(BuildContext context, SplashViewModel viewModel) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    final targetRoute = viewModel.getTargetRoute();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.go(targetRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 禁止返回
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            ImageUtil.buildImage(AppImages.bgSplash),
          ],
        ),
      ),
    );
  }
}
