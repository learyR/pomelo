import 'package:flutter_riverpod/legacy.dart';
import '../../services/network/api_exception.dart';
import '../../utils/logger_util.dart';
import '../../utils/toast_util.dart';
import 'base_state.dart';

/// 基础ViewModel
/// 提供统一的状态管理和错误处理
/// 所有ViewModel都应继承此类
abstract class BaseViewModel<T extends BaseState> extends StateNotifier<T> {
  BaseViewModel(super.state);

  /// 执行异步操作，自动处理加载状态和错误
  /// 
  /// [action] - 要执行的异步操作
  /// [onSuccess] - 成功回调，参数为操作结果
  /// [onError] - 错误回调，参数为错误信息
  /// [showLoading] - 是否显示加载状态，默认为true
  /// [showError] - 是否显示错误提示，默认为true
  /// [errorMessage] - 自定义错误提示信息
  Future<R?> execute<R>({
    required Future<R> Function() action,
    Function(R result)? onSuccess,
    Function(String error)? onError,
    bool showLoading = true,
    bool showError = true,
    String? errorMessage,
  }) async {
    try {
      // 设置加载状态
      if (showLoading) {
        setLoading(true);
      }

      // 执行操作
      final result = await action();

      // 清除加载状态和错误
      if (showLoading) {
        setLoading(false);
      }
      clearError();

      // 调用成功回调
      onSuccess?.call(result);

      return result;
    } on ApiException catch (e) {
      // 处理API异常
      _handleApiException(e, showError: showError, errorMessage: errorMessage);
      
      // 调用错误回调
      onError?.call(e.message);
      
      return null;
    } catch (e, stackTrace) {
      // 处理其他异常
      final errorMsg = errorMessage ?? _extractErrorMessage(e);
      LoggerUtil.error('操作失败', e, stackTrace);
      
      // 设置错误状态
      setError(errorMsg);
      
      // 显示错误提示
      if (showError) {
        ToastUtil.showError(errorMsg);
      }
      
      // 调用错误回调
      onError?.call(errorMsg);
      
      return null;
    }
  }

  /// 处理API异常
  void _handleApiException(
    ApiException exception, {
    bool showError = true,
    String? errorMessage,
  }) {
    LoggerUtil.error('API异常', exception);

    // 设置加载状态为false
    setLoading(false);

    // 设置错误信息
    final errorMsg = errorMessage ?? exception.message;
    setError(errorMsg);

    // 根据异常类型处理
    switch (exception.runtimeType) {
      case ApiUnauthorizedException:
        // 认证失败，可能需要跳转登录页
        handleUnauthorized();
        break;
      case ApiConnectionException:
      case ApiTimeoutException:
        // 网络错误
        if (showError) {
          ToastUtil.showError(errorMsg);
        }
        break;
      default:
        // 其他错误
        if (showError) {
          ToastUtil.showError(errorMsg);
        }
    }
  }

  /// 处理认证失败（401）
  /// 子类可以重写此方法以实现自定义逻辑
  void handleUnauthorized() {
    // 默认显示错误提示
    ToastUtil.showError('登录已过期，请重新登录');
    // 可以在这里触发重新登录逻辑
    // 例如：通过EventBus或Provider通知应用
  }

  /// 设置加载状态
  void setLoading(bool loading) {
    state = (state.copyWith(isLoading: loading, error: null) as T);
  }

  /// 设置错误信息
  void setError(String? error) {
    state = (state.copyWith(isLoading: false, error: error) as T);
  }

  /// 清除错误信息
  void clearError() {
    if (state.error != null) {
      state = (state.copyWith(error: null) as T);
    }
  }

  /// 提取错误消息
  String _extractErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }
    if (error is Exception) {
      return error.toString();
    }
    return '操作失败，请稍后重试';
  }

  /// 刷新数据（子类需要实现）
  Future<void> refresh() async {
    // 子类实现具体的刷新逻辑
  }

  /// 重置状态
  void reset() {
    // 子类可以重写此方法来实现重置逻辑
  }
}

/// 基础列表ViewModel
/// 适用于列表数据的ViewModel
abstract class BaseListViewModel<T extends BaseListState<Item>, Item>
    extends BaseViewModel<T> {
  BaseListViewModel(super.state);

  /// 加载数据
  Future<void> loadData({
    bool refresh = false,
    Map<String, dynamic>? params,
  }) async {
    await execute(
      action: () async {
        final page = refresh ? 1 : state.currentPage;
        final items = await fetchData(page: page, params: params);

        if (refresh) {
          // 刷新：替换数据
          updateItems(items, page: page + 1, hasMore: items.length >= 20);
        } else {
          // 加载更多：追加数据
          updateItems(
            [...state.items, ...items],
            page: page + 1,
            hasMore: items.length >= 20,
          );
        }

        return items;
      },
      showError: true,
    );
  }

  /// 加载更多数据
  Future<void> loadMore({Map<String, dynamic>? params}) async {
    if (state.isLoading || !state.hasMore) return;
    await loadData(refresh: false, params: params);
  }

  /// 刷新数据
  @override
  Future<void> refresh({Map<String, dynamic>? params}) async {
    await loadData(refresh: true, params: params);
  }

  /// 更新数据列表
  void updateItems(
    List<Item> items, {
    int? page,
    bool? hasMore,
  }) {
    state = state.copyWith(
      items: items,
      currentPage: page,
      hasMore: hasMore,
      isLoading: false,
      error: null,
    ) as T;
  }

  /// 添加数据项
  void addItem(Item item) {
    updateItems([...state.items, item]);
  }

  /// 删除数据项
  void removeItem(Item item, bool Function(Item) predicate) {
    updateItems(state.items.where((i) => !predicate(i)).toList());
  }

  /// 更新数据项
  void updateItem(Item item, bool Function(Item) predicate, Item Function(Item) updater) {
    updateItems(
      state.items.map((i) => predicate(i) ? updater(i) : i).toList(),
    );
  }

  /// 清空数据
  void clearItems() {
    updateItems([]);
  }

  /// 获取数据（子类需要实现）
  Future<List<Item>> fetchData({
    required int page,
    Map<String, dynamic>? params,
  });
}

/// 基础详情ViewModel
/// 适用于单个对象的ViewModel
abstract class BaseDetailViewModel<T extends BaseDetailState<Item>, Item>
    extends BaseViewModel<T> {
  BaseDetailViewModel(super.state);

  /// 加载数据
  Future<void> loadData({Map<String, dynamic>? params}) async {
    await execute(
      action: () async {
        final data = await fetchData(params: params);
        updateData(data);
        return data;
      },
      showError: true,
    );
  }

  /// 刷新数据
  @override
  Future<void> refresh({Map<String, dynamic>? params}) async {
    await loadData(params: params);
  }

  /// 更新数据
  void updateData(Item? data) {
    state = state.copyWith(
      data: data,
      isLoading: false,
      error: null,
    ) as T;
  }

  /// 清空数据
  void clearData() {
    updateData(null);
  }

  /// 获取数据（子类需要实现）
  Future<Item> fetchData({Map<String, dynamic>? params});
}

