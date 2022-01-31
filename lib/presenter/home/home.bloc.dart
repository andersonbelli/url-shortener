import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nubanktest/domain/entities/original_url.entity.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/domain/usecases/get_original_url.usecase.dart';
import 'package:nubanktest/domain/usecases/short_url.usecase.dart';
import 'package:rxdart/subjects.dart';

part 'home.event.dart';

part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOriginalUrlUseCase getOriginalUrlUseCase;
  final ShortUrlUseCase shortUrlUseCase;

  List<ShortUrl> urlsList = [];

  final _shortenedUrlController = BehaviorSubject<ShortUrl>();
  Stream<ShortUrl> get shortenedUrl => _shortenedUrlController.stream;
  Function(ShortUrl) get _onShortenedChanged =>
      _shortenedUrlController.sink.add;

  HomeBloc({
    required this.getOriginalUrlUseCase,
    required this.shortUrlUseCase,
  }) : super(HomeInitialState()) {
    on<ShortUrlEvent>((event, emit) async {
      emit(HomeLoadingState());

      final shortUrlEither = await shortUrlUseCase(event.urlToBeShortened);

      shortUrlEither.fold(
        (failure) {
          emit(HomeErrorState(message: failure.message));
        },
        (shortenedUrl) {
          emit(HomeUrlShortenedState(shortUrl: shortenedUrl));
          _onShortenedChanged(shortenedUrl);
        },
      );
    });
    on<GetShortenedUrlEvent>((event, emit) async {
      emit(HomeLoadingState());

      final originalUrlEither = await getOriginalUrlUseCase(event.id);

      originalUrlEither.fold(
        (failure) async* {
          emit(HomeErrorState(message: failure.message));
        },
        (originalUrl) async* {
          emit(HomeShortenedUrlRetrievedState(originalUrl: originalUrl));
        },
      );
    });
  }
}
