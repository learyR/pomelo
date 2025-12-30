# 基于属性的状态管理指南

本文档介绍如何使用 `SyncProperty` 和 `AsyncDataProperty` 来实现基于属性的状态管理，避免在 ViewModel 和 Page 中使用大量字符串 key。

## 目录

- [概述](#概述)
- [SyncProperty - 同步状态属性](#syncproperty---同步状态属性)
- [AsyncDataProperty - 异步数据属性](#asyncdataproperty---异步数据属性)
- [完整示例](#完整示例)
- [在 Page 中使用](#在-page-中使用)
- [优势对比](#优势对比)

## 概述

基于属性的状态管理方案让您可以直接在 ViewModel 中定义属性，这些属性自动具备状态管理能力。在 Page 中可以直接访问这些属性，无需使用字符串 key。

### 核心优势

✅ **类型安全**：IDE 自动补全和类型检查  
✅ **无需字符串 key**：属性名自动作为标识  
✅ **代码简洁**：直接访问属性，无需 getter/setter  
✅ **易于维护**：属性定义集中，便于管理  

## SyncProperty - 同步状态属性

### 基本使用

```dart
class UserViewModel extends BaseViewModel<User> {
  // 直接定义属性，自动具备状态管理能力
  late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
  late final language = SyncProperty<String>(this, 'language', defaultValue: 'zh_CN');
  late final selectedIndex = SyncProperty<int>(this, 'selectedIndex', defaultValue: 0);
  late final isExpanded = SyncProperty<bool>(this, 'isExpanded', defaultValue: false);
  
  // 使用属性
  void toggleNotification() {
    notification.value = !notification.value;  // 直接访问和设置
  }
  
  void toggleExpanded() {
    isExpanded.toggle();  // 布尔属性可以使用 toggle()
  }
  
  void changeLanguage(String lang) {
    language.value = lang;
  }
}
```

### 在 Page 中使用

```dart
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(userViewModelProvider.notifier);
    
    return Scaffold(
      body: Column(
        children: [
          // 直接使用属性，无需字符串 key
          SwitchListTile(
            title: const Text('通知'),
            value: viewModel.notification.value,  // 直接访问
            onChanged: (value) {
              viewModel.notification.value = value;  // 直接设置
            },
          ),
          ListTile(
            title: Text('语言: ${viewModel.language.value}'),
            onTap: () {
              viewModel.language.value = 'en_US';
            },
          ),
        ],
      ),
    );
  }
}
```

### API 参考

#### SyncProperty<T>

- `value` - 获取/设置值
- `toggle()` - 切换布尔值（仅适用于 bool 类型）
- `reset()` - 重置为默认值
- `hasValue` - 检查是否有值（非默认值）
- `key` - 获取键名（用于调试）

## AsyncDataProperty - 异步数据属性

### 基本使用

```dart
class HomeViewModel extends BaseViewModel<void> {
  final UserRepository _userRepository = UserRepository();
  final ProductRepository _productRepository = ProductRepository();
  
  // 直接定义属性，自动具备状态管理能力
  late final user = AsyncDataProperty<User>(this, 'user');
  late final products = AsyncDataProperty<List<Product>>(this, 'products');
  
  // 加载数据
  Future<void> loadUser() async {
    await user.load(() => _userRepository.getUser());
  }
  
  Future<void> loadProducts() async {
    await products.load(() => _productRepository.getProducts());
  }
  
  // 刷新数据（不显示加载状态）
  Future<void> refreshUser() async {
    await user.refresh(() => _userRepository.getUser(), showLoading: false);
  }
}
```

### 在 Page 中使用

```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    
    // 直接使用属性，无需字符串 key
    if (viewModel.user.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.user.hasError) {
      return Center(
        child: Text('错误: ${viewModel.user.error}'),
      );
    }
    
    final user = viewModel.user.value;  // 直接访问数据
    if (user == null) {
      return const Center(child: Text('暂无数据'));
    }
    
    return Center(child: Text('用户: ${user.name}'));
  }
}
```

### API 参考

#### AsyncDataProperty<T>

**加载方法：**
- `load(Future<T> Function() asyncAction, {...})` - 加载数据
- `refresh(Future<T> Function() asyncAction, {...})` - 刷新数据

**状态访问：**
- `value` - 获取/设置数据值
- `state` - 获取 AsyncValue 状态
- `isLoading` - 是否正在加载
- `hasData` - 是否有数据
- `hasError` - 是否有错误
- `error` - 获取错误信息

**状态控制：**
- `setLoading()` - 设置加载状态
- `setError(Object error, [StackTrace? stackTrace])` - 设置错误状态
- `clear()` - 清除数据

## 完整示例

### 综合使用示例

```dart
class DashboardViewModel extends BaseViewModel<void> {
  final UserRepository _userRepository = UserRepository();
  final ProductRepository _productRepository = ProductRepository();
  
  // 同步状态属性
  late final darkMode = SyncProperty<bool>(this, 'darkMode', defaultValue: false);
  late final theme = SyncProperty<String>(this, 'theme', defaultValue: 'light');
  late final soundEnabled = SyncProperty<bool>(this, 'soundEnabled', defaultValue: true);
  late final isRefreshing = SyncProperty<bool>(this, 'isRefreshing', defaultValue: false);
  late final selectedTabIndex = SyncProperty<int>(this, 'selectedTabIndex', defaultValue: 0);
  
  // 异步数据属性
  late final user = AsyncDataProperty<User>(this, 'user');
  late final products = AsyncDataProperty<List<Product>>(this, 'products');
  
  @override
  BaseViewModelState<void> build() {
    return BaseViewModelState.initial();
  }
  
  // 加载所有数据
  Future<void> loadDashboard() async {
    isRefreshing.value = true;
    try {
      await Future.wait([
        user.load(() => _userRepository.getUser(), showLoading: false),
        products.load(() => _productRepository.getProducts(), showLoading: false),
      ]);
    } finally {
      isRefreshing.value = false;
    }
  }
  
  // 切换深色模式
  void toggleDarkMode() {
    darkMode.toggle();
    theme.value = darkMode.value ? 'dark' : 'light';
  }
  
  // 切换标签页
  void switchTab(int index) {
    selectedTabIndex.value = index;
    switch (index) {
      case 0:
        if (user.value == null) {
          user.load(() => _userRepository.getUser());
        }
        break;
      case 1:
        if (products.value == null) {
          products.load(() => _productRepository.getProducts());
        }
        break;
    }
  }
}
```

### 在 Page 中使用

```dart
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(dashboardViewModelProvider.notifier);
    
    return Scaffold(
      body: Column(
        children: [
          // 使用同步状态
          TabBar(
            controller: TabController(
              length: 2,
              initialIndex: viewModel.selectedTabIndex.value,
            ),
            onTap: (index) => viewModel.switchTab(index),
            tabs: [
              Tab(text: '用户'),
              Tab(text: '商品'),
            ],
          ),
          
          // 使用异步数据
          Expanded(
            child: IndexedStack(
              index: viewModel.selectedTabIndex.value,
              children: [
                _buildUserTab(viewModel),
                _buildProductsTab(viewModel),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: viewModel.isRefreshing.value
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: () => viewModel.loadDashboard(),
              child: const Icon(Icons.refresh),
            ),
    );
  }
  
  Widget _buildUserTab(DashboardViewModel viewModel) {
    // 直接使用属性，无需字符串 key
    if (viewModel.user.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.user.hasError) {
      return Center(
        child: Text('错误: ${viewModel.user.error}'),
      );
    }
    
    final user = viewModel.user.value;
    return Center(child: Text('用户: ${user?.name ?? '暂无'}'));
  }
  
  Widget _buildProductsTab(DashboardViewModel viewModel) {
    if (viewModel.products.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final products = viewModel.products.value;
    if (products == null || products.isEmpty) {
      return const Center(child: Text('暂无商品'));
    }
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(products[index].name));
      },
    );
  }
}
```

## 优势对比

### 旧方式（字符串 key）

```dart
// ViewModel
class UserViewModel extends BaseViewModel<User> {
  bool get notification => sync.get<bool>('notification', false);
  set notification(bool value) => sync.set('notification', value);
  
  Future<void> loadUser() async {
    await asyncData.execute('user', () => userRepository.getUser());
  }
  
  User? get user => asyncData.get<User>('user');
}

// Page
final viewModel = ref.read(viewModelProvider.notifier);
final notification = viewModel.sync.get<bool>('notification', false);
viewModel.sync.set('notification', true);
final user = viewModel.asyncData.get<User>('user');
```

**问题：**
- ❌ 需要记住字符串 key
- ❌ 容易拼写错误
- ❌ IDE 无法自动补全
- ❌ 重构困难

### 新方式（属性定义）

```dart
// ViewModel
class UserViewModel extends BaseViewModel<User> {
  late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
  late final user = AsyncDataProperty<User>(this, 'user');
  
  Future<void> loadUser() async {
    await user.load(() => userRepository.getUser());
  }
}

// Page
final viewModel = ref.read(viewModelProvider.notifier);
viewModel.notification.value = true;  // 直接访问属性
final user = viewModel.user.value;  // 直接访问属性
```

**优势：**
- ✅ 类型安全，IDE 自动补全
- ✅ 无需记住字符串 key
- ✅ 重构友好
- ✅ 代码更简洁易读

## 最佳实践

### 1. 属性命名

✅ **推荐**：使用有意义的属性名
```dart
late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
late final user = AsyncDataProperty<User>(this, 'user');
```

❌ **不推荐**：使用无意义的名称
```dart
late final flag1 = SyncProperty<bool>(this, 'flag1', defaultValue: false);
late final data1 = AsyncDataProperty<User>(this, 'data1');
```

### 2. Key 命名

✅ **推荐**：key 使用属性名，保持一致
```dart
late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
```

❌ **不推荐**：key 和属性名不一致
```dart
late final notification = SyncProperty<bool>(this, 'notif', defaultValue: false);
```

### 3. 属性定义位置

✅ **推荐**：在 ViewModel 类顶部集中定义
```dart
class UserViewModel extends BaseViewModel<User> {
  // 同步状态属性
  late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
  late final language = SyncProperty<String>(this, 'language', defaultValue: 'zh_CN');
  
  // 异步数据属性
  late final user = AsyncDataProperty<User>(this, 'user');
  
  // 其他代码...
}
```

### 4. 默认值设置

✅ **推荐**：为所有属性设置合理的默认值
```dart
late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
late final selectedIndex = SyncProperty<int>(this, 'selectedIndex', defaultValue: 0);
```

## 总结

基于属性的状态管理方案提供了：

1. **类型安全**：编译时类型检查，IDE 自动补全
2. **代码简洁**：直接访问属性，无需字符串 key
3. **易于维护**：属性定义集中，便于管理
4. **重构友好**：重命名属性时自动更新所有引用

通过使用 `SyncProperty` 和 `AsyncDataProperty`，可以大大简化状态管理的代码，提高开发效率和代码质量。

