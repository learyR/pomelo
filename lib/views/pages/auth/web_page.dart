import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/resources.dart';
import '../../widgets/common/common.dart';

/// WebView 页面
///
/// 用于显示网页内容，支持通过 URL 参数传递要加载的网页地址
class WebPage extends StatefulWidget {
  final String? url;
  final String? title;

  const WebPage({
    super.key,
    this.url,
    this.title,
  });

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _pageTitle;
  double _loadingProgress = 0.0;
  bool _isWebViewReady = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    // 延迟初始化，确保 Widget 树构建完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWebView();
    });
  }

  /// 初始化 WebView
  void _initializeWebView() {
    final url = widget.url ?? '';
    if (url.isEmpty) {
      setState(() {
        _isLoading = false;
        _isWebViewReady = true;
      });
      return;
    }

    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _loadingProgress = 0.0;
                });
              }
            },
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress / 100.0;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _loadingProgress = 1.0;
                  _isWebViewReady = true;
                });
                // 更新导航状态
                _updateNavigationState();
                // 获取页面标题
                _controller?.getTitle().then((title) {
                  if (mounted && title != null && title.isNotEmpty) {
                    setState(() {
                      _pageTitle = title;
                    });
                  }
                }).catchError((error) {
                  // 忽略获取标题的错误
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _isWebViewReady = true;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    } catch (e) {
      // 初始化失败
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isWebViewReady = true;
        });
      }
    }
  }

  /// 更新导航状态
  Future<void> _updateNavigationState() async {
    if (_controller == null || !_isWebViewReady) return;

    try {
      final canForward = await _controller!.canGoForward();
      if (mounted) {
        setState(() {
          _canGoForward = canForward;
        });
      }
    } catch (e) {
      // 忽略错误
    }
  }

  /// 刷新页面
  Future<void> _reload() async {
    if (_controller == null || !_isWebViewReady) return;
    try {
      await _controller!.reload();
    } catch (e) {
      // 忽略错误
    }
  }

  /// 返回上一页
  Future<bool> _goBack() async {
    if (_controller == null || !_isWebViewReady) {
      return true; // 关闭页面
    }

    try {
      final canBack = await _controller!.canGoBack();
      if (canBack) {
        await _controller!.goBack();
        // 更新导航状态
        _updateNavigationState();
        return false; // 不关闭页面
      }
    } catch (e) {
      // 忽略错误，直接关闭页面
    }
    return true; // 关闭页面
  }

  /// 前进
  Future<void> _goForward() async {
    if (_controller == null || !_isWebViewReady) return;
    try {
      final canForward = await _controller!.canGoForward();
      if (canForward) {
        await _controller!.goForward();
        // 更新导航状态
        _updateNavigationState();
      }
    } catch (e) {
      // 忽略错误
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title ?? _pageTitle ?? '网页';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _goBack();
          if (shouldPop && mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppAppBar(
          title: displayTitle,
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
          onBackPressed: () async {
            final shouldPop = await _goBack();
            if (shouldPop && mounted) {
              context.pop();
            }
          },
          actions: [
            // 前进按钮
            if (_canGoForward)
              IconButton(
                icon: const Icon(CupertinoIcons.forward),
                onPressed: _goForward,
                tooltip: '前进',
              ),
            // 刷新按钮
            IconButton(
              icon: const Icon(CupertinoIcons.refresh),
              onPressed: _reload,
              tooltip: '刷新',
            ),
          ],
        ),
        body: _controller == null
            ? const Center(
                child: CupertinoActivityIndicator(radius: 16),
              )
            : Stack(
                children: [
                  // WebView
                  WebViewWidget(controller: _controller!),

                  // 加载进度条
                  if (_isLoading && _loadingProgress < 1.0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: _loadingProgress,
                        backgroundColor: AppColors.backgroundGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 2,
                      ),
                    ),

                  // 加载指示器
                  if (_isLoading && _loadingProgress == 0.0)
                    const Center(
                      child: CupertinoActivityIndicator(
                        radius: 16,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
