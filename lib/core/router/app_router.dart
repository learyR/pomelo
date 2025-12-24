import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../views/pages/auth/login_page.dart';

/// 路由配置
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      // 底部导航栏路由
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [],
      ),
      // 认证相关路由
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}

/// 主导航包装器（底部导航栏）
class MainNavigationWrapper extends StatefulWidget {
  final Widget child;

  const MainNavigationWrapper({super.key, required this.child});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.home,
      label: '首页',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.category,
      label: '分类',
      route: '/category',
    ),
    NavigationItem(
      icon: Icons.shopping_cart,
      label: '购物车',
      route: '/cart',
    ),
    NavigationItem(
      icon: Icons.person,
      label: '我的',
      route: '/profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    // 检查当前路由，更新选中索引
    final location = GoRouterState.of(context).uri.path;
    final index = _items.indexWhere((item) => item.route == location);
    if (index != -1 && index != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentIndex = index;
        });
      });
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
