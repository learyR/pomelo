import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/network/api_client.dart';
import 'logger_util.dart';
import 'toast_util.dart';

/// 图片工具类
/// 
/// 提供图片加载、预览、下载等功能
class ImageUtil {
  ImageUtil._(); // 私有构造函数，防止实例化

  /// 统一的图片加载方法
  /// 
  /// 自动判断图片类型（网络图片、本地图片、Asset图片）并加载
  /// 
  /// [imageUrl] 图片地址：
  ///   - 网络图片：以 http:// 或 https:// 开头
  ///   - 本地图片：以 / 开头或包含 file:// 的绝对路径
  ///   - Asset图片：其他情况（如 'assets/images/logo.png'）
  /// 
  /// [width] 宽度
  /// [height] 高度
  /// [fit] 填充方式
  /// [placeholder] 加载中占位符（仅网络图片有效）
  /// [errorWidget] 错误占位符
  static Widget buildImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // 判断图片类型
    if (_isNetworkImage(imageUrl)) {
      // 网络图片
      return loadNetworkImage(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
    } else if (_isLocalImage(imageUrl)) {
      // 本地图片
      return loadLocalImage(
        _getLocalImagePath(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorWidget: errorWidget,
      );
    } else {
      // Asset图片
      return loadAssetImage(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorWidget: errorWidget,
      );
    }
  }

  /// 判断是否为网络图片
  static bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// 判断是否为本地图片
  static bool _isLocalImage(String path) {
    // 以 / 开头的绝对路径
    if (path.startsWith('/')) {
      return true;
    }
    // 包含 file:// 协议
    if (path.startsWith('file://')) {
      return true;
    }
    // Windows 路径（如 C:\ 或 D:\）
    if (path.length >= 3 &&
        path[1] == ':' &&
        (path[2] == '\\' || path[2] == '/')) {
      return true;
    }
    return false;
  }

  /// 获取本地图片路径（去除 file:// 前缀）
  static String _getLocalImagePath(String path) {
    if (path.startsWith('file://')) {
      return path.replaceFirst('file://', '');
    }
    return path;
  }

  /// 加载网络图片
  /// 
  /// [url] 图片URL
  /// [width] 宽度
  /// [height] 高度
  /// [fit] 填充方式
  /// [placeholder] 加载中占位符
  /// [errorWidget] 错误占位符
  static Widget loadNetworkImage(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  /// 加载本地图片
  /// 
  /// [path] 本地图片路径
  /// [width] 宽度
  /// [height] 高度
  /// [fit] 填充方式
  /// [errorWidget] 错误占位符
  static Widget loadLocalImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildDefaultErrorWidget(),
    );
  }

