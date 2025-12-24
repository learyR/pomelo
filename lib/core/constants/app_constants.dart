/// 应用常量定义
class AppConstants {
  // API配置
  static const String baseUrl = 'https://vis.bmetech.com/visapp/';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // 存储键名
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userInfoKey = 'user_info';

  // 分页配置
  static const int defaultPageSize = 20;

  // 图片配置
  static const String imagePlaceholder = 'https://via.placeholder.com/300';

  // 错误消息
  static const String networkError = '网络连接失败，请检查网络设置';
  static const String serverError = '服务器错误，请稍后重试';
  static const String unknownError = '未知错误，请稍后重试';
}

