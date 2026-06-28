import 'package:dio/dio.dart';
import 'api_result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  ApiResult<T> _handleError<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      return const ApiTimeout();
    }
    
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      
      if (statusCode == 404) {
        return const ApiNotFound();
      } else if (statusCode == 500) {
        return const ApiServerError();
      } else if (statusCode == 422 || statusCode == 400) {
        return ApiValidationError(
          data is Map<String, dynamic> ? data : {}, 
          data?['message'] ?? 'Validation Error'
        );
      }
      return ApiFailure(data?['message'] ?? 'Server error: $statusCode');
    }
    
    return const ApiNetworkError();
  }

  Future<ApiResult<T>> get<T>(String url, T Function(dynamic json) fromJson) async {
    try {
      final response = await _dio.get(url);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<T>> post<T>(String url, Map<String, dynamic> body, T Function(dynamic json) fromJson) async {
    try {
      final response = await _dio.post(url, data: body);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<T>> put<T>(String url, Map<String, dynamic> body, T Function(dynamic json) fromJson) async {
    try {
      final response = await _dio.put(url, data: body);
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<void>> delete(String url) async {
    try {
      await _dio.delete(url);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return _handleError<void>(e);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
