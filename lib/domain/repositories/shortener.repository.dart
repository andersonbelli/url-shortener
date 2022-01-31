import 'package:dartz/dartz.dart';
import 'package:nubanktest/core/http/models/base_exception.model.dart';
import 'package:nubanktest/domain/entities/original_url.entity.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';

abstract class ShortenerRepository {
  Future<Either<BaseException, ShortUrl>> shortUrl(String urlToBeShortened);

  Future<Either<BaseException, OriginalUrl>> getOriginalUrl(String id);
}
