import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base_model/base_viewmodel.dart';
import '../view_state/view_state.dart';
import '../view_state/view_state_widget.dart';

/// WidgetRef 扩展方法
///
/// 提供便捷的方法来访问和操作 Provider
extension WidgetRefProviderExtension on WidgetRef {
  /// 监听 ViewModel 并返回实例
  ///
  /// 这个方法会自动监听 ViewModel 的状态变化（包括所有 syncStates），
  /// 当你使用 ViewModel 中的 SyncProperty 属性时，UI 会自动更新。
  ///
  /// 使用示例：
  /// ```dart
  /// final viewModel = ref.watchViewModel(splashProvider);
  /// // 直接使用属性，UI 会自动更新
  /// if (viewModel.isAgreementAccepted) { ... }
  /// Text('${viewModel.countDownValue}s')
  /// ```
  T watchViewModel<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    // 监听状态，确保 syncStates 变化时 UI 会更新
    watch(provider.select((state) => state.syncStates));
    // 返回 ViewModel 实例
    return read(provider.notifier);
  }

  /// 从 BaseViewModel Provider 中获取数据
  ///
  /// 如果状态为 loading 或 error，返回 null
  U? getData<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = watch(provider);
    return state.data;
  }

  /// 检查 BaseViewModel Provider 是否正在加载
  bool isLoading<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = watch(provider);
    return state.isLoading;
  }


  /// 检查 BaseViewModel Provider 是否有错误
  bool hasError<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = watch(provider);
    return state.hasError;
  }

  /// 获取 BaseViewModel Provider 的 ViewState
  ViewState getViewState<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = watch(provider);
    return state.viewState;
  }

  /// 获取 BaseViewModel Provider 的 ViewStateError
  ViewStateError? getViewStateError<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    final state = watch(provider);
    return state.viewStateError;
  }

  /// 刷新 BaseViewModel Provider 数据
  Future<void> refresh<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) async {
    await read(provider.notifier).refresh();
  }

  /// 重置 BaseViewModel Provider 状态
  void reset<T extends BaseViewModel<U>, U>(
    NotifierProvider<T, BaseViewModelState<U>> provider,
  ) {
    read(provider.notifier).reset();
  }
}

/// 根据 ViewState 自动显示对应 Widget 的便捷方法
extension ViewStateWidgetExtension on WidgetRef {
  /// 根据 BaseViewModel 的状态自动显示对应的 Widget
  ///
  /// [provider] BaseViewModel Provider
  /// [dataBuilder] 数据 Widget 构建器
  /// [loadingBuilder] 加载 Widget 构建器（可选）
  /// [errorBuilder] 错误 Widget 构建器（可选）
  /// [emptyBuilder] 空数据 Widget 构建器（可选）
  Widget buildViewState<T extends BaseViewModel<U>, U>({
    required NotifierProvider<T, BaseViewModelState<U>> provider,
    required Widget Function(U data) dataBuilder,
    Widget Function()? loadingBuilder,
    Widget Function(ViewStateError error, VoidCallback onRetry)? errorBuilder,
    Widget Function()? emptyBuilder,
  }) {
    final state = watch(provider);

    if (state.isLoading) {
      return loadingBuilder?.call() ?? const ViewStateBusyWidget();
    }

    if (state.hasError) {
      final error = state.viewStateError;
      if (error != null && errorBuilder != null) {
        return errorBuilder(
          error,
          () => refresh(provider),
        );
      }
      return ViewStateErrorWidget(
        error: error ?? ViewStateError(ViewStateErrorType.defaultError),
        onPressed: () => refresh(provider),
      );
    }

    final data = state.data;
    if (data == null || (data is List && data.isEmpty)) {
      return emptyBuilder?.call() ?? const ViewStateEmptyWidget();
    }

    return dataBuilder(data);
  }
}
