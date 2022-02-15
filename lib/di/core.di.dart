import 'package:teststudy/core/http/dio_impl.dart';
import 'package:teststudy/core/http/http_manager.dart';
import 'package:teststudy/di/base.di.dart';
import 'package:teststudy/di/di.dart';
import 'package:teststudy/di/home.di.dart';
import 'package:teststudy/di/shortener.di.dart';

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
