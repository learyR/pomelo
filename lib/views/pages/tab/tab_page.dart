import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/core/router/route_name.dart';
import 'package:pomelo/services/local_storage.dart';
import 'package:pomelo/services/network/interceptors/auth_interceptor.dart';
import 'package:pomelo/utils/dialog_util.dart';
import 'package:pomelo/utils/status_bar_util.dart';
import 'package:pomelo/utils/toast_util.dart';

import '../earn/earn_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

/// 全局登录过期通知函数（可以通过网络拦截器调用）
void notifyLoginExpired(BuildContext? context) {
  if (context != null && context.mounted) {
    _showLoginExpiredDialog(context);
  }
}

/// 显示登录过期对话框
Future<void> _showLoginExpiredDialog(BuildContext context) async {
  final shouldLogout = await DialogUtil.showConfirm(
    context,
    title: '登录过期',
    content: '您的登录已过期，请重新登录',
    confirmText: '确定',
    cancelText: '',
    barrierDismissible: false,
  );

  if (shouldLogout == true && context.mounted) {
    await _performLogout(context);
  }
}

/// 统一退出登录处理
Future<void> _performLogout(BuildContext context) async {
  try {
    // 清除Token
    await LocalStorage.removeToken();

    // 清除其他用户数据（如果需要）
    // await LocalStorage.clear();

    // 跳转到登录页
    if (context.mounted) {
      context.go(RouteName.login);
    }
  } catch (e) {
    // 即使出错也跳转到登录页
    if (context.mounted) {
      context.go(RouteName.login);
    }
  }
}

/// Tab页面
///
/// 主Tab页面，包含首页、赚取现金、个人中心三个tab
/// 处理返回键、登录过期对话框、统一退出登录
class TabPage extends ConsumerStatefulWidget {
  const TabPage({super.key});

  @override
  ConsumerState<TabPage> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<TabPage> {
  DateTime? _lastBackPressedTime;
  int _currentIndex = 0;

  /// Tab页面列表
  final List<Widget> _pages = const [
    HomePage(),
    EarnPage(),
    ProfilePage(),
  ];

  /// 底部导航项配置
  final List<_TabItem> _tabItems = const [
    _TabItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '限时秒杀',
    ),
    _TabItem(
      icon: Icons.monetization_on_outlined,
      activeIcon: Icons.monetization_on,
      label: '赚取现金',
    ),
    _TabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '个人中心',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupLoginExpiredCallback();
  }

  /// 设置登录过期回调
  void _setupLoginExpiredCallback() {
    // 设置全局登录过期回调，供网络拦截器使用
    setGlobalLoginExpiredCallback((_) {
      if (mounted) {
        notifyLoginExpired(context);
      }
    });
  }

  @override
  void dispose() {
    // 清除全局回调
    setGlobalLoginExpiredCallback(null);
    super.dispose();
  }

  /// 处理返回键
  Future<bool> _onWillPop() async {
    // 如果不在首页，切换到首页
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false; // 不退出应用
    }

    // 在首页时，双击返回键退出
    final now = DateTime.now();
    if (_lastBackPressedTime == null ||
        now.difference(_lastBackPressedTime!) > const Duration(seconds: 2)) {
      _lastBackPressedTime = now;
      ToastUtil.showWarning("再按一次退出应用");
      return false; // 不退出应用
    }

    return true; // 退出应用
  }

  /// 切换Tab
  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // 如果点击的是当前tab，可以执行刷新等操作
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarWrapper(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          if (!didPop) {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) {
              exit(0);
            }
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.errorLight,
              unselectedItemColor: AppColors.textMediumGray,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: _tabItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return BottomNavigationBarItem(
                  icon: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 24,
                  ),
                  label: item.label,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tab项数据模型
class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
