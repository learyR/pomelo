/// 基础状态类
/// 所有ViewModel状态都应继承此类，以提供统一的状态管理
abstract class BaseState {
  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? error;

  /// 是否成功（无错误且不在加载中）
  bool get isSuccess => !isLoading && error == null;

  /// 是否失败（有错误）
  bool get isFailure => error != null;

  /// 是否为空状态（无数据且不在加载中）
  bool get isEmpty => !isLoading && error == null;

  const BaseState({
    required this.isLoading,
    this.error,
  });

  /// 复制并修改状态（子类需要实现）
  BaseState copyWith({
    bool? isLoading,
    String? error,
    Object? data,
  });
}

/// 基础列表状态
/// 适用于列表数据的状态管理
abstract class BaseListState<T> extends BaseState {
  /// 数据列表
  final List<T> items;

  /// 是否还有更多数据
  final bool hasMore;

  /// 当前页码
  final int currentPage;

  /// 是否为空
  @override
  bool get isEmpty => super.isEmpty && items.isEmpty;

  /// 是否有数据
  bool get hasData => items.isNotEmpty;

  /// 数据数量
  int get itemCount => items.length;

  const BaseListState({
    required super.isLoading,
    super.error,
    this.items = const [],
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  BaseListState<T> copyWith({
    bool? isLoading,
    String? error,
    Object? data,
    List<T>? items,
    bool? hasMore,
    int? currentPage,
  }) {
    throw UnimplementedError('copyWith must be implemented by subclass');
  }
}

/// 基础详情状态
/// 适用于单个对象的状态管理
abstract class BaseDetailState<T> extends BaseState {
  /// 数据对象
  final T? data;

  /// 是否为空
  @override
  bool get isEmpty => super.isEmpty && data == null;

  /// 是否有数据
  bool get hasData => data != null;

  const BaseDetailState({
    required super.isLoading,
    super.error,
    this.data,
  });

  @override
  BaseDetailState<T> copyWith({
    bool? isLoading,
    String? error,
    Object? data,
    T? dataItem,
  }) {
    throw UnimplementedError('copyWith must be implemented by subclass');
  }
}

