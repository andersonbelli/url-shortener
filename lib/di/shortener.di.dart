import 'package:teststudy/core/storage/shared_preference_impl.dart';
import 'package:teststudy/data/datasource/shortener.data_source.dart';
import 'package:teststudy/data/repositories/shortener.repository_impl.dart';
import 'package:teststudy/di/base.di.dart';
import 'package:teststudy/di/di.dart';
import 'package:teststudy/domain/repositories/shortener.repository.dart';
import 'package:teststudy/domain/usecases/get_original_url.usecase.dart';
import 'package:teststudy/domain/usecases/short_url.usecase.dart';

class ShortenerDI extends BaseDI {
  final _di = Injector().di;

  @override
  Future<void> registerAll() async {
    /// Datasource
    _di.registerFactory<ShortenerDataSource>(() => ShortenerDataSourceImpl(
          httpManager: _di(),
          storage: SharedPreferenceImpl(),
        ));

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
