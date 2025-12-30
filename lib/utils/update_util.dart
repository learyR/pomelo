import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pomelo/models/update_model.dart';
import '../services/network/api_client.dart';
import '../services/local_storage.dart';
import 'logger_util.dart';
import 'toast_util.dart';

/// 版本信息模型
class VersionInfo {
  /// 版本号（如：1.0.0）
  final String version;

  /// 构建号（如：1）
  final String buildNumber;

  /// 应用包名
  final String packageName;

  /// 应用名称
  final String appName;

  VersionInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
    required this.appName,
  });

  /// 获取完整版本号（version+buildNumber）
  String get fullVersion => '$version+$buildNumber';

  /// 将版本号字符串转换为可比较的整数列表
  /// 例如："1.2.3" -> [1, 2, 3]
  List<int> get versionNumbers {
    return version.split('.').map((v) => int.tryParse(v) ?? 0).toList();
  }

  @override
  String toString() => fullVersion;
}

/// 版本更新信息
class UpdateInfo {
  /// 是否有更新
  final bool hasUpdate;

  /// 是否强制更新
  final bool forceUpdate;

  /// 最新版本号
  final String? latestVersion;

  /// 最新构建号
  final String? latestBuildNumber;

  /// 更新描述
  final String? updateDescription;

  /// 下载地址（Android: APK URL, iOS: App Store URL）
  final String? downloadUrl;

  /// 安装包大小（字节）
  final int? packageSize;

  /// 更新时间
  final DateTime? updateTime;

  /// 最小支持版本（低于此版本强制更新）
  final String? minSupportVersion;

  UpdateInfo({
    required this.hasUpdate,
    this.forceUpdate = false,
    this.latestVersion,
    this.latestBuildNumber,
    this.updateDescription,
    this.downloadUrl,
    this.packageSize,
    this.updateTime,
    this.minSupportVersion,
  });

  /// 获取完整版本号
  String? get fullLatestVersion {
    if (latestVersion == null || latestBuildNumber == null) return null;
    return '$latestVersion+$latestBuildNumber';
  }

  /// 获取格式化后的安装包大小（MB）
  String? get formattedPackageSize {
    if (packageSize == null) return null;
    final mb = packageSize! / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }
}

/// 更新工具类
///
/// 用于检查应用版本更新、比较版本号等功能
/// 包含完整的更新流程：检查更新、显示对话框、权限申请、下载、安装
class UpdateUtil {
  UpdateUtil._(); // 私有构造函数，防止实例化

  /// 存储键：最后检查更新时间
  static const String _keyLastCheckTime = 'last_update_check_time';

  /// 存储键：忽略的版本号
  static const String _keyIgnoredVersion = 'ignored_version';

  /// 存储键：下载文件路径
  static const String _keyDownloadPath = 'update_download_path';

