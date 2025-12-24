import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/local_storage.dart';
import 'services/network/api_define.dart';
import 'utils/logger_util.dart';
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
