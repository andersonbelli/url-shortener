import 'package:dio/dio.dart';
import 'package:nubanktest/config/server_config.dart';
import 'package:nubanktest/core/http/http_manager.dart';
import 'package:nubanktest/core/http/models/http_exceptions.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';

class DioImpl implements HttpManager {
  final Dio _dio = Dio();

  @override
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get("${ServerConfig.BASE_URL}/$endpoint");

      if (response.statusCode == 200) {
        return response.data;
      }
      throw GenericException(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return OriginalUrlNotFoundErrorModel.fromJson(e.response?.data);
      }

      throw GenericException("DioError: ${e.error}");
    }
  }

  @override
  Future<dynamic> post(String endpoint, body) async {
    try {
      final response =
          await _dio.post("${ServerConfig.BASE_URL}/$endpoint", data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      throw GenericException(response.data);
    } on DioError catch (e) {
      throw GenericException("DioError: ${e.error}");
    }
  }
}