  /// 比较两个版本号
  ///
  /// [version1] 和 [version2] 格式：如 "1.2.3"
  ///
  /// 返回值：
  /// - 正数：version1 > version2
  /// - 负数：version1 < version2
  /// - 0：version1 == version2
  static int compareVersion(String version1, String version2) {
    final v1Parts =
        version1.split('.').map((v) => int.tryParse(v) ?? 0).toList();
    final v2Parts =
        version2.split('.').map((v) => int.tryParse(v) ?? 0).toList();

    // 补齐长度
    final maxLength =
        v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;
    while (v1Parts.length < maxLength) v1Parts.add(0);
    while (v2Parts.length < maxLength) v2Parts.add(0);

    // 逐位比较
    for (int i = 0; i < maxLength; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }

  /// 检查 version1 是否大于 version2
  static bool isVersionGreater(String version1, String version2) {
    return compareVersion(version1, version2) > 0;
  }

  /// 检查 version1 是否小于 version2
  static bool isVersionLess(String version1, String version2) {
    return compareVersion(version1, version2) < 0;
  }

  /// 检查 version1 是否等于 version2
  static bool isVersionEqual(String version1, String version2) {
    return compareVersion(version1, version2) == 0;
  }

  /// 检查是否有更新
  ///
  /// [currentVersion] 当前版本号（如："1.0.0"）
  /// [latestVersion] 最新版本号（如："1.0.1"）
  /// [currentBuild] 当前构建号（可选）
  /// [latestBuild] 最新构建号（可选）
  static bool checkHasUpdate(
    String currentVersion,
    String latestVersion, {
    String? currentBuild,
    String? latestBuild,
  }) {
    // 先比较版本号
    final versionCompare = compareVersion(latestVersion, currentVersion);
    if (versionCompare > 0) {
      return true; // 版本号更大，有更新
    }
    if (versionCompare < 0) {
      return false; // 版本号更小，无更新
    }

    // 版本号相同，比较构建号
    if (currentBuild != null && latestBuild != null) {
      final currentBuildNum = int.tryParse(currentBuild) ?? 0;
      final latestBuildNum = int.tryParse(latestBuild) ?? 0;
      return latestBuildNum > currentBuildNum;
    }

    return false;
  }

  /// 检查是否为强制更新
  ///
  /// [currentVersion] 当前版本号
  /// [minSupportVersion] 最小支持版本号
  static bool checkForceUpdate(
      String currentVersion, String minSupportVersion) {
    return compareVersion(currentVersion, minSupportVersion) < 0;
  }

  /// 从 PackageInfo 获取版本信息
  static VersionInfo getVersionInfo({
    required String version,
    required String buildNumber,
    required String packageName,
    required String appName,
  }) {
    return VersionInfo(
      version: version,
      buildNumber: buildNumber,
      packageName: packageName,
      appName: appName,
    );
  }

  /// 解析版本号字符串
  ///
  /// 支持格式："1.0.0"、"1.0.0+1"、"1.0.0.1"
  static VersionInfo? parseVersionString(
    String versionString, {
    String packageName = 'com.example.app',
    String appName = 'App',
  }) {
    try {
      String version = '1.0.0';
      String buildNumber = '1';

      // 处理 "1.0.0+1" 格式
      if (versionString.contains('+')) {
        final parts = versionString.split('+');
        version = parts[0];
        buildNumber = parts.length > 1 ? parts[1] : '1';
      } else {
        // 处理 "1.0.0" 或 "1.0.0.1" 格式
        final parts = versionString.split('.');
        if (parts.length >= 3) {
          version = '${parts[0]}.${parts[1]}.${parts[2]}';
          if (parts.length > 3) {
            buildNumber = parts[3];
          }
        } else {
          version = versionString;
        }
      }

      return VersionInfo(
        version: version,
        buildNumber: buildNumber,
        packageName: packageName,
        appName: appName,
      );
    } catch (e) {
      LoggerUtil.error('解析版本号失败: $versionString', e);
      return null;
    }
  }

  /// 获取 App Store 链接（iOS）
  ///
  /// [appId] App Store 中的应用 ID
  static String getAppStoreUrl(String appId) {
    return 'https://apps.apple.com/app/id$appId';
  }

  /// 获取 Google Play 链接（Android）
  ///
  /// [packageName] 应用包名
  static String getGooglePlayUrl(String packageName) {
    return 'https://play.google.com/store/apps/details?id=$packageName';
  }

  /// 打开应用商店
  static Future<bool> openAppStore(String appId) async {
    try {
      final url = getAppStoreUrl(appId);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      LoggerUtil.error('打开 App Store 失败', e);
      return false;
    }
  }

  /// 打开 Google Play 商店
  static Future<bool> openGooglePlay(String packageName) async {
    try {
      final url = getGooglePlayUrl(packageName);
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      LoggerUtil.error('打开 Google Play 失败', e);
      return false;
    }
  }

  /// 根据平台打开对应的应用商店
  static Future<bool> openStore({
    required String iosAppId,
    required String androidPackageName,
  }) async {
    if (Platform.isIOS) {
      return await openAppStore(iosAppId);
    } else if (Platform.isAndroid) {
      return await openGooglePlay(androidPackageName);
    }
    return false;
  }

  /// 格式化文件大小
  ///
  /// [bytes] 文件大小（字节）
  /// [decimals] 小数位数
  static String formatFileSize(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes / 1024).floor().bitLength;
    final index = i < suffixes.length ? i : suffixes.length - 1;

    if (index == 0) return '$bytes ${suffixes[0]}';

    final size = bytes / (1024 * index);
    return '${size.toStringAsFixed(decimals)} ${suffixes[index]}';
  }

