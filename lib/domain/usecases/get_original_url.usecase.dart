import 'package:dartz/dartz.dart';
import 'package:teststudy/core/http/models/base_exception.model.dart';
import 'package:teststudy/domain/entities/original_url.entity.dart';
import 'package:teststudy/domain/entities/short_url.entity.dart';
import 'package:teststudy/domain/repositories/shortener.repository.dart';

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
