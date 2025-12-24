/// 路由名称常量
/// 
/// 统一管理所有路由路径，避免硬编码字符串
class RouteName {
  RouteName._(); // 私有构造函数，防止实例化

  // ========== 主路由 ==========
  
  /// 启动页
  static const String splash = '/splash';
  
  /// 首页（Tab 首页）
  static const String home = '/home';
  
  /// Tab 容器页
  static const String tab = '/tab';

  // ========== 认证相关 ==========
  
  /// 登录页
  static const String login = '/login';
  
  /// 注册页
  static const String register = '/register';
  
  /// 忘记密码
  static const String forgotPassword = '/forgot-password';
  
  /// 重置密码
  static const String resetPassword = '/reset-password';

  // ========== 主要功能页面 ==========
  
  /// 分类页
  static const String category = '/category';
  
  /// 购物车
  static const String cart = '/cart';
  
  /// 个人中心
  static const String profile = '/profile';

  // ========== 商品相关 ==========
  
  /// 商品详情
  static const String productDetail = '/product/detail';
  
  /// 商品列表
  static const String productList = '/product/list';
  
  /// 商品搜索
  static const String productSearch = '/product/search';

  // ========== 订单相关 ==========
  
  /// 订单列表
  static const String orderList = '/order/list';
  
  /// 订单详情
  static const String orderDetail = '/order/detail';
  
  /// 创建订单
  static const String orderCreate = '/order/create';

  // ========== 其他页面 ==========
  
  /// 设置页
  static const String settings = '/settings';
  
  /// 地址管理
  static const String address = '/address';
  
  /// 地址编辑
  static const String addressEdit = '/address/edit';

  /// 获取路由名称（去除参数）
  static String getRouteName(String fullPath) {
    final uri = Uri.parse(fullPath);
    return uri.path;
  }

  /// 检查是否是主 Tab 页面
  static bool isMainTabRoute(String route) {
    return route == home ||
        route == category ||
        route == cart ||
        route == profile;
  }

  /// 检查是否需要登录
  static bool requiresAuth(String route) {
    // 定义需要登录的路由
    const authRequiredRoutes = [
      cart,
      profile,
      orderList,
      orderDetail,
      orderCreate,
      address,
      addressEdit,
      settings,
    ];
    return authRequiredRoutes.contains(route);
  }
}
