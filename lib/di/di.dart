import 'package:get_it/get_it.dart';

class Injector {
  static final Injector _singleton = Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  final GetIt di = GetIt.instance;
}