/// API配置定义
/// 用于定义接口常量、BaseUrl等配置信息
/// 可在项目中继承或扩展此类以添加项目特定的API定义
class ApiDefine {
  /// 基础URL - 必须在项目中配置
  static String baseUrl = 'https://api.example.com';

  /// 连接超时时间（毫秒）
  static int connectTimeout = 30000;

  /// 接收超时时间（毫秒）
  static int receiveTimeout = 30000;

  /// 默认请求头
  static Map<String, dynamic> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// 是否启用日志
  static bool enableLogging = true;

  /// Token获取回调 - 用于从项目特定的存储中获取Token
  /// 返回null表示没有Token
  static String? Function()? getTokenCallback;

  /// Token清除回调 - 当Token过期时调用
  static void Function()? clearTokenCallback;

  /// 日志输出回调 - 用于自定义日志输出
  static void Function(String level, String message)? logCallback;

  /// 初始化配置
  /// 在应用启动时调用此方法进行配置
  static void init({
    required String baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
    Map<String, dynamic>? defaultHeaders,
    bool? enableLogging,
    String? Function()? getTokenCallback,
    void Function()? clearTokenCallback,
    void Function(String level, String message)? logCallback,
  }) {
    ApiDefine.baseUrl = baseUrl;
    if (connectTimeout != null) {
      ApiDefine.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      ApiDefine.receiveTimeout = receiveTimeout;
    }
    if (defaultHeaders != null) {
      ApiDefine.defaultHeaders = defaultHeaders;
    }
    if (enableLogging != null) {
      ApiDefine.enableLogging = enableLogging;
    }
    ApiDefine.getTokenCallback = getTokenCallback;
    ApiDefine.clearTokenCallback = clearTokenCallback;
    ApiDefine.logCallback = logCallback;
  }
}

/// API接口路径定义
/// 可在项目中继承或扩展此类以添加项目特定的API路径
class ApiPath {
  // 示例：认证相关
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // 示例：用户相关
  static const String userInfo = '/user/info';
  static const String updateUserInfo = '/user/info';

  // 示例：商品相关
  static const String products = '/products';
  static const String productDetail = '/products/{id}';
  static const String productSearch = '/products/search';

  // 示例：购物车相关
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartRemove = '/cart/remove';

  // 示例：订单相关
  static const String orders = '/orders';
  static const String orderDetail = '/orders/{id}';
  static const String orderCreate = '/orders/create';

  /// 替换路径参数
  /// 例如：ApiPath.replaceParams('/products/{id}', {'id': '123'}) => '/products/123'
  static String replaceParams(String path, Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

