/*
 * @Author: leary 727630072@qq.com
 * @Date: 2025-12-23 14:42:18
 * @LastEditors: leary 727630072@qq.com
 * @LastEditTime: 2026-01-05 17:21:38
 * @FilePath: \pomelo\lib\main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/local_storage.dart';
import 'services/network/api_define.dart';
import 'utils/logger_util.dart';
import 'utils/status_bar_util.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await LocalStorage.init();

  // 初始化API配置
  ApiDefine.init(
    baseUrl: AppConstants.baseUrl,
    getTokenCallback: () => LocalStorage.getToken(),
    clearTokenCallback: () => LocalStorage.removeToken(),
    logCallback: (level, message) {
      switch (level) {
        case 'debug':
          LoggerUtil.debug(message);
          break;
        case 'error':
          LoggerUtil.error(message);
          break;
        default:
          LoggerUtil.info(message);
      }
    },
  );

  // 设置全局默认状态栏样式（深色图标，适用于浅色背景）
  StatusBarUtil.setDefaultStyle();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pomelo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
