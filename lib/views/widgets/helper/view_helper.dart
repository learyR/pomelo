import 'package:flutter/material.dart';

import '../../../core/constants/resources.dart';

/// 间距工具类
///
/// 提供统一的间距常量，避免硬编码
class Gaps {
  Gaps._();

  /// 水平间隔
  static const Widget hGap4 = SizedBox(width: 4);
  static const Widget hGap5 = SizedBox(width: 5);
  static const Widget hGap8 = SizedBox(width: 8);
  static const Widget hGap10 = SizedBox(width: 10);
  static const Widget hGap12 = SizedBox(width: 12);
  static const Widget hGap15 = SizedBox(width: 15);
  static const Widget hGap16 = SizedBox(width: 16);
  static const Widget hGap18 = SizedBox(width: 18);
  static const Widget hGap20 = SizedBox(width: 20);
  static const Widget hGap24 = SizedBox(width: 24);
  static const Widget hGap32 = SizedBox(width: 32);

  /// 垂直间隔
  static const Widget vGap4 = SizedBox(height: 4);
  static const Widget vGap5 = SizedBox(height: 5);
  static const Widget vGap8 = SizedBox(height: 8);
  static const Widget vGap10 = SizedBox(height: 10);
  static const Widget vGap12 = SizedBox(height: 12);
  static const Widget vGap15 = SizedBox(height: 15);
  static const Widget vGap16 = SizedBox(height: 16);
  static const Widget vGap18 = SizedBox(height: 18);
  static const Widget vGap20 = SizedBox(height: 20);
  static const Widget vGap24 = SizedBox(height: 24);
  static const Widget vGap32 = SizedBox(height: 32);
  static const Widget vGap50 = SizedBox(height: 50);

  /// 分隔线（使用主题颜色）
  static Widget line({Color? color, double? height, double? thickness}) {
    return Divider(
      color: color ?? AppColors.divider,
      height: height ?? 1.0,
      thickness: thickness ?? 0.5,
    );
  }

  /// 默认分隔线
  static const Widget defaultLine = Divider(
    color: AppColors.divider,
    height: 1.0,
    thickness: 0.5,
  );

  /// 垂直分隔线（使用主题颜色）
  static Widget vLine({Color? color, double? width, double? height}) {
    return SizedBox(
      width: width ?? 0.6,
      height: height ?? 24.0,
      child: VerticalDivider(
        color: color ?? AppColors.divider,
        width: width ?? 0.6,
        thickness: 0.5,
      ),
    );
  }

  /// 默认垂直分隔线
  static const Widget defaultVLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: VerticalDivider(
      color: AppColors.divider,
      width: 0.6,
      thickness: 0.5,
    ),
  );

  /// 空Widget
  static const Widget empty = SizedBox.shrink();

  /// 常用Padding
  static const EdgeInsets padding4 = EdgeInsets.all(4);
  static const EdgeInsets padding5 = EdgeInsets.all(5);
  static const EdgeInsets padding8 = EdgeInsets.all(8);
  static const EdgeInsets padding10 = EdgeInsets.all(10);
  static const EdgeInsets padding12 = EdgeInsets.all(12);
  static const EdgeInsets padding16 = EdgeInsets.all(16);

  /// 常用水平Padding
  static const EdgeInsets paddingH4 = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets paddingH5 = EdgeInsets.symmetric(horizontal: 5);
  static const EdgeInsets paddingH8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets paddingH10 = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets paddingH12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets paddingH16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingH20 = EdgeInsets.symmetric(horizontal: 20);

  /// 常用垂直Padding
  static const EdgeInsets paddingV4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets paddingV8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets paddingV10 = EdgeInsets.symmetric(vertical: 10);
  static const EdgeInsets paddingV12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets paddingV16 = EdgeInsets.symmetric(vertical: 16);

  /// 常用Margin
  static const EdgeInsets margin10 = EdgeInsets.all(10);
  static const EdgeInsets marginH10 = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets marginV10 = EdgeInsets.symmetric(vertical: 10);
}

/// 文本样式工具类
///
/// 提供统一的文本样式常量，避免硬编码
class TextStyles {
  TextStyles._();

  /// 基础字号样式
  static const TextStyle textSize8 = TextStyle(fontSize: 8);
  static const TextStyle textSize10 = TextStyle(fontSize: 10);
  static const TextStyle textSize12 = TextStyle(fontSize: 12);
  static const TextStyle textSize13 = TextStyle(fontSize: 13);
  static const TextStyle textSize14 = TextStyle(fontSize: 14);
  static const TextStyle textSize16 = TextStyle(fontSize: 16);
  static const TextStyle textSize18 = TextStyle(fontSize: 18);
  static const TextStyle textSize20 = TextStyle(fontSize: 20);
  static const TextStyle textSize24 = TextStyle(fontSize: 24);
  static const TextStyle textSize26 = TextStyle(fontSize: 26);
  static const TextStyle textSize35 = TextStyle(fontSize: 35);

