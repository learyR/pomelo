import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';

import '../../../widgets/helper/view_helper.dart';

/// 首页特殊优惠卡片
class HomeOfferCards extends StatelessWidget {
  const HomeOfferCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildLeftCard(),
          ),
          Gaps.hGap12,
          Expanded(
            child: _buildRightCard(),
          ),
        ],
      ),
    );
  }

  /// 左侧卡片（粉色背景）
  Widget _buildLeftCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '购啦生活 好物精选',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Gaps.vGap8,
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.device_phone_portrait,
                      size: 30,
                      color: AppColors.textMediumGray,
                    ),
                  ),
                ),
                Gaps.hGap8,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.cube_box,
                      size: 30,
                      color: AppColors.textMediumGray,
                    ),
                  ),
                ),
                Gaps.hGap8,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.shopping_cart,
                      size: 30,
                      color: AppColors.textMediumGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                CupertinoIcons.arrow_right,
                size: 16,
                color: AppColors.errorLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 右侧卡片（红色背景）
  Widget _buildRightCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '拼团抢红包',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Text(
            '现金红包秒秒秒',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          const Text(
            '¥9.9',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Text(
            '最高可领',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
