# 路由配置说明

## RouteFactory 使用指南

`RouteFactory` 用于简化路由创建和统一处理路由认证。

### 基本用法

#### 1. 创建公开路由（无需认证）

```dart
RouteFactory.public(
  path: RouteName.login,
  name: 'login',
  builder: (context, state) => const LoginPage(),
  transitionType: RouteTransitionType.slideRight,
)
```

#### 2. 创建需要认证的路由

```dart
RouteFactory.authenticated(
  path: RouteName.profile,
  name: 'profile',
  builder: (context, state) => const ProfilePage(),
  transitionType: RouteTransitionType.fade,
)
```

当用户未登录时，会自动重定向到登录页，并携带原始路由路径作为 `redirect` 参数。

#### 3. 创建带参数的路由

```dart
RouteFactory.withParams(
  path: '${RouteName.productDetail}/:id',
  name: 'productDetail',
  builder: (context, state) {
    final productId = state.pathParameters['id'] ?? '';
    return ProductDetailPage(productId: productId);
  },
  requiresAuth: false, // 或 true
  transitionType: RouteTransitionType.slideBottom,
)
```

#### 4. 创建 ShellRoute（底部导航栏容器）

```dart
RouteFactory.shell(
  builder: (context, state, child) => MainNavigationWrapper(child: child),
  routes: [
    RouteFactory.public(
      path: RouteName.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    // ... 其他路由
  ],
)
```

### 登录后跳转回原页面

在登录页面，可以使用 `RouteAuthGuard.getRedirectRoute()` 获取原始路由：

```dart
// 在登录成功后
final redirectRoute = RouteAuthGuard.getRedirectRoute(state);
if (redirectRoute != null) {
  context.go(redirectRoute);
} else {
  context.go(RouteName.home);
}
```

### 转场动画类型

- `fade` - 淡入淡出
- `slideRight` - 从右侧滑入（默认）
- `slideLeft` - 从左侧滑入
- `slideBottom` - 从底部滑入
- `slideTop` - 从顶部滑入
- `scale` - 缩放
- `scaleFade` - 缩放+淡入
- `none` - 无动画

### 在 app_router.dart 中使用

```dart
static final GoRouter router = GoRouter(
  routes: [
    // 使用 RouteFactory 创建路由
    RouteFactory.public(
      path: RouteName.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    
    RouteFactory.authenticated(
      path: RouteName.profile,
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
```

## RouteAuthGuard 使用指南

`RouteAuthGuard` 提供了路由认证相关的工具方法：

```dart
// 检查路由是否需要认证
bool needsAuth = RouteAuthGuard.requiresAuth('/profile');

// 检查用户是否已认证
bool isAuth = RouteAuthGuard.isAuthenticated();

// 获取登录后应该跳转的路由
String? redirect = RouteAuthGuard.getRedirectRoute(state);

// 检查并处理认证（返回重定向路径或 null）
String? redirectPath = RouteAuthGuard.checkAuth('/cart');
```

