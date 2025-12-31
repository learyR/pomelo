import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_state/view_state.dart';

/// 基础 ViewModel 状态类
///
/// 包含异步数据和同步状态
class BaseViewModelState<T> {
  /// 异步数据状态
  final AsyncValue<T> asyncValue;

  /// 多个异步数据状态映射（用于管理多个不同的异步数据源）
  final Map<String, AsyncValue> asyncDataMap;

  /// 同步状态映射（用于开关、选中状态等）
  final Map<String, dynamic> syncStates;

  /// 是否正在加载
  bool get isLoading => asyncValue.isLoading;

  /// 是否有数据
  bool get hasData => asyncValue.hasValue;

  /// 是否有错误
  bool get hasError => asyncValue.hasError;

  /// 获取数据
  T? get data => asyncValue.hasValue ? asyncValue.value : null;

  /// 获取错误
  Object? get error => asyncValue.error;

  /// 获取堆栈跟踪
  StackTrace? get stackTrace => asyncValue.stackTrace;

  /// 获取 ViewState
  ViewState get viewState {
    if (asyncValue.isLoading) return ViewState.busy;
    if (asyncValue.hasError) return ViewState.error;
    if (asyncValue.hasValue) {
      final value = asyncValue.value;
      if (value == null || (value is List && value.isEmpty)) {
        return ViewState.empty;
      }
      return ViewState.idle;
    }
    return ViewState.idle;
  }

  /// 获取 ViewStateError
  ViewStateError? get viewStateError {
    if (!hasError) return null;
    final error = this.error;
    if (error is ViewStateError) return error;

    // 根据错误类型转换为 ViewStateError
    String? errorMessage = error?.toString();
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;

    if (errorMessage?.contains('timeout') == true ||
        errorMessage?.contains('网络') == true ||
        errorMessage?.contains('network') == true) {
      errorType = ViewStateErrorType.networkTimeOutError;
    } else if (errorMessage?.contains('401') == true ||
        errorMessage?.contains('unauthorized') == true ||
        errorMessage?.contains('未授权') == true) {
      errorType = ViewStateErrorType.unauthorizedError;
    }

    return ViewStateError(errorType, errorMessage: errorMessage);
  }

  /// 获取同步状态
  TState? getSyncState<TState>(String key) {
    return syncStates[key] as TState?;
  }

  /// 设置同步状态
  BaseViewModelState<T> copyWithSyncState(String key, dynamic value) {
    final newSyncStates = Map<String, dynamic>.from(syncStates);
    newSyncStates[key] = value;
    return BaseViewModelState<T>(
      asyncValue: asyncValue,
      asyncDataMap: asyncDataMap,
      syncStates: newSyncStates,
    );
  }

  /// 移除同步状态
  BaseViewModelState<T> removeSyncState(String key) {
    final newSyncStates = Map<String, dynamic>.from(syncStates);
    newSyncStates.remove(key);
    return BaseViewModelState<T>(
      asyncValue: asyncValue,
      asyncDataMap: asyncDataMap,
      syncStates: newSyncStates,
    );
  }

