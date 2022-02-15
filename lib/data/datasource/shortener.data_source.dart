import 'dart:convert';

import 'package:teststudy/core/http/http_manager.dart';
import 'package:teststudy/core/storage/storage_factory.dart';
import 'package:teststudy/data/models/original_url/original_url.model.dart';
import 'package:teststudy/data/models/original_url/original_url_error.model.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';

abstract class ShortenerDataSource {
  Future<ShortUrlModel> shortUrl(String urlToBeShortened);

  Future<OriginalUrlModel> getOriginalUrl(String id);
}

class ShortenerDataSourceImpl extends ShortenerDataSource {
  final HttpManager httpManager;
  final StorageFactory storage;

  ShortenerDataSourceImpl({required this.storage, required this.httpManager});

  @override
  Future<ShortUrlModel> shortUrl(String urlToBeShortened) async {
    final response =
        await httpManager.post("api/alias", {"url": urlToBeShortened});

    final shortedUrl = ShortUrlModel.fromJson(response);

    await storage.save(shortedUrl.alias, jsonEncode(shortedUrl.toJson()));

    return shortedUrl;
  }

  @override
  Future<OriginalUrlModel> getOriginalUrl(String id) async {
    final response = await httpManager.get("api/alias/$id");

    if (response is OriginalUrlNotFoundErrorModel) {
      return response;
    }

    return OriginalUrlModel.fromJson(response);
  }
}
