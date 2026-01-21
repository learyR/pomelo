import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/utils/image_util.dart';

import '../../../widgets/helper/view_helper.dart';

/// 拼团商品数据模型
class GroupBuyProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double groupPrice;
  final double originalPrice;
  final int totalCount;
  final int soldCount;
  final List<String> tags;
  final Duration? countdown; // 倒计时
  final bool showVipTip; // 是否显示VIP提示

  const GroupBuyProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.groupPrice,
    required this.originalPrice,
    required this.totalCount,
    required this.soldCount,
    required this.tags,
    this.countdown,
    this.showVipTip = false,
  });

  double get progress => soldCount / totalCount;
}

/// 首页商品列表组件
class HomeProductList extends StatefulWidget {
  const HomeProductList({super.key});

  @override
  State<HomeProductList> createState() => _HomeProductListState();
}

class _HomeProductListState extends State<HomeProductList> {
  Timer? _countdownTimer;

  // 模拟数据
  final List<GroupBuyProduct> _products = [
    GroupBuyProduct(
      id: '1',
      name: '华为荣耀平板V6',
      imageUrl: '',
      groupPrice: 2219,
      originalPrice: 2523,
      totalCount: 500,
      soldCount: 160,
      tags: const ['国行正品', '顺丰包邮'],
      countdown: const Duration(hours: 5, minutes: 11, seconds: 25),
    ),
    GroupBuyProduct(
      id: '2',
      name: '小米手机10Pro',
      imageUrl: '',
      groupPrice: 3289,
      originalPrice: 3699,
      totalCount: 100,
      soldCount: 60,
      tags: const ['国行正品', '顺丰包邮'],
      countdown: const Duration(hours: 4, minutes: 6, seconds: 51),
    ),
    GroupBuyProduct(
      id: '3',
      name: 'IMAC 苹果一体机',
      imageUrl: '',
      groupPrice: 23289,
      originalPrice: 25699,
      totalCount: 60,
      soldCount: 32,
      tags: const ['国行正品', '顺丰包邮'],
      countdown: const Duration(hours: 2, minutes: 29, seconds: 40),
    ),
    GroupBuyProduct(
      id: '4',
      name: 'Switch游戏机 任天堂',
      imageUrl: '',
      groupPrice: 1999,
      originalPrice: 2299,
      totalCount: 60,
      soldCount: 32,
      tags: const ['国行正品', '顺丰包邮'],
      showVipTip: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String _formatCountdown(Duration? duration) {
    if (duration == null) return '';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '距结束: ${hours.toString().padLeft(2, '0')} ${minutes.toString().padLeft(2, '0')} ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_products[index]);
      },
    );
  }

  Widget _buildProductCard(GroupBuyProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 倒计时
          if (product.countdown != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _formatCountdown(product.countdown),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.errorLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图片
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: product.imageUrl.isEmpty
                    ? const Icon(
                        CupertinoIcons.photo,
                        size: 40,
                        color: AppColors.textMediumGray,
                      )
                    : ImageUtil.buildImage(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              Gaps.hGap12,
              // 商品信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品名称
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap8,
                    // 标签
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: product.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.errorLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Gaps.vGap8,
                    // 进度条
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: product.progress,
                            backgroundColor: AppColors.backgroundGray,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.errorLight,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        Gaps.vGap4,
                        Text(
                          '共${product.totalCount}件 已抢${product.soldCount}件',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMediumGray,
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap8,
                    // 价格和按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '¥${product.groupPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.errorLight,
                                  ),
                                ),
                                Gaps.hGap8,
                                Text(
                                  '¥${product.originalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMediumGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // 立即拼团按钮
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '立即拼团',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // VIP提示
          if (product.showVipTip)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.iconDiamond,
                    width: 16,
                    height: 16,
                  ),
                  Gaps.hGap4,
                  const Text(
                    '充值VIP可领取更多红包',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