  /// 检查并处理更新（完整流程）
  ///
  /// 包含：检查更新、显示对话框、权限申请、下载、安装
  ///
  /// [context] BuildContext，用于显示对话框（可选，如果 silent 为 true 则不需要）
  /// [showDialog] 是否显示更新对话框，默认 true
  /// [silent] 静默检查，不显示对话框，默认 false
  static Future<void> checkAndHandleUpdate(
    BuildContext? context, {
    bool showDialog = true,
    bool silent = false,
  }) async {
    try {
      // 检查更新
      final updateInfo = await checkUpdate();
      if (updateInfo == null || !updateInfo.hasUpdate) {
        if (!silent) {
          ToastUtil.show('当前已是最新版本');
        }
        return;
      }

      // 检查是否已忽略此版本
      final ignoredVersion = LocalStorage.getString(_keyIgnoredVersion);
      if (ignoredVersion == updateInfo.fullLatestVersion &&
          !updateInfo.forceUpdate) {
        LoggerUtil.debug('用户已忽略此版本更新');
        return;
      }

      // 保存检查时间
      await LocalStorage.setString(
          _keyLastCheckTime, DateTime.now().toIso8601String());

      // 显示更新对话框
      if (showDialog && context != null) {
        await _showUpdateDialog(context, updateInfo);
      }
    } catch (e) {
      LoggerUtil.error('检查更新失败', e);
      if (!silent) {
        ToastUtil.showError('检查更新失败，请稍后重试');
      }
    }
  }

  /// 检查更新（仅检查，不处理）
  static Future<UpdateInfo?> checkUpdate() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.get(ApiPath.versionUpgrade);

      if (!response.isSuccess || response.data == null) {
        return null;
      }

      final updateModel = UpdateModel.fromJson(response.data);
      final packageInfo = await PackageInfo.fromPlatform();

      // 检查是否有新版本
      final hasUpdate = checkHasUpdate(
        packageInfo.version,
        updateModel.versionCode ?? packageInfo.version,
        currentBuild: packageInfo.buildNumber,
        latestBuild: updateModel.appVersion?.toString(),
      );

      if (!hasUpdate ||
          updateModel.downloadUrl == null ||
          updateModel.downloadUrl!.isEmpty) {
        return null;
      }

      return UpdateInfo(
        hasUpdate: hasUpdate,
        forceUpdate: updateModel.isForce,
        latestVersion: updateModel.versionCode ?? packageInfo.version,
        latestBuildNumber:
            updateModel.appVersion?.toString() ?? packageInfo.buildNumber,
        updateDescription: updateModel.description,
        downloadUrl: updateModel.downloadUrl,
        packageSize: null,
        minSupportVersion: null,
      );
    } catch (e) {
      LoggerUtil.error('检查更新失败', e);
      return null;
    }
  }

  /// 显示更新对话框
  static Future<void> _showUpdateDialog(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: !updateInfo.forceUpdate, // 强制更新时不能关闭
      builder: (context) => UpdateDialog(updateInfo: updateInfo),
    );

    if (result == true) {
      // 用户点击立即更新
      await _startDownloadAndInstall(context, updateInfo);
    } else if (result == false && !updateInfo.forceUpdate) {
      // 用户点击稍后更新，保存忽略的版本号
      if (updateInfo.fullLatestVersion != null) {
        await LocalStorage.setString(
            _keyIgnoredVersion, updateInfo.fullLatestVersion!);
      }
    }
  }

  /// 开始下载并安装
  static Future<void> _startDownloadAndInstall(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    if (Platform.isIOS) {
      // iOS 直接打开 App Store
      if (updateInfo.downloadUrl != null) {
        final uri = Uri.parse(updateInfo.downloadUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      return;
    }

    // Android 需要下载 APK
    if (updateInfo.downloadUrl == null || updateInfo.downloadUrl!.isEmpty) {
      ToastUtil.showError('下载地址无效');
      return;
    }

    // 申请存储权限
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      ToastUtil.showError('需要存储权限才能下载更新');
      return;
    }

    // 显示下载进度对话框
    await _showDownloadDialog(context, updateInfo);
  }

  /// 申请存储权限
  static Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      // Android 13+ 使用不同的权限
      if (Platform.operatingSystemVersion.contains('13') ||
          Platform.operatingSystemVersion.contains('14')) {
        // Android 13+ 不再需要存储权限，直接返回 true
        return true;
      }

      // Android 12 及以下需要存储权限
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

  /// 显示下载进度对话框
  static Future<void> _showDownloadDialog(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DownloadProgressDialog(
        updateInfo: updateInfo,
        onDownloadComplete: (filePath) async {
          Navigator.of(context).pop();
          await _installApk(context, filePath);
        },
        onDownloadError: (error) {
          Navigator.of(context).pop();
          ToastUtil.showError('下载失败: $error');
        },
      ),
    );
  }

  /// 安装 APK（Android）
  static Future<void> _installApk(BuildContext context, String filePath) async {
    if (!Platform.isAndroid) return;

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        ToastUtil.showError('安装文件不存在');
        return;
      }

      // Android 8.0+ 需要申请安装权限
      if (await Permission.requestInstallPackages.isGranted) {
        await _launchInstaller(filePath);
      } else {
        final status = await Permission.requestInstallPackages.request();
        if (status.isGranted) {
          await _launchInstaller(filePath);
        } else {
          ToastUtil.showError('需要安装权限才能更新应用');
        }
      }
    } catch (e) {
      LoggerUtil.error('安装 APK 失败', e);
      ToastUtil.showError('安装失败，请手动安装。文件路径: $filePath');
    }
  }

  /// 启动安装器
  static Future<void> _launchInstaller(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        LoggerUtil.info('APK 文件路径: $filePath');
        await OpenFile.open(filePath);
      }
    } catch (e) {
      LoggerUtil.error('启动安装器失败', e);
      ToastUtil.showError('安装失败，请手动安装。文件路径: $filePath');
    }
  }

  /// 清除忽略的版本
  static Future<void> clearIgnoredVersion() async {
    await LocalStorage.remove(_keyIgnoredVersion);
  }

  /// 获取最后检查时间
  static DateTime? getLastCheckTime() {
    final timeString = LocalStorage.getString(_keyLastCheckTime);
    if (timeString == null) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }
}

