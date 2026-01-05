import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomelo/core/router/route_factory.dart';
import 'package:pomelo/services/local_storage.dart';
import 'package:pomelo/views/pages/auth/login_page.dart';
import 'package:pomelo/views/pages/auth/splash_page.dart';
import 'package:pomelo/views/pages/auth/web_page.dart';
import 'route_name.dart';
import 'route_observer.dart';

/// 路由配置
class AppRouter {
  AppRouter._(); // 私有构造函数，防止实例化

  /// GoRouter 实例
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splash,
    debugLogDiagnostics: true,
    observers: [routeObserver],
    routes: [
      // 启动页（无底部导航）
      RF.fade(
        path: RouteName.splash,
        name: 'splash',
        child: const SplashPage(),
      ),

      // 认证相关路由（无底部导航）
      RF.slideBottom(
        path: RouteName.login,
        name: 'login',
        child: const LoginPage(),
      ),

      // 底部导航栏路由容器
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [
          // 首页
          RF.fade(
            path: RouteName.home,
            name: 'home',
            child: const PlaceholderPage(title: '首页'),
          ),

          // 分类页
          RF.fade(
            path: RouteName.category,
            name: 'category',
            child: const PlaceholderPage(title: '分类'),
          ),

          // 购物车
          RF.fade(
            path: RouteName.cart,
            name: 'cart',
            child: const PlaceholderPage(title: '购物车'),
          ),

          // 个人中心
          RF.fade(
            path: RouteName.profile,
            name: 'profile',
            child: const PlaceholderPage(title: '我的'),
          ),
        ],
      ),

      // WebView 页面
      RF.slideRightBuilder(
        path: RouteName.web,
        name: 'web',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? '';
          final title = state.uri.queryParameters['title'];
          return WebPage(url: url, title: title);
        },
      ),
    ],

    // 路由重定向（用于登录校验）
    redirect: (context, state) {
      final route = state.uri.path;

      // 如果已经在登录页或启动页，不需要重定向
      if (route == RouteName.login || route == RouteName.splash) {
        return null;
      }

      // 检查是否需要登录认证
      final isLoggedIn = LocalStorage.getToken() != null;
      if (RouteName.requiresAuth(route) && !isLoggedIn) {
        // 保存原始路由路径，登录后可以返回
        final redirectUri = state.uri;
        return '${RouteName.login}?redirect=${Uri.encodeComponent(redirectUri.toString())}';
      }

      return null; // 不重定向
    },

    // 错误页面
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '页面未找到: ${state.uri.path}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteName.home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// 主导航包装器（底部导航栏）
class MainNavigationWrapper extends StatefulWidget {
  final Widget child;

  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  /// 底部导航项配置
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      activeIcon: Icons.home,
      label: '首页',
      route: RouteName.home,
    ),
    NavigationItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      label: '分类',
      route: RouteName.category,
    ),
    NavigationItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: '购物车',
      route: RouteName.cart,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '我的',
      route: RouteName.profile,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();
  }

  /// 更新当前选中的索引
  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    final index = _navigationItems.indexWhere(
      (item) => item.route == location,
    );
    if (index != -1 && index != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = index;
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  /// 处理底部导航栏点击
  void _onItemTapped(int index) {
    if (index == _currentIndex) {
      // 如果点击的是当前页，可以执行刷新等操作
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    final route = _navigationItems[index].route;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: _navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _currentIndex;

          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.activeIcon : item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

/// 导航项数据模型
class NavigationItem {
  /// 默认图标
  final IconData icon;

  /// 选中时的图标
  final IconData activeIcon;

  /// 标签文本
  final String label;

  /// 路由路径
  final String route;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// 占位页面（用于开发阶段的页面占位）
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '页面开发中...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
