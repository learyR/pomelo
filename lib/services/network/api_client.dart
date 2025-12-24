import 'package:dio/dio.dart';
import '../../services/network/api_define.dart';
import '../../services/network/api_response.dart';
import '../../services/network/api_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// API请求客户端
/// 可在任何项目中即插即用，通过ApiDefine进行配置
class ApiClient {
  late Dio _dio;

  ApiClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? defaultHeaders,
    List<Interceptor>? interceptors,
    bool? enableLogging,
    String? Function()? getTokenCallback,
    void Function()? clearTokenCallback,
    void Function(String level, String message)? logCallback,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiDefine.baseUrl,
        connectTimeout: connectTimeout ??
            Duration(milliseconds: ApiDefine.connectTimeout),
        receiveTimeout: receiveTimeout ??
            Duration(milliseconds: ApiDefine.receiveTimeout),
        headers: defaultHeaders ?? ApiDefine.defaultHeaders,
        validateStatus: (status) {
          // 允许所有状态码，由业务层处理
          return status != null && status < 600;
        },
      ),
    );

    // 配置拦截器
    final shouldLog = enableLogging ?? ApiDefine.enableLogging;
    if (shouldLog) {
      _dio.interceptors.add(
        LoggingInterceptor(logCallback: logCallback ?? ApiDefine.logCallback),
      );
    }

    // 添加认证拦截器
    _dio.interceptors.add(
      AuthInterceptor(
        getTokenCallback: getTokenCallback ?? ApiDefine.getTokenCallback,
        clearTokenCallback: clearTokenCallback ?? ApiDefine.clearTokenCallback,
      ),
    );

    // 添加自定义拦截器
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// GET请求
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('GET请求异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// POST请求
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('POST请求异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// PUT请求
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('PUT请求异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// DELETE请求
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('DELETE请求异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// PATCH请求
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('PATCH请求异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// 文件上传
  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    Options? options,
    T? Function(dynamic)? parser,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      final response = await _dio.post(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
      );

      return _handleResponse<T>(response, parser);
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('文件上传异常: $path', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// 文件下载
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool deleteOnError = true,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        deleteOnError: deleteOnError,
      );
    } on DioException catch (e) {
      throw ApiExceptionFactory.fromDioException(e);
    } catch (e) {
      _logError('文件下载异常: $urlPath', e);
      throw ApiUnknownException(originalError: e);
    }
  }

  /// 处理响应
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T? Function(dynamic)? parser,
  ) {
    // 检查HTTP状态码
    if (response.statusCode != null && response.statusCode! >= 400) {
      final errorMessage = _extractErrorMessage(response.data);
      throw ApiServerException(
        message: errorMessage ?? '服务器错误',
        statusCode: response.statusCode,
        originalError: response.data,
      );
    }

    // 解析响应数据
    if (response.data == null) {
      return ApiResponse<T>(
        code: response.statusCode ?? 200,
        message: '请求成功',
        data: null,
      );
    }

    // 如果响应数据是Map，尝试解析为ApiResponse
    if (response.data is Map<String, dynamic>) {
      final json = response.data as Map<String, dynamic>;

      return ApiResponse<T>.fromJson(
        json,
        parser ?? (data) => data as T?,
      );
    }

    // 如果响应数据是List，直接返回
    if (response.data is List && parser != null) {
      final list = (response.data as List)
          .map((item) => parser(item))
          .whereType<T>()
          .toList();

      return ApiResponse<T>(
        code: response.statusCode ?? 200,
        message: '请求成功',
        data: list as T,
      );
    }

    // 其他情况直接返回数据
    return ApiResponse<T>(
      code: response.statusCode ?? 200,
      message: '请求成功',
      data: parser != null ? parser(response.data) : response.data as T?,
    );
  }

  /// 提取错误消息
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['msg'] ??
          data['error'] ??
          data['errorMessage'];
    }

    if (data is String) {
      return data;
    }

    return null;
  }

  /// 日志输出
  void _logError(String message, dynamic error) {
    final logCallback = ApiDefine.logCallback;
    if (logCallback != null) {
      logCallback('error', '$message: $error');
    } else {
      // 如果没有配置日志回调，使用print作为fallback
      print('[$message] $error');
    }
  }

  /// 更新BaseUrl
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// 更新请求头
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// 清除请求头
  void clearHeaders() {
    _dio.options.headers.clear();
  }

  /// 取消所有请求
  void cancelAllRequests({String? reason}) {
    _dio.close(force: true);
  }

  /// 获取Dio实例（用于高级用法）
  Dio get dio => _dio;
}

