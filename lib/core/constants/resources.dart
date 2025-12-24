import 'package:flutter/material.dart';

/// 应用颜色定义
/// 
/// 按功能分类组织的颜色常量，使用语义化命名
class AppColors {
  AppColors._(); // 私有构造函数，防止实例化

  // ========== 基础颜色 ==========
  
  /// 透明色
  static const Color transparent = Color(0x00000000);
  
  /// 白色
  static const Color white = Color(0xFFFFFFFF);
  
  /// 黑色
  static const Color black = Color(0xFF000000);

  // ========== 主色调 ==========
  
  /// 主题色 - 蓝色
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF003087);
  static const Color primaryLight = Color(0xFF16A0F8);
  static const Color primaryAlpha = Color(0xB316A0F8);

  // ========== 文本颜色 ==========
  
  /// 主要文本颜色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);
  
  /// 深色文本
  static const Color textDark = Color(0xFF2A2A2A);
  static const Color textDarkGray = Color(0xFF3A3A3A);
  static const Color textMediumGray = Color(0xFF666666);
  static const Color textLightGray = Color(0xFF999999);
  static const Color textVeryLightGray = Color(0xFFCCCCCC);

  // ========== 背景颜色 ==========
  
  /// 页面背景
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color backgroundLightGray = Color(0xFFF9F9F9);
  static const Color backgroundVeryLightGray = Color(0xFFF0F0F0);
  static const Color backgroundDisabled = Color(0xFFE6E7E9);

  // ========== 边框颜色 ==========
  
  /// 边框颜色
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFDDDDDD);
  static const Color borderGray = Color(0xFFCCCCCC);
  static const Color divider = Color(0xFFE5EDF3);

  // ========== 状态颜色 ==========
  
  /// 成功/绿色
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF3B905F);
  static const Color successLight = Color(0xFF17CA6F);
  
  /// 警告/橙色
  static const Color warning = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFEC5E32);
  static const Color warningLight = Color(0xFFF89B16);
  
  /// 错误/红色
  static const Color error = Color(0xFFE53935);
  static const Color errorDark = Color(0xFFEA3232);
  static const Color errorLight = Color(0xFFFF3E3E);
  static const Color errorPink = Color(0xFFF82C5C);
  
  /// 信息/蓝色
  static const Color info = Color(0xFF1296DB);
  static const Color infoDark = Color(0xFF1478EA);

  // ========== 半透明遮罩 ==========
  
  /// 半透明黑色遮罩
  static const Color overlayBlack = Color(0x80000000);
  static const Color overlayBlackLight = Color(0x40000000);
  
  /// 半透明白色遮罩
  static const Color overlayWhite = Color(0x80FFFFFF);
}

/// 应用图片资源路径
/// 
/// 统一管理所有图片资源路径，按功能模块分类
class AppImages {
  AppImages._(); // 私有构造函数，防止实例化

  /// 图片资源基础路径
  static const String _basePath = 'assets/images/';

  // ========== 通用资源 ==========
  
  /// Logo
  static const String logo = '${_basePath}logo.png';
  static const String appLogo = '${_basePath}app_logo.png';
  static const String logoWithShadow = '${_basePath}image_logo_with_shadow.png';
  
  /// 默认图片
  static const String defaultPortrait = '${_basePath}default_portrait.png';
  static const String defaultImage = '${_basePath}image_default.png';
  
  /// 背景图
  static const String bgSplash = '${_basePath}bg_splash.png';
  static const String bgLogin = '${_basePath}bg_login.png';
  static const String bgHomepageTop = '${_basePath}bg_homepage_top.png';
  static const String bgHomepageTop1 = '${_basePath}bg_homepage_top1.png';
  static const String bgIngotsTop = '${_basePath}bg_ingots_top.png';
  static const String bgInviteCode = '${_basePath}bg_invite_code.png';
  static const String bgRootTop = '${_basePath}image_root_toop_bg.png';
  static const String bgGoodsInfo = '${_basePath}image_goods_info_bg.png';

  // ========== 图标 - 导航 ==========
  
  /// 返回箭头
  static const String iconBackArrow = '${_basePath}icon_back_arrow.png';
  static const String iconArrowBlackBack = '${_basePath}arrow_black_back_.png';
  
  /// 底部导航图标
  static const String iconHome = '${_basePath}icon_homepage.png';
  static const String iconHomeFill = '${_basePath}icon_homepage_fill.png';
  static const String iconIngots = '${_basePath}icon_ingots.png';
  static const String iconIngotsFill = '${_basePath}icon_ingots_fill.png';
  static const String iconMine = '${_basePath}icon_mine.png';
  static const String iconMineFill = '${_basePath}icon_mine_fill.png';
  static const String iconContact = '${_basePath}icon_contact.png';
  static const String iconContactFill = '${_basePath}icon_contact_fill.png';

  // ========== 图标 - 功能 ==========
  
  /// 搜索
  static const String iconHomeSearch = '${_basePath}icon_home_search.png';
  static const String iconCategorySearch = '${_basePath}icon_category_search.png';
  
  /// 用户相关
  static const String iconGrayUser = '${_basePath}icon_gray_user.png';
  static const String iconGrayLock = '${_basePath}icon_gray_lock.png';
  