/// 更新对话框
class UpdateDialog extends StatelessWidget {
  final UpdateInfo updateInfo;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isForceUpdate = updateInfo.forceUpdate;

    return PopScope(
      canPop: !isForceUpdate, // 强制更新时不允许返回
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.system_update,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('发现新版本'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 版本信息
              if (updateInfo.fullLatestVersion != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '版本: ${updateInfo.fullLatestVersion}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // 更新内容
              if (updateInfo.updateDescription != null) ...[
                const Text(
                  '更新内容:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(updateInfo.updateDescription!),
                const SizedBox(height: 12),
              ],

              // 文件大小
              if (updateInfo.formattedPackageSize != null)
                Text(
                  '大小: ${updateInfo.formattedPackageSize}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          // 强制更新时不显示取消按钮
          if (!isForceUpdate)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('稍后更新'),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('立即更新'),
          ),
        ],
      ),
    );
  }
}

/// 下载进度对话框
class _DownloadProgressDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  final Function(String filePath) onDownloadComplete;
  final Function(String error) onDownloadError;

  const _DownloadProgressDialog({
    required this.updateInfo,
    required this.onDownloadComplete,
    required this.onDownloadError,
  });

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  bool _isDownloading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    try {
      if (widget.updateInfo.downloadUrl == null) {
        widget.onDownloadError('下载地址为空');
        return;
      }

      // 获取下载目录
      Directory? directory;
      if (Platform.isAndroid) {
        // Android 使用外部存储的下载目录
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else if (Platform.isIOS) {
        // iOS 使用应用文档目录
        final appDir = await getApplicationDocumentsDirectory();
        directory = Directory('${appDir.path}/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      }
      
      if (directory == null) {
        widget.onDownloadError('无法获取下载目录');
        return;
      }

      // 生成文件名
      final fileName =
          'update_${widget.updateInfo.fullLatestVersion ?? 'latest'}.apk';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // 如果文件已存在，先删除
      if (await file.exists()) {
        await file.delete();
      }

      // 下载文件
      final apiClient = ApiClient();
      await apiClient.downloadFile(
        widget.updateInfo.downloadUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      // 下载完成
      setState(() {
        _isDownloading = false;
      });

      // 保存下载路径
      await LocalStorage.setString(UpdateUtil._keyDownloadPath, filePath);

      // 通知下载完成
      widget.onDownloadComplete(filePath);
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _error = e.toString();
      });
      widget.onDownloadError(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('正在下载更新'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isDownloading) ...[
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 16),
            Text('${(_progress * 100).toStringAsFixed(1)}%'),
          ] else if (_error != null) ...[
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(
              '下载失败',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        if (!_isDownloading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
      ],
    );
  }
}
