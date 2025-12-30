import 'package:flutter/material.dart';

import '../../core/constants/resources.dart';
import 'view_state.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  const ViewStateBusyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator.center();
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback? onPressed;

  const ViewStateWidget(
      {super.key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      this.onPressed,
      this.buttonTextData});

  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: SizedBox(height: 1)),
        image ?? Icon(AppIcons.pageError, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? "加载失败",
                style: titleStyle,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Center(
          child: ViewStateButton(
              textData: buttonTextData,
              onPressed: onPressed,
              child: buttonText),
        ),
        Expanded(child: SizedBox(height: 1)),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    super.key,
    required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Image defaultImage;
    String defaultTitle;
    var errorMessage = error.message;
    String defaultTextData = '重试';
    switch (error.errorType) {
      case ViewStateErrorType.networkTimeOutError:
        defaultImage =
            Image.asset(AppImages.imageNetworkError, height: 120, width: 150);
        defaultTitle = '网络出问题了，快去检查一下吧~';
        break;
      case ViewStateErrorType.defaultError:
        defaultImage =
            Image.asset(AppImages.imageNetworkError, height: 120, width: 150);
        defaultTitle = '加载失败';
        break;
      case ViewStateErrorType.emptyError:
        defaultImage =
            Image.asset(AppImages.imageNetworkError, height: 120, width: 150);
        defaultTitle = '空空如也';
        break;
      case ViewStateErrorType.unauthorizedError:
        return ViewStateUnAuthWidget(
          image: image,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
    }

    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage ?? '',
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback? onPressed;

  const ViewStateEmptyWidget(
      {super.key, this.image, this.message, this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image: image ??
          Image.asset(AppImages.imageNetworkError, height: 120, width: 150),
      title: message ?? '空空如也',
      buttonText: buttonText,
      buttonTextData: '刷新一下',
      message: '',
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback onPressed;

  const ViewStateUnAuthWidget(
      {super.key,
      this.image,
      this.message,
      this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? ViewStateUnAuthImage(),
      title: message ?? '未登录',
      buttonText: buttonText,
      buttonTextData: '登录',
      message: '',
    );
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  const ViewStateUnAuthImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loginLogo',
      child: Image.asset(
        AppImages.logoWithShadow,
        width: 130,
        height: 100,
        fit: BoxFit.fitWidth,
        color: Theme.of(context).colorScheme.secondary,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? textData;

  const ViewStateButton({required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: child ??
          Text(
            textData ?? '重试',
            style: TextStyle(wordSpacing: 5, color: Colors.white),
          ),
      color: Colors.blue,
      // style: ButtonStyle(
      //     textStyle: MaterialStateProperty.all(
      //   TextStyle(
      //     color: Colors.grey,
      //   ),
      // )),
      onPressed: onPressed,
    );
  }
}

/// 统一的加载指示器组件
///
/// 用于统一管理应用中所有 CircularProgressIndicator 的颜色和样式
/// 默认使用白色，适用于深色背景
class LoadingIndicator extends StatelessWidget {
  /// 指示器颜色，默认为白色
  final Color? color;

  /// 指示器大小（strokeWidth），默认为 4.0
  final double strokeWidth;

  /// 是否居中显示，默认为 false
  final bool center;

  /// 自定义大小（用于 SizedBox 包裹）
  final double? size;

  /// 创建加载指示器
  ///
  /// [color] 指示器颜色，默认为白色
  /// [strokeWidth] 指示器线条宽度，默认为 4.0
  /// [center] 是否居中显示，默认为 false
  /// [size] 自定义大小（用于 SizedBox 包裹），如果指定则包裹在 SizedBox 中
  const LoadingIndicator({
    super.key,
    this.color,
    this.strokeWidth = 4.0,
    this.center = false,
    this.size,
  });

  /// 创建居中的加载指示器
  ///
  /// 便捷方法，用于快速创建居中显示的加载指示器
  const LoadingIndicator.center({
    super.key,
    this.color,
    this.strokeWidth = 4.0,
    this.size,
  }) : center = true;

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? Colors.white,
      ),
    );

    Widget result = size != null
        ? SizedBox(width: size, height: size, child: indicator)
        : indicator;

    if (center) {
      result = Center(child: result);
    }

    return result;
  }
}
