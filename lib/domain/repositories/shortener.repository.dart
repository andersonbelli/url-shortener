import 'package:dartz/dartz.dart';
import 'package:teststudy/core/http/models/base_exception.model.dart';
import 'package:teststudy/domain/entities/original_url.entity.dart';
import 'package:teststudy/domain/entities/short_url.entity.dart';

abstract class ShortenerRepository {
  Future<Either<BaseException, ShortUrl>> shortUrl(String urlToBeShortened);

  Future<Either<BaseException, OriginalUrl>> getOriginalUrl(String id);
}
