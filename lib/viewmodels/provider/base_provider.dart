import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base_model/base_viewmodel.dart';

/// 统一的 Provider 创建方法
///
/// 自动判断 ViewModel 类型，创建对应的 Provider
///
/// 支持的 ViewModel 类型：
/// - BaseViewModel<T> -> NotifierProvider
/// - SyncViewModel -> NotifierProvider
/// - AsyncViewModel<T> -> AsyncNotifierProvider
///
/// 使用示例：
/// ```dart
/// // BaseViewModel
/// final userViewModelProvider = createProvider<UserViewModel, User>(
///   () => UserViewModel(),
/// );
///
/// // SyncViewModel
/// final settingsViewModelProvider = createProvider<SettingsViewModel, void>(
///   () => SettingsViewModel(),
/// );
///
/// // AsyncViewModel
/// final productListViewModelProvider = createProvider<ProductListViewModel, List<Product>>(
///   () => ProductListViewModel(),
/// );
/// ```
NotifierProvider<T, BaseViewModelState<U>>
    createProvider<T extends BaseViewModel<U>, U>(
  T Function() create, {
  String? name,
}) {
  return NotifierProvider<T, BaseViewModelState<U>>(
    create,
    name: name,
  );
}

/// 创建 BaseViewModel 的 Provider
///
/// 简化 NotifierProvider 的创建，自动推断类型
///
/// 使用示例：
/// ```dart
/// class UserViewModel extends BaseViewModel<User> {
///   // ...
/// }
///
/// final userViewModelProvider = createBaseProvider<UserViewModel, User>(
///   () => UserViewModel(),
/// );
/// ```
NotifierProvider<T, BaseViewModelState<U>>
    createBaseProvider<T extends BaseViewModel<U>, U>(
  T Function() create, {
  String? name,
}) {
  return NotifierProvider<T, BaseViewModelState<U>>(
    create,
    name: name,
  );
}

/// Provider 扩展方法
///
/// 提供便捷的方法来访问 ViewModel 和状态
extension BaseProviderExtension<T extends BaseViewModel<U>, U>
    on NotifierProvider<T, BaseViewModelState<U>> {
  /// 获取 ViewModel 实例
  T getViewModel(WidgetRef ref) {
    return ref.read(notifier);
  }

  /// 获取当前状态
  BaseViewModelState<U> getState(WidgetRef ref) {
    return ref.watch(this);
  }

  /// 监听状态变化
  void listenState(
    WidgetRef ref,
    void Function(BaseViewModelState<U>? previous, BaseViewModelState<U> next)
        listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    ref.listen(this, listener, onError: onError);
  }
}

/// Provider 工具类
///
/// 提供一些常用的 Provider 操作工具方法
class ProviderUtils {
  /// 从 Provider 中安全获取数据
  ///
  /// 如果状态为 loading 或 error，返回 null
  static U? safeGetData<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = ref.watch(provider);
    return state.data;
  }

  /// 检查 Provider 是否正在加载
  static bool isLoading<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = ref.watch(provider);
    return state.isLoading;
  }

  /// 检查 Provider 是否有错误
  static bool hasError<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = ref.watch(provider);
    return state.hasError;
  }

  /// 获取 Provider 的错误信息
  static Object? getError<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = ref.watch(provider);
    return state.error;
  }

  /// 刷新 Provider 数据
  static Future<void> refresh<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) async {
    await ref.read(provider.notifier).refresh();
  }

  /// 重置 Provider 状态
  static void reset<T extends BaseViewModel<U>, U>(
    WidgetRef ref,
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    ref.read(provider.notifier).reset();
  }
}
