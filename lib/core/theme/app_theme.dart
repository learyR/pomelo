import 'package:flutter/material.dart';
import '../constants/resources.dart';

/// 应用主题配置
///
/// 使用 AppColors 中的颜色定义进行主题配置
class AppTheme {
  AppTheme._(); // 私有构造函数，防止实例化

  // ========== 主色调（从 AppColors 获取）==========

  /// 主题色
  static const Color primaryColor = AppColors.primary;

  /// 次要主题色（如果 AppColors 中没有，使用备选色）
  static const Color secondaryColor = AppColors.info;

  /// 强调色
  static const Color accentColor = AppColors.warning;

  // ========== 文本颜色（从 AppColors 获取）==========

  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textHint = AppColors.textHint;
  static const Color textDisabled = AppColors.textDisabled;

  // ========== 背景颜色（从 AppColors 获取）==========

  static const Color backgroundLight = AppColors.background;
  static const Color backgroundWhite = AppColors.backgroundLight;
  static const Color backgroundDark = Color(0xFF121212); // 深色背景
  static const Color backgroundGray = AppColors.backgroundGray;
  static const Color backgroundDisabled = AppColors.backgroundDisabled;

  // ========== 边框颜色（从 AppColors 获取）==========

  static const Color borderColor = AppColors.border;
  static const Color dividerColor = AppColors.divider;

  // ========== 状态颜色（从 AppColors 获取）==========

  static const Color errorColor = AppColors.error;
  static const Color successColor = AppColors.success;
  static const Color warningColor = AppColors.warning;
  static const Color infoColor = AppColors.info;

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: backgroundWhite,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onError: AppColors.white,
        onSurface: textPrimary,
        surfaceContainerHighest: backgroundGray,
        onSurfaceVariant: textSecondary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundWhite,
        foregroundColor: textPrimary,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: const Color(0xFF1E1E1E),
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onError: AppColors.white,
        onSurface: AppColors.backgroundVeryLightGray,
        surfaceContainerHighest: const Color(0xFF2C2C2C),
        onSurfaceVariant: AppColors.textLightGray,
      ),
      scaffoldBackgroundColor: backgroundDark,

      // AppBar 主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: AppColors.backgroundVeryLightGray,
        iconTheme: IconThemeData(color: AppColors.backgroundVeryLightGray),
        titleTextStyle: TextStyle(
          color: AppColors.backgroundVeryLightGray,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card 主题
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1E1E1E),
        shadowColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ElevatedButton 主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton 主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // OutlinedButton 主题
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // InputDecoration 主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: AppColors.textMediumGray.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: AppColors.textMediumGray.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: AppColors.textMediumGray.withValues(alpha: 0.3)),
        ),
        hintStyle: TextStyle(color: AppColors.textHint),
        labelStyle: TextStyle(color: AppColors.textLightGray),
        errorStyle: const TextStyle(color: errorColor),
      ),

      // Divider 主题
      dividerTheme: DividerThemeData(
        color: AppColors.textMediumGray.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // Icon 主题
      iconTheme: const IconThemeData(
        color: AppColors.backgroundVeryLightGray,
        size: 24,
      ),

      // Text 主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 57,
            fontWeight: FontWeight.w400),
        displayMedium: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 45,
            fontWeight: FontWeight.w400),
        displaySmall: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 36,
            fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 32,
            fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 28,
            fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 24,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 22,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 14,
            fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            color: AppColors.textLightGray,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            color: AppColors.backgroundVeryLightGray,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        labelMedium: TextStyle(
            color: AppColors.textLightGray,
            fontSize: 12,
            fontWeight: FontWeight.w500),
        labelSmall: TextStyle(
            color: AppColors.textHint,
            fontSize: 11,
            fontWeight: FontWeight.w500),
      ),

      // Checkbox 主题
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
      ),

      // Switch 主题
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return AppColors.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return AppColors.textMediumGray.withValues(alpha: 0.3);
        }),
      ),

      // Radio 主题
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return AppColors.textHint;
        }),
      ),
    );
  }
}
