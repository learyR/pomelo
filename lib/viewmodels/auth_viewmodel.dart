import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../utils/logger_util.dart';
import '../utils/toast_util.dart';
import '../services/local_storage.dart';

/// 认证状态
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 认证ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  final UserRepository _userRepository;

  AuthViewModel(this._userRepository) : super(const AuthState()) {
    // 初始化时检查登录状态
    _checkAuthStatus();
  }

  /// 检查认证状态
  Future<void> _checkAuthStatus() async {
    final token = LocalStorage.getToken();
    if (token != null) {
      try {
        final user = await _userRepository.getUserInfo();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
        );
      } catch (e) {
        // Token无效，清除
        await LocalStorage.removeToken();
      }
    }
  }

  /// 登录
  Future<bool> login(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final token = await _userRepository.login(username, password);
      
      // 获取用户信息
      final user = await _userRepository.getUserInfo();

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );

      ToastUtil.showSuccess('登录成功');
      return true;
    } catch (e) {
      LoggerUtil.error('登录失败', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      ToastUtil.showError(e.toString());
      return false;
    }
  }

  /// 注册
  Future<bool> register({
    required String username,
    required String password,
    String? phone,
    String? email,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _userRepository.register(
        username: username,
        password: password,
        phone: phone,
        email: email,
      );

      // 注册成功后自动登录
      final token = await _userRepository.login(username, password);
      final userInfo = await _userRepository.getUserInfo();

      state = state.copyWith(
        user: userInfo,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );

      ToastUtil.showSuccess('注册成功');
      return true;
    } catch (e) {
      LoggerUtil.error('注册失败', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      ToastUtil.showError(e.toString());
      return false;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      await _userRepository.logout();
      state = const AuthState();
      ToastUtil.showSuccess('已退出登录');
    } catch (e) {
      LoggerUtil.error('退出登录失败', e);
      // 即使失败也清除本地状态
      state = const AuthState();
      await LocalStorage.removeToken();
    }
  }

  /// 更新用户信息
  Future<void> updateUserInfo(Map<String, dynamic> userInfo) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final updatedUser = await _userRepository.updateUserInfo(userInfo);

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        error: null,
      );

      ToastUtil.showSuccess('更新成功');
    } catch (e) {
      LoggerUtil.error('更新用户信息失败', e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      ToastUtil.showError(e.toString());
    }
  }

  /// 获取当前用户
  UserModel? get currentUser => state.user;

  /// 是否已登录
  bool get isAuthenticated => state.isAuthenticated;
}

