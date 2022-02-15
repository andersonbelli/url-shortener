import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teststudy/data/models/original_url/original_url_error.model.dart';
import 'package:teststudy/domain/entities/original_url.entity.dart';
import 'package:teststudy/domain/entities/short_url.entity.dart';
import 'package:teststudy/domain/usecases/get_original_url.usecase.dart';
import 'package:teststudy/domain/usecases/short_url.usecase.dart';
import 'package:rxdart/subjects.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOriginalUrlUseCase getOriginalUrlUseCase;
  final ShortUrlUseCase shortUrlUseCase;

  List<ShortUrl> urlsList = [];

  final _shortenedUrlController = BehaviorSubject<ShortUrl>();
  Stream<ShortUrl> get shortenedUrl => _shortenedUrlController.stream;
  Function(ShortUrl) get onShortenedChanged =>
      _shortenedUrlController.sink.add;

  final _originalUrlController = BehaviorSubject<OriginalUrl>();
  Stream<OriginalUrl> get originalUrl => _originalUrlController.stream;
  Function(OriginalUrl) get _onOriginalUrlChanged =>
      _originalUrlController.sink.add;

  final _showAliasUrlController = BehaviorSubject<String>.seeded("");
  String get showAliasUrl => _showAliasUrlController.stream.value;
  Function(String) get showAliasUrlChanged => _showAliasUrlController.sink.add;

  HomeBloc({
    required this.getOriginalUrlUseCase,
    required this.shortUrlUseCase,
  }) : super(HomeInitialState()) {
    on<HomeShortUrlEvent>((event, emit) async {
      emit(HomeLoadingState());

      final shortUrlEither = await shortUrlUseCase(event.urlToBeShortened);

      shortUrlEither.fold(
        (failure) {
          emit(HomeErrorState(message: failure.message));
        },
        (shortenedUrl) {
          emit(HomeUrlShortenedState(shortUrl: shortenedUrl));
          onShortenedChanged(shortenedUrl);
        },
      );
    });
    on<HomeGetShortenedUrlEvent>((event, emit) async {
      emit(HomeLoadingState());

      final originalUrlEither = await getOriginalUrlUseCase(event.id);

      originalUrlEither.fold(
        (failure) {
          emit(HomeErrorState(message: failure.message));
        },
        (retrievedOriginalUrl) {
          if (retrievedOriginalUrl.runtimeType ==
              OriginalUrlNotFoundErrorModel) {
            retrievedOriginalUrl =
                retrievedOriginalUrl as OriginalUrlNotFoundErrorModel;

            emit(HomeShortenedUrlNotFoundState(
                message: retrievedOriginalUrl.error));
          } else {
            emit(HomeUrlCopiedToClipBoardState(
                copiedUrl: retrievedOriginalUrl.url));
            _onOriginalUrlChanged(retrievedOriginalUrl);
          }
        },
      );
    });
    on<HomeShowUrlOptionsEvent>((event, emit) async {
      emit(HomeShowUrlOptionsState());
    });
    on<HomeCopyOriginalUrlEvent>((event, emit) async {
      add(HomeGetShortenedUrlEvent(id: event.id));
    });
    on<HomeCopyShortenedUrlEvent>((event, emit) async {
      emit(HomeUrlCopiedToClipBoardState(copiedUrl: event.shortenedUrl));
    });
  }
}
