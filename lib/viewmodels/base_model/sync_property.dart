import 'base_viewmodel.dart';

/// 同步状态属性
///
/// 直接定义属性，自动具备状态管理能力
///
/// 使用示例：
/// ```dart
/// class UserViewModel extends BaseViewModel<User> {
///   // 方式1：直接定义属性（推荐，key 自动使用属性名）
///   late final notification = SyncProperty<bool>(this, 'notification', defaultValue: false);
///   late final language = SyncProperty<String>(this, 'language', defaultValue: 'zh_CN');
///   late final selectedIndex = SyncProperty<int>(this, 'selectedIndex', defaultValue: 0);
///
///   // 方式2：使用工厂方法（更简洁）
///   late final notification2 = syncProps.bool(key: 'notification2', defaultValue: false);
///
///   // 使用
///   void toggleNotification() {
///     notification.value = !notification.value;
///   }
/// }
///
/// // 在 Page 中使用
/// final viewModel = ref.read(viewModelProvider.notifier);
/// viewModel.notification.value = true;
/// if (viewModel.notification.value) { ... }
/// ```
class SyncProperty<T> {
  final BaseViewModel _viewModel;
  final String _key;
  final T _defaultValue;

  /// 创建同步状态属性
  ///
  /// [viewModel] ViewModel 实例
  /// [key] 状态键（建议使用属性名，便于调试）
  /// [defaultValue] 默认值
  SyncProperty(
    BaseViewModel viewModel,
    String key, {
    required T defaultValue,
  })  : _viewModel = viewModel,
        _key = key,
        _defaultValue = defaultValue;

  /// 获取值
  T get value {
    return _viewModel.getSyncState<T>(_key) ?? _defaultValue;
  }

  /// 设置值
  set value(T newValue) {
    _viewModel.updateSyncState(_key, newValue);
  }

  /// 切换布尔值（仅适用于 bool 类型）
  void toggle() {
    if (T == bool) {
      value = !(value as bool) as T;
    } else {
      throw StateError('toggle() 只能用于 bool 类型的 SyncProperty');
    }
  }

  /// 重置为默认值
  void reset() {
    value = _defaultValue;
  }

  /// 检查是否有值（非默认值）
  bool get hasValue {
    return _viewModel.getSyncState<T>(_key) != null;
  }

  /// 获取键名（用于调试）
  String get key => _key;
}

/// 同步状态属性工厂
///
/// 提供便捷的创建方法，自动推断类型
class SyncPropertyFactory {
  final BaseViewModel _viewModel;

  SyncPropertyFactory(this._viewModel);

  /// 创建布尔属性
  SyncProperty<bool> boolValue(String key, {bool defaultValue = false}) {
    return SyncProperty<bool>(_viewModel, key, defaultValue: defaultValue);
  }

  /// 创建字符串属性
  SyncProperty<String> stringValue(String key, {String defaultValue = ''}) {
    return SyncProperty<String>(_viewModel, key, defaultValue: defaultValue);
  }

  /// 创建整数属性
  SyncProperty<int> intValue(String key, {int defaultValue = 0}) {
    return SyncProperty<int>(_viewModel, key, defaultValue: defaultValue);
  }

  /// 创建双精度浮点数属性
  SyncProperty<double> doubleValue(String key, {double defaultValue = 0.0}) {
    return SyncProperty<double>(_viewModel, key, defaultValue: defaultValue);
  }

  /// 创建通用属性
  SyncProperty<T> property<T>(String key, {required T defaultValue}) {
    return SyncProperty<T>(_viewModel, key, defaultValue: defaultValue);
  }
}

/// BaseViewModel 扩展，提供属性工厂
extension BaseViewModelSyncPropertyExtension on BaseViewModel {
  /// 获取同步状态属性工厂
  SyncPropertyFactory get syncProps => SyncPropertyFactory(this);

  /// 创建布尔类型的同步属性（简化写法）
  ///
  /// 使用示例：
  /// ```dart
  /// late final isInitialized = syncBool('isInitialized');
  /// late final agreementAccepted = syncBool('agreementAccepted');
  /// ```
  SyncProperty<bool> syncBool(String key, {bool defaultValue = false}) {
    return SyncProperty<bool>(this, key, defaultValue: defaultValue);
  }

  /// 创建整数类型的同步属性（简化写法）
  ///
  /// 使用示例：
  /// ```dart
  /// late final countdown = syncInt('countdown', defaultValue: 3);
  /// late final selectedIndex = syncInt('selectedIndex');
  /// ```
  SyncProperty<int> syncInt(String key, {int defaultValue = 0}) {
    return SyncProperty<int>(this, key, defaultValue: defaultValue);
  }

  /// 创建字符串类型的同步属性（简化写法）
  ///
  /// 使用示例：
  /// ```dart
  /// late final language = syncString('language', defaultValue: 'zh_CN');
  /// late final username = syncString('username');
  /// ```
  SyncProperty<String> syncString(String key, {String defaultValue = ''}) {
    return SyncProperty<String>(this, key, defaultValue: defaultValue);
  }

  /// 创建双精度浮点数类型的同步属性（简化写法）
  ///
  /// 使用示例：
  /// ```dart
  /// late final price = syncDouble('price', defaultValue: 0.0);
  /// late final ratio = syncDouble('ratio');
  /// ```
  SyncProperty<double> syncDouble(String key, {double defaultValue = 0.0}) {
    return SyncProperty<double>(this, key, defaultValue: defaultValue);
  }

  /// 创建可空类型的同步属性（简化写法）
  ///
  /// 使用示例：
  /// ```dart
  /// late final errorMessage = syncNullable<String>('errorMessage');
  /// late final selectedItem = syncNullable<Item>('selectedItem');
  /// ```
  SyncProperty<T?> syncNullable<T>(String key) {
    return SyncProperty<T?>(this, key, defaultValue: null);
  }
}
