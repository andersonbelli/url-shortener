import 'package:dartz/dartz.dart';
import 'package:nubanktest/core/http/models/base_exception.model.dart';
import 'package:nubanktest/core/http/models/generic_exception.model.dart';
import 'package:nubanktest/data/datasource/shortener.data_source.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';
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
  Future<Either<BaseException, ShortUrl>> shortUrl(String urlToBeShortened) async {
    final response = await remote.shortUrl(urlToBeShortened);

    try {
      return Right(response);
    } on GenericException {
      return Left(UrlGenericErrorModel());
    }
  }

  @override
  Future<Either<BaseException, OriginalUrl>> getOriginalUrl(String id) async {
    final response = await remote.getOriginalUrl(id);

    try {
      return Right(response);
    } on OriginalUrlNotFoundErrorModel {
      return Right(response);
    } on GenericException {
      return Left(UrlGenericErrorModel());
    }
  }
}
