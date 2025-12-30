/// 视图状态枚举
enum ViewState {
  /// 空闲状态（初始状态）
  idle,

  /// 忙碌状态（加载中）
  busy,

  /// 空状态（无数据）
  empty,

  /// 错误状态
  error,
}

/// 错误类型
enum ViewStateErrorType {
  defaultError,
  networkTimeOutError, //网络错误
  unauthorizedError, //未授权(一般为未登录)
  emptyError,
}

class ViewStateError {
  ViewStateErrorType? _errorType;
  String? message;
  String? errorMessage;

  ViewStateError(this._errorType, {this.message, this.errorMessage}) {
    _errorType ??= ViewStateErrorType.defaultError;
    message ??= errorMessage;
  }

  ViewStateErrorType get errorType =>
      _errorType ?? ViewStateErrorType.defaultError;

  bool get isDefaultError => _errorType == ViewStateErrorType.defaultError;

  bool get isNetworkTimeOut =>
      _errorType == ViewStateErrorType.networkTimeOutError;

  bool get isUnauthorized => _errorType == ViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'ViewStateError{errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}
