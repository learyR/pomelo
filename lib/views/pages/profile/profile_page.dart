import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';

/// 个人中心页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('个人中心'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '个人中心页面',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textMediumGray,
          ),
        ),
      ),
    );
  }
}
