
import '../models/user_model.dart';

/// 用户仓库接口
abstract class UserRepository {
  /// 登录
  Future<String> login(String username, String password);

  /// 注册
  Future<UserModel> register({
    required String username,
    required String password,
    String? phone,
    String? email,
  });

  /// 获取用户信息
  Future<UserModel> getUserInfo();

  /// 更新用户信息
  Future<UserModel> updateUserInfo(Map<String, dynamic> userInfo);

  /// 退出登录
  Future<void> logout();
}
