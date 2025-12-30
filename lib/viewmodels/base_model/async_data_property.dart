import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_viewmodel.dart';

/// 异步数据属性
///
/// 直接定义属性，自动具备状态管理能力
///
/// 使用示例：
/// ```dart
/// class HomeViewModel extends BaseViewModel<void> {
///   final UserRepository _userRepository = UserRepository();
///
///   // 直接定义属性，自动具备状态管理能力
///   late final user = AsyncDataProperty<User>(this, 'user');
///   late final products = AsyncDataProperty<List<Product>>(this, 'products');
///
///   // 加载数据
///   Future<void> loadUser() async {
///     await user.load(() => _userRepository.getUser());
///   }
///
///   Future<void> loadProducts() async {
///     await products.load(() => _productRepository.getProducts());
///   }
/// }
///
/// // 在 Page 中使用
/// final viewModel = ref.read(viewModelProvider.notifier);
/// if (viewModel.user.isLoading) { ... }
/// if (viewModel.user.hasError) { ... }
/// final user = viewModel.user.value;
/// ```
class AsyncDataProperty<T> {
  final BaseViewModel _viewModel;
  final String _key;

  /// 创建异步数据属性
  ///
  /// [viewModel] ViewModel 实例
  /// [key] 数据源键（建议使用属性名，便于调试）
  AsyncDataProperty(
    BaseViewModel viewModel,
    String key,
  )   : _viewModel = viewModel,
        _key = key;

  /// 加载数据
  ///
  /// [asyncAction] 异步操作函数
  /// [onSuccess] 成功回调
  /// [onError] 错误回调
  /// [showLoading] 是否显示加载状态，默认为 true
  Future<T> load(
    Future<T> Function() asyncAction, {
    void Function(T data)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _viewModel.setAsyncDataState(_key, const AsyncValue.loading());
      }

      final result = await asyncAction();

      _viewModel.setAsyncDataState(_key, AsyncValue.data(result));

      onSuccess?.call(result);
      return result;
    } catch (error, stackTrace) {
      _viewModel.setAsyncDataState(
        _key,
        AsyncValue.error(error, stackTrace),
      );

      onError?.call(error, stackTrace);
      rethrow;
    }
  }

  /// 刷新数据（重新加载）
  Future<T> refresh(
    Future<T> Function() asyncAction, {
    void Function(T data)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
    bool showLoading = false,
  }) async {
    return await load(
      asyncAction,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// 获取数据值
  T? get value {
    final asyncValue = _viewModel.getAsyncDataState<T>(_key);
    if (asyncValue != null && asyncValue.hasValue) {
      return asyncValue.value;
    }
    return null;
  }

  /// 设置数据值（直接设置，不执行异步操作）
  set value(T? newValue) {
    if (newValue != null) {
      _viewModel.setAsyncDataState(_key, AsyncValue.data(newValue));
    } else {
      _viewModel.removeAsyncData(_key);
    }
  }

  /// 获取异步状态
  AsyncValue<T>? get state => _viewModel.getAsyncDataState<T>(_key);

  /// 是否正在加载
  bool get isLoading {
    final asyncValue = _viewModel.getAsyncDataState<T>(_key);
    return asyncValue?.isLoading ?? false;
  }

  /// 是否有数据
  bool get hasData {
    final asyncValue = _viewModel.getAsyncDataState<T>(_key);
    return asyncValue?.hasValue ?? false;
  }

  /// 是否有错误
  bool get hasError {
    final asyncValue = _viewModel.getAsyncDataState<T>(_key);
    return asyncValue?.hasError ?? false;
  }

  /// 获取错误信息
  Object? get error {
    final asyncValue = _viewModel.getAsyncDataState<T>(_key);
    return asyncValue?.error;
  }

  /// 设置加载状态
  void setLoading() {
    _viewModel.setAsyncDataState(_key, const AsyncValue.loading());
  }

  /// 设置错误状态
  void setError(Object error, [StackTrace? stackTrace]) {
    _viewModel.setAsyncDataState(
      _key,
      AsyncValue.error(error, stackTrace ?? StackTrace.current),
    );
  }

  /// 清除数据
  void clear() {
    _viewModel.removeAsyncData(_key);
  }

  /// 获取键名（用于调试）
  String get key => _key;
}

/// 异步数据属性工厂
///
/// 提供便捷的创建方法
class AsyncDataPropertyFactory {
  final BaseViewModel _viewModel;

  AsyncDataPropertyFactory(this._viewModel);

  /// 创建异步数据属性
  AsyncDataProperty<T> property<T>(String key) {
    return AsyncDataProperty<T>(_viewModel, key);
  }
}

/// BaseViewModel 扩展，提供属性工厂
extension BaseViewModelAsyncDataPropertyExtension on BaseViewModel {
  /// 获取异步数据属性工厂
  AsyncDataPropertyFactory get asyncProps => AsyncDataPropertyFactory(this);
}
