import 'dart:convert';

import 'package:teststudy/core/storage/storage_factory.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';

abstract class ShortenerLocalDataSource {
  Future<ShortUrlModel> load(String alias);
}

class ShortenedLocalDataSourceImpl extends ShortenerLocalDataSource {
  final StorageFactory storageFactory;

  ShortenedLocalDataSourceImpl({required this.storageFactory});

  @override
  Future<ShortUrlModel> load(String alias) async => ShortUrlModel.fromJson(
        jsonDecode(
          await storageFactory.load(alias),
        ),
      );
}
