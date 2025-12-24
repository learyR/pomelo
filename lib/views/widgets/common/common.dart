/// 通用组件库
/// 
/// 提供一系列可复用的通用组件，可在任何 Flutter 应用中即插即用
/// 
/// 使用示例：
/// ```dart
/// import 'package:your_app/views/widgets/common/common.dart';
/// 
/// // 使用按钮
/// AppButton(
///   text: '点击我',
///   onPressed: () => print('Button clicked'),
/// )
/// 
/// // 使用输入框
/// AppTextField(
///   hintText: '请输入内容',
///   onChanged: (value) => print(value),
/// )
/// 
/// // 使用卡片
/// AppCard(
///   child: Text('卡片内容'),
///   onTap: () => print('Card tapped'),
/// )
/// ```
library;

// 按钮组件
export 'app_button.dart';

// 输入框组件
export 'app_text_field.dart';

// 卡片组件
export 'app_card.dart';

// 徽章和标签组件
export 'app_badge.dart';

// 头像组件
export 'app_avatar.dart';

// 图标按钮组件
export 'app_icon_button.dart';

// 分隔线和间距组件
export 'app_divider.dart';

// 搜索框组件
export 'app_search_bar.dart';

// AppBar 组件
export 'app_app_bar.dart';

