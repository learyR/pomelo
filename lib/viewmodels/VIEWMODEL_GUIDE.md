# ViewModel 开发指南

本文档说明如何使用 BaseViewModel 和统一的 Provider 创建方法，以及如何创建新的 ViewModel。

## 目录

- [核心原则](#核心原则)
- [统一接口](#统一接口)
- [创建 ViewModel](#创建-viewmodel)
- [创建 Provider](#创建-provider)
- [使用示例](#使用示例)
- [最佳实践](#最佳实践)

## 核心原则

**所有 ViewModel 必须继承自 BaseViewModel 或其子类**

项目中的 ViewModel 应该继承以下基类之一：

1. **BaseViewModel<T>** - 同时管理异步业务和同步状态
2. **SyncViewModel** - 仅管理同步状态（开关、选中状态等）
3. **AsyncViewModel<T>** - 仅管理异步业务（接口请求、耗时操作）

## 统一接口

### 1. 统一的 execute 方法

所有 ViewModel 都提供统一的 `execute()` 方法，自动判断是否更新状态。

#### BaseViewModel 和 SyncViewModel 的 execute 方法

```dart
Future<R> execute<R>(
  Future<R> Function() asyncAction, {
  bool? updateState,        // 是否更新状态，默认 true
  void Function(R data)? onSuccess,
  void Function(Object error, StackTrace? stackTrace)? onError,
  bool showLoading = true,  // 是否显示加载状态
})
```

#### AsyncViewModel 的 execute 方法

```dart
Future<R> execute<R>(
  Future<R> Function() asyncAction, {
  bool? updateState,        // 是否更新状态，默认 true
  void Function(R data)? onSuccess,
  void Function(Object error, StackTrace? stackTrace)? onError,
})
```

#### 使用规则

- **更新状态的操作**：返回类型是 ViewModel 的数据类型 `T`，会自动更新状态
  ```dart
  await execute(() => loadUserData());  // 自动更新状态
  ```

- **不更新状态的操作**：返回类型不是 `T`，或明确设置 `updateState: false`
  ```dart
  final isValid = await execute(() => validateData(), updateState: false);
  ```

### 2. 统一的 createProvider 方法

所有 Provider 都使用统一的 `createProvider()` 方法创建，自动判断 ViewModel 类型。

```dart
dynamic createProvider<T, U>(
  T Function() create, {
  String? name,
})
```

支持的 ViewModel 类型：
- `BaseViewModel<T>` → `NotifierProvider`
- `SyncViewModel` → `NotifierProvider`
- `AsyncViewModel<T>` → `AsyncNotifierProvider`

## 创建 ViewModel

### 1. 继承 BaseViewModel（推荐）

适用于需要同时管理异步业务和同步状态的场景。

```dart
import 'package:your_app/viewmodels/base_model/base_viewmodel.dart';

class UserViewModel extends BaseViewModel<User> {
  final UserRepository _repository = UserRepository();
  
  @override
  BaseViewModelState<User> build() {
    return BaseViewModelState.initial();
  }
  
  // 加载用户数据（更新状态）
  Future<void> loadUser(String userId) async {
    await execute(() => _repository.getUser(userId));
  }
  
  // 验证用户数据（不更新状态）
  Future<bool> validateUser(User user) async {
    return await execute(
      () => _repository.validateUser(user),
      updateState: false,
    );
  }
  
  // 切换通知开关（同步状态）
  void toggleNotification(bool enabled) {
    updateSyncState('notification', enabled);
  }
  
  // 获取通知开关状态
  bool get isNotificationEnabled => 
      getSyncState<bool>('notification') ?? false;
}
```

### 2. 继承 SyncViewModel

适用于只需要管理同步状态的场景。

```dart
import 'package:your_app/viewmodels/base_model/base_viewmodel.dart';

class SettingsViewModel extends SyncViewModel {
  @override
  BaseViewModelState<void> build() {
    return BaseViewModelState.initial()
        .copyWithSyncState('darkMode', false);
  }
  
  // 切换深色模式
  void toggleDarkMode() {
    toggleSyncState('darkMode');
  }
  
  // 设置语言
  void setLanguage(String language) {
    updateSyncState('language', language);
  }
  
  // 获取深色模式状态
  bool get isDarkMode => getSyncState<bool>('darkMode') ?? false;
  
  // 获取语言
  String get language => getSyncState<String>('language') ?? 'zh_CN';
}
```

### 3. 继承 AsyncViewModel

适用于只需要管理异步业务的场景。

```dart
import 'package:your_app/viewmodels/base_model/base_viewmodel.dart';

class ProductListViewModel extends AsyncViewModel<List<Product>> {
  final ProductRepository _repository = ProductRepository();
  
  @override
  Future<List<Product>> build() async {
    // 自动在初始化时加载数据
    return await _repository.getProducts();
  }
  
  // 加载更多商品（更新状态）
  Future<void> loadMore() async {
    final currentList = state.hasValue ? (state.value ?? <Product>[]) : <Product>[];
    await execute(() async {
      final moreProducts = await _repository.getMoreProducts();
      return [...currentList, ...moreProducts];
    });
  }
  
  // 获取商品数量（不更新状态）
  Future<int> getProductCount() async {
    return await execute(
      () => _repository.getProductCount(),
      updateState: false,
    );
  }
  
  // 刷新商品列表
  @override
  Future<void> refresh() async {
    await execute(() => _repository.getProducts());
  }
}
```

## 创建 Provider

### 使用统一的 createProvider 方法

```dart
import 'package:your_app/viewmodels/provider/provider.dart';

// BaseViewModel 的 Provider
final userViewModelProvider = createProvider<UserViewModel, User>(
  () => UserViewModel(),
);

// SyncViewModel 的 Provider
final settingsViewModelProvider = createProvider<SettingsViewModel, void>(
  () => SettingsViewModel(),
);

// AsyncViewModel 的 Provider
final productListViewModelProvider = createProvider<ProductListViewModel, List<Product>>(
  () => ProductListViewModel(),
);
```

### 在 Widget 中使用

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_app/viewmodels/provider/provider.dart';
import 'package:your_app/viewmodels/view_state/view_state_widget.dart';

class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(userViewModelProvider);
    
    // 使用扩展方法检查状态
    if (ref.isLoading(userViewModelProvider)) {
      return const ViewStateBusyWidget();
    }
    
    if (ref.hasError(userViewModelProvider)) {
      final error = ref.getViewStateError(userViewModelProvider);
      return ViewStateErrorWidget(
        error: error!,
        onPressed: () => ref.refresh(userViewModelProvider),
      );
    }
    
    // 使用扩展方法获取数据
    final user = ref.getData(userViewModelProvider);
    if (user == null) {
      return const ViewStateEmptyWidget();
    }
    
    return Scaffold(
      body: Column(
        children: [
          Text('姓名: ${user.name}'),
          SwitchListTile(
            title: const Text('通知'),
            value: viewModelState.getSyncState<bool>('notification') ?? false,
            onChanged: (value) {
              ref.read(userViewModelProvider.notifier).toggleNotification(value);
            },
          ),
        ],
      ),
    );
  }
}
```

## 使用示例

### 完整的 ViewModel 示例

```dart
import 'package:your_app/viewmodels/base_model/base_viewmodel.dart';
import 'package:your_app/repositories/user_repository.dart';
import 'package:your_app/models/user_model.dart';

class UserViewModel extends BaseViewModel<User> {
  final UserRepository _repository = UserRepository();
  
  @override
  BaseViewModelState<User> build() {
    return BaseViewModelState.initial();
  }
  
  // 加载用户数据（更新状态）
  Future<void> loadUser(String userId) async {
    await execute(
      () => _repository.getUser(userId),
      onSuccess: (user) {
        print('用户加载成功: ${user.name}');
      },
      onError: (error, stackTrace) {
        print('用户加载失败: $error');
      },
    );
  }
  
  // 更新用户数据（更新状态）
  Future<void> updateUser(User user) async {
    await execute(() => _repository.updateUser(user));
  }
  
  // 验证用户邮箱（不更新状态）
  Future<bool> validateEmail(String email) async {
    return await execute(
      () => _repository.validateEmail(email),
      updateState: false,
    );
  }
  
  // 同步状态管理
  void toggleNotification(bool enabled) {
    updateSyncState('notification', enabled);
  }
  
  void toggleSelected() {
    toggleSyncState('selected');
  }
  
  bool get isNotificationEnabled => 
      getSyncState<bool>('notification') ?? false;
  
  bool get isSelected => 
      getSyncState<bool>('selected') ?? false;
}
```

### Provider 定义

```dart
import 'package:your_app/viewmodels/provider/provider.dart';

final userViewModelProvider = createProvider<UserViewModel, User>(
  () => UserViewModel(),
);
```

## 最佳实践

### 1. 继承规则

✅ **正确**：所有 ViewModel 都继承自 BaseViewModel 或其子类
```dart
class MyViewModel extends BaseViewModel<MyData> { }
```

❌ **错误**：直接继承 Notifier 或 AsyncNotifier
```dart
class MyViewModel extends Notifier<MyState> { }  // 不要这样做
```

### 2. 使用统一的 execute 方法

✅ **正确**：使用统一的 execute 方法
```dart
await execute(() => loadData());
await execute(() => validateData(), updateState: false);
```

❌ **错误**：直接使用 executeAsync 或 executeAsyncWithoutState
```dart
await executeAsync(() => loadData());  // 已废弃，不要使用
```

### 3. 使用统一的 createProvider 方法

✅ **正确**：使用统一的 createProvider 方法
```dart
final myViewModelProvider = createProvider<MyViewModel, MyData>(
  () => MyViewModel(),
);
```

❌ **错误**：直接创建 NotifierProvider 或 AsyncNotifierProvider
```dart
final myViewModelProvider = NotifierProvider<MyViewModel, BaseViewModelState<MyData>>(
  () => MyViewModel(),
);  // 不要这样做
```

### 4. 状态管理

- **异步状态**：使用 `execute()` 方法自动管理
- **同步状态**：使用 `updateSyncState()`、`getSyncState()`、`toggleSyncState()` 方法
- **错误处理**：在 `execute()` 方法中使用 `onError` 回调

### 5. 代码组织

- ViewModel 文件放在 `lib/viewmodels/` 目录下
- Provider 定义放在 ViewModel 文件末尾或单独的 provider 文件中
- 使用有意义的命名：`XxxViewModel`、`xxxViewModelProvider`

## 总结

1. **所有 ViewModel 必须继承 BaseViewModel 或其子类**
2. **使用统一的 `execute()` 方法执行异步操作**
3. **使用统一的 `createProvider()` 方法创建 Provider**
4. **遵循最佳实践，保持代码一致性**

通过遵循这些规则，可以确保项目中的 ViewModel 代码风格统一，易于维护和扩展。

