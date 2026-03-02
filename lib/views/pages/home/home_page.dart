import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomelo/core/constants/resources.dart';
import 'package:pomelo/utils/status_bar_util.dart';

import '../../widgets/common/common.dart';
import '../../widgets/helper/view_helper.dart';
import 'widgets/home_banner.dart';
import 'widgets/home_category_tabs.dart';
import 'widgets/home_offer_cards.dart';
import 'widgets/home_product_list.dart';
import 'widgets/home_time_slots.dart';

/// 首页
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StatusBarWrapper(
      lightIcons: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // 顶部Header
            _buildHeader(),
            // 分类导航
            SliverToBoxAdapter(
              child: HomeCategoryTabs(
                categories: const [
                  '首页',
                  '生活用品',
                  '电器家具',
                  '干货食品',
                  '潮流',
                ],
                onCategoryTap: (index) {
                  // TODO: 处理分类点击
                },
              ),
            ),
            // 促销横幅
            SliverToBoxAdapter(
              child: HomeBanner(),
            ),
            // 特殊优惠卡片
            SliverToBoxAdapter(
              child: HomeOfferCards(),
            ),
            // 热门拼团标题和时间槽
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.iconClock,
                          width: 20,
                          height: 20,
                        ),
                        Gaps.hGap8,
                        const Text(
                          '热门拼团',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HomeTimeSlots(
                    timeSlots: const [
                      TimeSlot(time: '14:00', status: TimeSlotStatus.onSale),
                      TimeSlot(time: '16:00', status: TimeSlotStatus.comingSoon),
                      TimeSlot(time: '18:00', status: TimeSlotStatus.comingSoon),
                      TimeSlot(time: '20:00', status: TimeSlotStatus.comingSoon),
                      TimeSlot(time: '22:00', status: TimeSlotStatus.comingSoon),
                    ],
                    onTimeSlotTap: (index) {
                      // TODO: 处理时间槽点击
                    },
                  ),
                ],
              ),
            ),
            // 商品列表
            SliverToBoxAdapter(
              child: HomeProductList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部Header
  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.errorLight,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.bars,
            color: AppColors.white,
          ),
          onPressed: () {
            // TODO: 处理菜单
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '购啦',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        expandedTitleScale: 1.0,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              // TODO: 跳转到搜索页
            },
            child: AppTextField(
              hintText: '卡西欧手表',
              prefixIcon: CupertinoIcons.search,
              fillColor: AppColors.white,
              borderColor: Colors.transparent,
              focusedBorderColor: Colors.transparent,
              borderRadius: 20,
              readOnly: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
