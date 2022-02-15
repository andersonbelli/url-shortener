import 'package:teststudy/di/base.di.dart';
import 'package:teststudy/di/di.dart';
import 'package:teststudy/presenter/home/home.bloc.dart';

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
