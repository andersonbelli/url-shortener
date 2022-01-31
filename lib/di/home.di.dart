import 'package:nubanktest/di/base.di.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/presenter/home/home.bloc.dart';

class HomeDI extends BaseDI {
  final _di = Injector().di;

  @override
  Future<void> registerAll() async {
    /// Bloc
    _di.registerFactory<HomeBloc>(
      () => HomeBloc(
        getOriginalUrlUseCase: _di(),
        shortUrlUseCase: _di(),
      ),
    );
  }
}