  /// 获取异步数据状态
  AsyncValue<U>? getAsyncData<U>(String key) {
    final value = asyncDataMap[key];
    if (value != null) {
      try {
        return value as AsyncValue<U>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// 设置异步数据状态
  BaseViewModelState<T> copyWithAsyncData<U>(
    String key,
    AsyncValue<U> asyncValue,
  ) {
    final newAsyncDataMap = Map<String, AsyncValue>.from(asyncDataMap);
    newAsyncDataMap[key] = asyncValue;
    return BaseViewModelState<T>(
      asyncValue: this.asyncValue,
      asyncDataMap: newAsyncDataMap,
      syncStates: syncStates,
    );
  }

  /// 移除异步数据
  BaseViewModelState<T> removeAsyncData(String key) {
    final newAsyncDataMap = Map<String, AsyncValue>.from(asyncDataMap);
    newAsyncDataMap.remove(key);
    return BaseViewModelState<T>(
      asyncValue: asyncValue,
      asyncDataMap: newAsyncDataMap,
      syncStates: syncStates,
    );
  }

  const BaseViewModelState({
    this.asyncValue = const AsyncValue.loading(),
    this.asyncDataMap = const {},
    this.syncStates = const {},
  });

  /// 创建初始状态
  factory BaseViewModelState.initial() {
    // 对于可空类型，使用 loading 状态作为初始状态
    // 或者使用 AsyncValue.data(null) 如果 T 是可空的
    return BaseViewModelState(
      asyncValue: const AsyncValue.loading(),
      asyncDataMap: const {},
      syncStates: const {},
    );
  }

  /// 创建加载状态
  factory BaseViewModelState.loading() {
    return const BaseViewModelState(
      asyncValue: AsyncValue.loading(),
      asyncDataMap: {},
      syncStates: {},
    );
  }

  /// 创建数据状态
  factory BaseViewModelState.data(
    T data, {
    Map<String, dynamic>? syncStates,
    Map<String, AsyncValue>? asyncDataMap,
  }) {
    return BaseViewModelState(
      asyncValue: AsyncValue.data(data),
      asyncDataMap: asyncDataMap ?? const {},
      syncStates: syncStates ?? const {},
    );
  }

  /// 创建错误状态
  factory BaseViewModelState.error(
    Object error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? syncStates,
    Map<String, AsyncValue>? asyncDataMap,
  }) {
    return BaseViewModelState(
      asyncValue: AsyncValue.error(
        error,
        stackTrace ?? StackTrace.current,
      ),
      asyncDataMap: asyncDataMap ?? const {},
      syncStates: syncStates ?? const {},
    );
  }

  /// 复制并更新异步值
  BaseViewModelState<T> copyWith({
    AsyncValue<T>? asyncValue,
    Map<String, AsyncValue>? asyncDataMap,
    Map<String, dynamic>? syncStates,
  }) {
    return BaseViewModelState<T>(
      asyncValue: asyncValue ?? this.asyncValue,
      asyncDataMap: asyncDataMap ?? this.asyncDataMap,
      syncStates: syncStates ?? this.syncStates,
    );
  }
}

/// 基础 ViewModel 类
///
/// 用于管理异步业务和同步状态
abstract class BaseViewModel<T> extends Notifier<BaseViewModelState<T>> {
  @override
  BaseViewModelState<T> build() {
    return BaseViewModelState.initial();
  }

  /// 统一的执行方法
  ///
  /// 自动判断是否需要更新状态，提供统一的异步操作执行接口
  ///
  /// [asyncAction] 异步操作函数
  /// [updateState] 是否更新状态
  ///   - true: 更新状态（显示 loading，设置 data 或 error），返回类型必须是 T
  ///   - false: 不更新状态，仅返回结果，可以返回任意类型
  ///   - null: 自动判断（如果返回类型是 T，则更新状态；否则不更新状态）
  /// [onSuccess] 成功回调
  /// [onError] 错误回调
  /// [showLoading] 是否显示加载状态，默认为 true（仅在 updateState=true 时有效）
  ///
  /// 使用示例：
  /// ```dart
  /// // 更新状态的异步操作（返回类型是 T）
  /// await execute(() => loadUserData());
  ///
  /// // 不更新状态的异步操作（如辅助操作，返回类型不是 T）
  /// final isValid = await execute(() => validateData(), updateState: false);
  ///
  /// // 明确指定是否更新状态
  /// await execute(() => saveUser(), updateState: true);
  ///
  /// // 带回调的操作
  /// await execute(
  ///   () => saveUser(),
  ///   onSuccess: (user) => print('保存成功'),
  ///   onError: (error, stack) => print('保存失败'),
  /// );
  /// ```
  Future<R> execute<R>(
    Future<R> Function() asyncAction, {
    bool? updateState,
    void Function(R data)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
    bool showLoading = true,
  }) async {
    // 自动判断：如果 updateState 为 null，尝试判断返回类型
    // 注意：Dart 中无法在运行时直接比较类型，所以需要用户明确指定
    // 默认行为：如果 updateState 为 null，假设需要更新状态（返回类型是 T）
    final shouldUpdateState = updateState ?? true;

    if (shouldUpdateState) {
      // 更新状态的操作（返回类型应该是 T）
      try {
        if (showLoading) {
          state = state.copyWith(
            asyncValue: const AsyncValue.loading(),
          );
        }

        final result = await asyncAction();

        // 只有当返回类型是 T 时才更新状态
        if (result is T) {
          state = BaseViewModelState.data(
            result as T,
            asyncDataMap: state.asyncDataMap,
            syncStates: state.syncStates,
          );
          onSuccess?.call(result as R);
          return result;
        } else {
          // 返回类型不是 T，但用户要求更新状态，发出警告
          // 这种情况下不更新状态，仅返回结果
          onSuccess?.call(result);
          return result;
        }
      } catch (error, stackTrace) {
        state = BaseViewModelState.error(
          error,
          stackTrace,
          asyncDataMap: state.asyncDataMap,
          syncStates: state.syncStates,
        );

        onError?.call(error, stackTrace);
        rethrow;
      }
    } else {
      // 不更新状态的操作
      try {
        final result = await asyncAction();
        onSuccess?.call(result);
        return result;
      } catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        rethrow;
      }
    }
  }

  /// 更新同步状态
  ///
  /// [key] 状态键
  /// [value] 状态值
  ///
  /// 注意：推荐使用 sync.set() 方法
  void updateSyncState(String key, dynamic value) {
    state = state.copyWithSyncState(key, value);
  }

  /// 获取同步状态
  ///
  /// [key] 状态键
  ///
  /// 注意：推荐使用 sync.get() 方法
  TState? getSyncState<TState>(String key) {
    return state.getSyncState<TState>(key);
  }

  /// 移除同步状态
  ///
  /// [key] 状态键
  ///
  /// 注意：推荐使用 sync.remove() 方法
  void removeSyncState(String key) {
    state = state.removeSyncState(key);
  }

  /// 切换布尔状态
  ///
  /// [key] 状态键
  /// [defaultValue] 默认值，如果状态不存在则使用此值
  ///
  /// 注意：推荐使用 sync.toggle() 方法
  void toggleSyncState(String key, {bool defaultValue = false}) {
    final currentValue = getSyncState<bool>(key) ?? defaultValue;
    updateSyncState(key, !currentValue);
  }

  /// 设置数据（直接设置，不执行异步操作）
  void setData(T data) {
    state = BaseViewModelState.data(
      data,
      asyncDataMap: state.asyncDataMap,
      syncStates: state.syncStates,
    );
  }

  /// 设置加载状态
  void setLoading() {
    state = state.copyWith(
      asyncValue: const AsyncValue.loading(),
    );
  }

  /// 设置错误状态
  void setError(Object error, [StackTrace? stackTrace]) {
    state = BaseViewModelState.error(
      error,
      stackTrace,
      asyncDataMap: state.asyncDataMap,
      syncStates: state.syncStates,
    );
  }

  /// 获取异步数据状态
  AsyncValue<U>? getAsyncDataState<U>(String key) {
    return state.getAsyncData<U>(key);
  }

  /// 设置异步数据状态
  void setAsyncDataState<U>(String key, AsyncValue<U> asyncValue) {
    state = state.copyWithAsyncData(key, asyncValue);
  }

  /// 移除异步数据
  void removeAsyncData(String key) {
    state = state.removeAsyncData(key);
  }

  /// 重置状态
  void reset() {
    state = BaseViewModelState.initial();
  }

  /// 刷新数据
  ///
  /// 子类可以重写此方法来实现自定义刷新逻辑
  /// 默认情况下，此方法需要子类提供刷新逻辑
  Future<void> refresh() async {
    // 子类需要实现具体的刷新逻辑
    // 例如：await executeAsync(() => loadData());
  }
}