  /// 登录方式
  static const String iconWechat = '${_basePath}icon_wechat.png';
  static const String iconWechatCircle = '${_basePath}icon_wechat_circle.png';
  static const String iconApple = '${_basePath}icon_apple.png';
  static const String iconEmail = '${_basePath}icon_email.png';
  
  /// 其他功能
  static const String iconQrCode = '${_basePath}icon_qr_code.png';
  static const String iconPhone = '${_basePath}icon_phone.png';
  static const String iconShare = '${_basePath}icon_share.png';
  static const String iconEdit = '${_basePath}icon_edit.png';
  static const String iconDelete = '${_basePath}icon_delete.png';
  static const String iconDeleteWithBg = '${_basePath}icon_delete_with_bg.png';
  static const String iconMore = '${_basePath}icon_more.png';
  static const String iconHomeMore = '${_basePath}icon_home_more.png';
  static const String iconLink = '${_basePath}icon_link.png';
  static const String iconLinkP = '${_basePath}icon_link_p.png';
  static const String iconDiamond = '${_basePath}icon_diamond.png';
  static const String iconHot = '${_basePath}icon_hot.png';
  static const String iconClock = '${_basePath}icon_homepage_clock.png';
  static const String iconRightRed = '${_basePath}icon_right_red.png';
  static const String iconConsumer = '${_basePath}icon_consumer.png';
  static const String iconInviteCode = '${_basePath}icon_invite_code.png';
  static const String iconVipWhite = '${_basePath}icon_vip_white.png';
  static const String iconBank = '${_basePath}icon_bank.png';
  static const String iconAli = '${_basePath}icon_ali.png';
  static const String iconMenuUpArrow = 'assets/images/menu_up_arrow.png';

  // ========== 图标 - IM聊天 ==========
  
  static const String iconImVoice = '${_basePath}icon_im_voice.png';
  static const String iconImMore = '${_basePath}icon_im_more.png';
  static const String iconImFace = '${_basePath}icon_im_face.png';
  static const String iconImKeyboard = '${_basePath}icon_im_keyboard.png';
  static const String iconPhoto = '${_basePath}icon_photo.png';
  static const String iconVideo = '${_basePath}icon_video.png';
  static const String iconFile = '${_basePath}icon_file.png';
  static const String iconCamera = '${_basePath}icon_camera.png';
  static const String iconPicture = '${_basePath}icon_picture.png';
  static const String iconSend = '${_basePath}icon_send.png';
  static const String iconPushDelete = '${_basePath}icon_push_delete.png';
  static const String iconAddressDivideLine = '${_basePath}address_divid_line.png';

  // ========== 个人中心图标 ==========
  
  static const String mineAddress = '${_basePath}mine_adress.png';
  static const String mineCall = '${_basePath}mine_call.png';
  static const String mineCoupon = '${_basePath}mine_cupon.png';
  static const String mineGroup = '${_basePath}mine_group.png';
  static const String mineInvite = '${_basePath}mine_invite.png';
  static const String mineLikes = '${_basePath}mine_likes.png';
  static const String mineOrders = '${_basePath}mine_orders.png';
  static const String mineService = '${_basePath}mine_service.png';
  static const String mineSettings = '${_basePath}mine_settings.png';
  static const String mineVip = '${_basePath}mine_vip.png';
  static const String mineWallet = '${_basePath}mine_wallet.png';
  static const String mineWillReceive = '${_basePath}mine_will_receive.png';
  static const String mineRecommend = '${_basePath}mine_recommend.png';
  static const String mineWithdrawBg = '${_basePath}mine_withdraw_bg.png';

  // ========== 会员相关 ==========
  
  static const String mineVipIcon = '${_basePath}mine_vip_icon.png';
  static const String mineVipTagBg = '${_basePath}mine_vip_tag_bg.png';
  static const String mineVipCorrect = '${_basePath}mine_vip_correct.png';

  // ========== 状态图片 ==========
  
  /// 支付相关
  static const String imagePaySuccess = '${_basePath}image_pay_success.png';
  static const String imagePayFail = '${_basePath}image_pay_fail.png';
  
  /// 提现相关
  static const String imageWithdrawSuccess = '${_basePath}image_withdraw_success.png';
  static const String imageWithdrawFail = '${_basePath}image_withdraw_fail.png';
  static const String imageWithdrawBind = '${_basePath}image_widthdraw_bind.png';
  
  /// 拼团相关
  static const String imageJoinGroupSuccess = '${_basePath}image_join_group_success.png';
  static const String imageJoinGroupFail = '${_basePath}image_join_group_fail.png';
  
  /// 优惠券
  static const String imageCouponOpen = '${_basePath}image_coupon_open.png';
  static const String imageCouponClose = '${_basePath}image_new_user_coupon.png';
  
  /// 网络错误
  static const String imageNetworkError = '${_basePath}image_network_error.png';
}

/// 图标字体资源
/// 
/// 统一管理自定义图标字体
class AppIcons {
  AppIcons._(); // 私有构造函数，防止实例化

  /// 图标字体族名称
  static const String fontFamily = 'iconfont';

  /// 空页面图标
  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  
  /// 错误页面图标
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  
  /// 网络错误图标
  static const IconData pageNetworkError = IconData(0xe678, fontFamily: fontFamily);
  
  /// 未授权图标
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);
}

