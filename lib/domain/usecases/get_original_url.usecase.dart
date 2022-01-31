import 'package:dartz/dartz.dart';
import 'package:nubanktest/core/http/models/base_exception.model.dart';
import 'package:nubanktest/domain/entities/original_url.entity.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';

abstract class GetOriginalUrlUseCase {
  Future<Either<BaseException, OriginalUrl>> call(String id);
}

class GetOriginalUrlUseCaseImpl implements GetOriginalUrlUseCase {
  final ShortenerRepository repository;

  GetOriginalUrlUseCaseImpl({required this.repository});

  @override
  Future<Either<BaseException, OriginalUrl>> call(String id) async =>
      await repository.getOriginalUrl(id);
}
