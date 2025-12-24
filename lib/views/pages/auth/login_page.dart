import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/validators.dart';

/// 登录页
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }
    //
    // // final authViewModel = ref.read(authViewModelProvider.notifier);
    // final success = await authViewModel.login(
    //   _usernameController.text,
    //   _passwordController.text,
    // );
    //
    // if (success && mounted) {
    //   context.pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo或标题
                Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 40),
                // 用户名输入框
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名/手机号',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: Validators.required,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                // 密码输入框
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                ),
                const SizedBox(height: 24),
                // 登录按钮
                // ElevatedButton(
                //   onPressed: authState.isLoading ? null : _handleLogin,
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 16),
                //   ),
                //   child: authState.isLoading
                //       ? const SizedBox(
                //           height: 20,
                //           width: 20,
                //           child: CircularProgressIndicator(strokeWidth: 2),
                //         )
                //       : const Text('登录'),
                // ),
                const SizedBox(height: 16),
                // 注册链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: const Text('立即注册'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
