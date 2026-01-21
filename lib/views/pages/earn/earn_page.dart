import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';

/// 赚取现金页面
class EarnPage extends StatelessWidget {
  const EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('赚取现金'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '赚取现金页面',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textMediumGray,
          ),
        ),
      ),
    );
  }
}
