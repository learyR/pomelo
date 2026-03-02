// 基础 Flutter 组件测试：验证应用能正常挂载并渲染（与 main.dart 一致地使用 ProviderScope）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomelo/main.dart';

void main() {
  testWidgets('App smoke test: mounts with ProviderScope', (WidgetTester tester) async {
    // 与 main.dart 一致：MyApp 必须在 ProviderScope 下才能使用 Riverpod（如 SplashPage）
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // 仅做冒烟测试：MaterialApp.router 已挂载即可
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