  /// 加粗样式
  static const TextStyle textBold12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold26 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textBold35 = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  /// 白色文本样式
  static const TextStyle textWhite8 = TextStyle(
    fontSize: 8,
    color: AppColors.white,
  );
  static const TextStyle textWhite12 = TextStyle(
    fontSize: 12,
    color: AppColors.white,
  );
  static const TextStyle textWhite13 = TextStyle(
    fontSize: 13,
    color: AppColors.white,
  );
  static const TextStyle textWhite14 = TextStyle(
    fontSize: 14,
    color: AppColors.white,
  );
  static const TextStyle textWhite16 = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );
  static const TextStyle textWhite18 = TextStyle(
    fontSize: 18,
    color: AppColors.white,
  );
  static const TextStyle textWhite35 = TextStyle(
    fontSize: 35,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  /// 灰色文本样式
  static const TextStyle textGray12 = TextStyle(
    fontSize: 12,
    color: AppColors.textLightGray,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle textGray14 = TextStyle(
    fontSize: 14,
    color: AppColors.textLightGray,
  );
  static const TextStyle textDarkGray12 = TextStyle(
    fontSize: 12,
    color: AppColors.textDarkGray,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle textDarkGray14 = TextStyle(
    fontSize: 14,
    color: AppColors.textDarkGray,
  );

  /// 高亮文本样式（主题色）
  static const TextStyle textHighLight12 = TextStyle(
    fontSize: 12,
    color: AppColors.primary,
  );
  static const TextStyle textHighLight14 = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
  );
  static const TextStyle textHighLight18 = TextStyle(
    fontSize: 18,
    color: AppColors.primary,
  );

  /// 白色半透明文本样式
  static const TextStyle textWhiteDim12 = TextStyle(
    fontSize: 12,
    color: AppColors.overlayWhite,
  );
  static const TextStyle textWhiteDim14 = TextStyle(
    fontSize: 14,
    color: AppColors.overlayWhite,
  );
  static const TextStyle textWhite70 = TextStyle(
    fontSize: 12,
    color: AppColors.overlayWhite,
  );

  /// 基础文本样式
  static const TextStyle text = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    textBaseline: TextBaseline.alphabetic,
  );
  static const TextStyle textDark = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
    textBaseline: TextBaseline.alphabetic,
  );

  /// 提示文本样式
  static const TextStyle textHint14 =
      TextStyle(fontSize: 14, color: AppColors.textHint);

  /// 标题样式
  static const TextStyle title18 =
      TextStyle(fontSize: 18, color: AppColors.white);
  static const TextStyle title18Bold = TextStyle(
      fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold);

  // ========== 主题相关文本样式 ==========

  /// 主要文本样式（使用主题色）
  static const TextStyle textPrimary12 = TextStyle(
    fontSize: 12,
    color: AppColors.textPrimary,
  );
  static const TextStyle textPrimary14 = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const TextStyle textPrimary16 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  static const TextStyle textPrimary18 = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
  );

  /// 次要文本样式
  static const TextStyle textSecondary12 = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static const TextStyle textSecondary14 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  static const TextStyle textSecondary16 = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  /// 主题色文本样式
  static const TextStyle textPrimaryColor12 = TextStyle(
    fontSize: 12,
    color: AppColors.primary,
  );
  static const TextStyle textPrimaryColor14 = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
  );
  static const TextStyle textPrimaryColor16 = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
  );
  static const TextStyle textPrimaryColor18 = TextStyle(
    fontSize: 18,
    color: AppColors.primary,
  );

  /// 成功文本样式
  static const TextStyle textSuccess12 = TextStyle(
    fontSize: 12,
    color: AppColors.success,
  );
  static const TextStyle textSuccess14 = TextStyle(
    fontSize: 14,
    color: AppColors.success,
  );

  /// 警告文本样式
  static const TextStyle textWarning12 = TextStyle(
    fontSize: 12,
    color: AppColors.warning,
  );
  static const TextStyle textWarning14 = TextStyle(
    fontSize: 14,
    color: AppColors.warning,
  );

  /// 错误文本样式
  static const TextStyle textError12 = TextStyle(
    fontSize: 12,
    color: AppColors.error,
  );
  static const TextStyle textError14 = TextStyle(
    fontSize: 14,
    color: AppColors.error,
  );
  static const TextStyle textError16 = TextStyle(
    fontSize: 16,
    color: AppColors.error,
  );

  /// 禁用文本样式
  static const TextStyle textDisabled12 = TextStyle(
    fontSize: 12,
    color: AppColors.textDisabled,
  );
  static const TextStyle textDisabled14 = TextStyle(
    fontSize: 14,
    color: AppColors.textDisabled,
  );
}
