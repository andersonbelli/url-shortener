import 'package:dio/dio.dart';
import 'package:nubanktest/core/http/http_manager.dart';
import 'package:nubanktest/data/models/original_url/original_url.model.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';

abstract class ShortenerDataSource {
  Future<ShortUrlModel> shortUrl(String urlToBeShortened);

  Future<OriginalUrlModel> getOriginalUrl(String id);
}

class ShortenerDataSourceImpl extends ShortenerDataSource {
  final HttpManager httpManager;

  ShortenerDataSourceImpl({required this.httpManager});

  @override
  Future<ShortUrlModel> shortUrl(String urlToBeShortened) async {
    final response =
        await httpManager.post("api/alias", {"url": urlToBeShortened});
    return ShortUrlModel.fromJson(response);
  }

  @override
  Future<OriginalUrlModel> getOriginalUrl(String id) async {
    final Response response = await httpManager.get("/api/alias/$id");

    Map<String, dynamic> responseData = response.data;

    if (responseData.containsKey("error")) {
      return OriginalUrlNotFoundErrorModel.fromJson(responseData);
    }

    return OriginalUrlModel.fromJson(responseData);
  }
}