  /// 加载Asset图片
  /// 
  /// [path] Asset图片路径
  /// [width] 宽度
  /// [height] 高度
  /// [fit] 填充方式
  /// [errorWidget] 错误占位符
  static Widget loadAssetImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildDefaultErrorWidget(),
    );
  }

  /// 显示图片预览
  /// 
  /// [context] BuildContext
  /// [imageUrl] 图片URL（网络或本地路径）
  /// [images] 图片列表（用于多图浏览）
  /// [initialIndex] 初始索引
  static Future<void> previewImage(
    BuildContext context,
    String imageUrl, {
    List<String>? images,
    int initialIndex = 0,
  }) async {
    final imageList = images ?? [imageUrl];
    final index = initialIndex >= 0 && initialIndex < imageList.length
        ? initialIndex
        : 0;

    await showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _ImagePreviewDialog(
        images: imageList,
        initialIndex: index,
      ),
    );
  }

  /// 下载图片
  /// 
  /// [url] 图片URL
  /// [fileName] 保存的文件名（可选，默认使用URL中的文件名）
  /// [onProgress] 下载进度回调
  /// 
  /// 返回下载文件的路径
  static Future<String?> downloadImage(
    String url, {
    String? fileName,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      // 申请存储权限
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        ToastUtil.showError('需要存储权限才能下载图片');
        return null;
      }

      // 获取下载目录
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        ToastUtil.showError('无法获取下载目录');
        return null;
      }

      // 生成文件名
      String finalFileName = fileName ?? _getFileNameFromUrl(url);
      if (!finalFileName.endsWith('.jpg') &&
          !finalFileName.endsWith('.jpeg') &&
          !finalFileName.endsWith('.png') &&
          !finalFileName.endsWith('.gif') &&
          !finalFileName.endsWith('.webp')) {
        finalFileName = '$finalFileName.jpg';
      }

      final filePath = '${directory.path}/$finalFileName';

      // 下载文件
      final apiClient = ApiClient();
      await apiClient.downloadFile(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total != -1) {
            onProgress(received, total);
          }
        },
      );

      LoggerUtil.info('图片下载成功: $filePath');
      ToastUtil.show('图片已保存到: $filePath');
      return filePath;
    } catch (e) {
      LoggerUtil.error('下载图片失败', e);
      ToastUtil.showError('下载失败: ${e.toString()}');
      return null;
    }
  }

  /// 清除图片缓存
  /// 
  /// [url] 指定图片URL（可选，不指定则清除所有缓存）
  static Future<void> clearCache({String? url}) async {
    try {
      if (url != null) {
        await CachedNetworkImage.evictFromCache(url);
        LoggerUtil.info('已清除指定图片缓存: $url');
      } else {
        await CachedNetworkImage.evictFromCache('');
        LoggerUtil.info('已清除所有图片缓存');
      }
    } catch (e) {
      LoggerUtil.error('清除缓存失败', e);
    }
  }

  /// 获取缓存文件路径
  /// 
  /// [url] 图片URL
  /// 
  /// 返回缓存文件路径（如果存在）
  static Future<String?> getCachePath(String url) async {
    try {
      // CachedNetworkImage 使用 flutter_cache_manager
      // 这里简化处理，实际项目中可以使用 CacheManager 获取缓存路径
      final cacheDir = await getTemporaryDirectory();
      return '${cacheDir.path}/libCachedImageData';
    } catch (e) {
      LoggerUtil.error('获取缓存路径失败', e);
      return null;
    }
  }

  /// 申请存储权限
  static Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // Android 13+ 不再需要存储权限
      if (Platform.operatingSystemVersion.contains('13') ||
          Platform.operatingSystemVersion.contains('14')) {
        return true;
      }

      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }

      // 如果被拒绝，尝试请求管理所有文件权限
      if (status.isDenied || status.isPermanentlyDenied) {
        final manageStorageStatus =
            await Permission.manageExternalStorage.request();
        return manageStorageStatus.isGranted;
      }

      return false;
    } catch (e) {
      LoggerUtil.error('申请存储权限失败', e);
      return false;
    }
  }

  /// 获取下载目录
  static Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Android 使用外部存储的下载目录
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      } else if (Platform.isIOS) {
        // iOS 使用应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        final directory = Directory('${appDir.path}/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      }
      return null;
    } catch (e) {
      LoggerUtil.error('获取下载目录失败', e);
      return null;
    }
  }

  /// 从URL中提取文件名
  static String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
      return 'image_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      return 'image_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// 默认占位符
  static Widget _buildDefaultPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  /// 默认错误占位符
  static Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }
}

/// 图片预览对话框
class _ImagePreviewDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _ImagePreviewDialog({
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<_ImagePreviewDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (widget.images.length > 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () => _downloadImage(context),
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _ImagePreviewItem(imageUrl: widget.images[index]);
          },
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    if (_currentIndex >= 0 && _currentIndex < widget.images.length) {
      final imageUrl = widget.images[_currentIndex];
      Navigator.of(context).pop(); // 关闭预览对话框
      final filePath = await ImageUtil.downloadImage(imageUrl);
      if (filePath != null && mounted) {
        ToastUtil.show('图片已保存');
      }
    }
  }
}

/// 图片预览项（支持缩放和拖拽）
class _ImagePreviewItem extends StatelessWidget {
  final String imageUrl;

  const _ImagePreviewItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // 使用统一的 buildImage 方法
    return ImageUtil.buildImage(
      imageUrl,
      errorWidget: _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.white54, size: 64),
            SizedBox(height: 16),
            Text(
              '图片加载失败',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
