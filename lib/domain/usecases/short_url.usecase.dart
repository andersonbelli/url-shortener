import 'package:dartz/dartz.dart';
import 'package:nubanktest/core/http/models/base_exception.model.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';

abstract class ShortUrlUseCase {
  Future<Either<BaseException, ShortUrl>> call(String urlToBeShortened);
}

class ShortUrlUseCaseImpl implements ShortUrlUseCase {
  final ShortenerRepository repository;

  ShortUrlUseCaseImpl({required this.repository});

  @override
  Future<Either<BaseException, ShortUrl>> call(String urlToBeShortened) async =>
      await repository.shortUrl(urlToBeShortened);
}
