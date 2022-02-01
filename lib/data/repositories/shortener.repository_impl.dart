import 'package:dartz/dartz.dart';
import 'package:nubanktest/core/http/models/http_exceptions.dart';
import 'package:nubanktest/data/datasource/shortener.data_source.dart';
import 'package:nubanktest/data/models/url_generic_error.model.dart';
import 'package:nubanktest/domain/entities/original_url.entity.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';

class ShortenerRepositoryImpl implements ShortenerRepository {
  final ShortenerDataSource remote;

  ShortenerRepositoryImpl({
    required this.remote,
  });

  @override
  Future<Either<BaseException, ShortUrl>> shortUrl(
      String urlToBeShortened) async {
    try {
      final response = await remote.shortUrl(urlToBeShortened);

      return Right(response);
    } on GenericException {
      return Left(UrlGenericErrorModel());
    }
  }

  @override
  Future<Either<BaseException, OriginalUrl>> getOriginalUrl(String id) async {
    try {
      final response = await remote.getOriginalUrl(id);

      return Right(response);
    } on UrlNotFoundException catch (e) {
      return Left(e);
    } on GenericException {
      return Left(UrlGenericErrorModel());
    }
  }
}
