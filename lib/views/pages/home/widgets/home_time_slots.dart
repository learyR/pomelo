import 'package:flutter/material.dart';
import 'package:pomelo/core/constants/resources.dart';

import '../../../widgets/helper/view_helper.dart';

/// 时间槽状态
enum TimeSlotStatus {
  onSale, // 抢购中
  comingSoon, // 即将开始
}

/// 时间槽数据模型
class TimeSlot {
  final String time;
  final TimeSlotStatus status;

  const TimeSlot({
    required this.time,
    required this.status,
  });
}

/// 首页时间槽组件
class HomeTimeSlots extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final ValueChanged<int>? onTimeSlotTap;

  const HomeTimeSlots({
    super.key,
    required this.timeSlots,
    this.onTimeSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final slot = timeSlots[index];
          final isSelected = slot.status == TimeSlotStatus.onSale;
          return GestureDetector(
            onTap: () => onTimeSlotTap?.call(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.errorLight
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.errorLight
                      : AppColors.borderGray,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slot.time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textDark,
                    ),
                  ),
                  Gaps.vGap4,
                  Text(
                    slot.status == TimeSlotStatus.onSale
                        ? '抢购中'
                        : '即将开始',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textMediumGray,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
