import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_name.dart';
import 'route_observer.dart';
import 'route_transitions.dart';
import 'route_factory.dart';
import '../../views/pages/auth/login_page.dart';

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
      GoRoute(
        path: RouteName.splash,
        name: 'splash',
        pageBuilder: (context, state) => RouteTransitions.fade(
          const LoginPage(), // 暂时使用 LoginPage，后续可替换为 SplashPage
          duration: const Duration(milliseconds: 300),
        ),
      ),

      // 底部导航栏路由容器
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [
          // 首页
          GoRoute(
            path: RouteName.home,
            name: 'home',
            pageBuilder: (context, state) => RouteTransitions.fade(
              const PlaceholderPage(title: '首页'), // 占位页面，后续替换
              duration: const Duration(milliseconds: 300),
            ),
          ),

          // 分类页
          GoRoute(
            path: RouteName.category,
            name: 'category',
            pageBuilder: (context, state) => RouteTransitions.fade(
              const PlaceholderPage(title: '分类'),
              duration: const Duration(milliseconds: 300),
            ),
          ),

          // 购物车
          GoRoute(
            path: RouteName.cart,
            name: 'cart',
            pageBuilder: (context, state) => RouteTransitions.fade(
              const PlaceholderPage(title: '购物车'),
              duration: const Duration(milliseconds: 300),
            ),
          ),

          // 个人中心
          GoRoute(
            path: RouteName.profile,
            name: 'profile',
            pageBuilder: (context, state) => RouteTransitions.fade(
              const PlaceholderPage(title: '我的'),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),

      // 认证相关路由（无底部导航）
      GoRoute(
        path: RouteName.login,
        name: 'login',
        pageBuilder: (context, state) => RouteTransitions.slideRight(
          const LoginPage(),
          duration: const Duration(milliseconds: 300),
        ),
      ),

      GoRoute(
        path: RouteName.register,
        name: 'register',
        pageBuilder: (context, state) => RouteTransitions.slideRight(
          const PlaceholderPage(title: '注册'),
          duration: const Duration(milliseconds: 300),
        ),
      ),

      // 其他页面路由（无底部导航）
      GoRoute(
        path: '${RouteName.productDetail}/:id',
        name: 'productDetail',
        pageBuilder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return RouteTransitions.slideBottom(
            PlaceholderPage(title: '商品详情: $productId'),
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
    ],
    
    // 路由重定向（可用于登录校验等）
    redirect: (context, state) {
      // 示例：如果用户未登录，重定向到登录页
      // final route = state.uri.path;
      // final isLoggedIn = LocalStorage.getToken() != null;
      // if (RouteName.requiresAuth(route) && !isLoggedIn) {
      //   return RouteName.login;
      // }
      
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
