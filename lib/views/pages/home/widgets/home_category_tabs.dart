import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';

import '../../../widgets/helper/view_helper.dart';

/// 首页分类导航标签
class HomeCategoryTabs extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onCategoryTap;

  const HomeCategoryTabs({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  State<HomeCategoryTabs> createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.errorLight,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  widget.categories.length,
                  (index) => _buildCategoryTab(index),
                ),
              ),
            ),
          ),
          // 右侧搜索和分类图标
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO: 跳转到搜索页
                  },
                ),
                Gaps.hGap8,
                GestureDetector(
                  onTap: () {
                    // TODO: 跳转到分类页
                  },
                  child: const Text(
                    '分类',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(int index) {
    final isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onCategoryTap?.call(index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          widget.categories[index],
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
