import 'package:nubanktest/data/datasource/shortener.data_source.dart';
import 'package:nubanktest/data/repositories/shortener.repository_impl.dart';
import 'package:nubanktest/di/base.di.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';
import 'package:nubanktest/domain/usecases/get_original_url.usecase.dart';
import 'package:nubanktest/domain/usecases/short_url.usecase.dart';

class ShortenerDI extends BaseDI {
  final _di = Injector().di;

  @override
  Future<void> registerAll() async {
    /// Datasource
    _di.registerFactory<ShortenerDataSource>(
        () => ShortenerDataSourceImpl(httpManager: _di()));

    /// Repository
    _di.registerFactory<ShortenerRepository>(
        () => ShortenerRepositoryImpl(remote: _di()));

    /// UseCases
    _di.registerFactory<ShortUrlUseCase>(
        () => ShortUrlUseCaseImpl(repository: _di()));

    _di.registerFactory<GetOriginalUrlUseCase>(
        () => GetOriginalUrlUseCaseImpl(repository: _di()));
  }
}
