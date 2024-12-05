import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Response> getRequest(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // DioError'ı daha spesifik bir şekilde ele alabilirsiniz
        throw Exception('GET request failed: ${e.message}');
      } else {
        throw Exception('GET request failed: $e');
      }
    }
  }

  Future<Response> login(String url, dynamic data) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        throw Exception('POST request failed: ${e.message}');
      } else {
        throw Exception('POST request failed: $e');
      }
    }
  }
}
