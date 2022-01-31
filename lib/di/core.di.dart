import 'package:nubanktest/core/http/dio_impl.dart';
import 'package:nubanktest/core/http/http_manager.dart';
import 'package:nubanktest/di/base.di.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/di/home.di.dart';
import 'package:nubanktest/di/shortener.di.dart';

class CoreDI extends BaseDI {
  final _di = Injector().di;

  @override
  Future<void> registerAll() async {
    /// Http requests handler
    _di.registerFactory<HttpManager>(() => DioImpl());

    ShortenerDI().registerAll();
    HomeDI().registerAll();
  }
}
