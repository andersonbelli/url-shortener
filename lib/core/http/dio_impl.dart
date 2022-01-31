import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nubanktest/config/server_config.dart';
import 'package:nubanktest/core/http/http_manager.dart';
import 'package:nubanktest/core/http/models/http_exceptions.dart';

class DioImpl implements HttpManager {
  final Dio _dio = Dio();

  @override
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get("${ServerConfig.BASE_URL}/$endpoint");

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      } else if (response.statusCode == 404) {
        return UrlNotFoundException(response.data);
      }
      return GenericException(response.data);
    } on DioError catch (e) {
      throw GenericException(e.message);
    }
  }

  @override
  Future<dynamic> post(String endpoint, body) async {
    try {
      final response =
          await _dio.post("${ServerConfig.BASE_URL}/$endpoint", data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 404) {
        return UrlNotFoundException(response.data);
      }
      return GenericException(response.data);
    } on DioError catch (e) {
      throw GenericException(e.message);
    }
  }
}
