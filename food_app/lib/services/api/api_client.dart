import 'package:dio/dio.dart';

import '../../config/api_config.dart';
import '../../core/constants/api_constants.dart';
import '../storage_service.dart';

class ApiClient {
  ApiClient([StorageService? storage]) : _storage = storage ?? StorageService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == ApiConstants.statusUnauthorized) {
            await _storage.clearAll();
          }
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;
  final StorageService _storage;

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> uploadFile(String path, String filePath, {String fieldName = 'file', Map<String, dynamic>? data}) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    print('🚨 DioException Type: ${error.type}');
    print('🚨 DioException Message: ${error.message}');
    print('🚨 Response Status: ${error.response?.statusCode}');
    print('🚨 Response Data: ${error.response?.data}');
    print('🚨 Request URL: ${error.requestOptions.uri}');
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Exception(ApiConstants.errorNetwork);
      case DioExceptionType.badResponse:
        final responseData = error.response?.data;
        final message = responseData is Map<String, dynamic>
            ? (responseData['message']?.toString() ?? ApiConstants.errorUnknown)
            : ApiConstants.errorUnknown;
        switch (error.response?.statusCode) {
          case ApiConstants.statusUnauthorized:
            return Exception(ApiConstants.errorUnauthorized);
          case ApiConstants.statusNotFound:
            return Exception(ApiConstants.errorNotFound);
          case ApiConstants.statusServerError:
            return Exception(ApiConstants.errorServer);
          default:
            return Exception(message);
        }
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception(ApiConstants.errorUnknown);
    }
  }
}
