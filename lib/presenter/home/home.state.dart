part of 'home.bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeUrlShortenedState extends HomeState {
  final ShortUrl shortUrl;

  HomeUrlShortenedState({required this.shortUrl});
}

class HomeUrlCopiedToClipBoardState extends HomeState {
  final String copiedUrl;

  HomeUrlCopiedToClipBoardState({required this.copiedUrl});
}

class HomeShortenedUrlNotFoundState extends HomeState {
  final String message;

  HomeShortenedUrlNotFoundState({required this.message});
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}

class HomeShowUrlOptionsState extends HomeState {
  HomeShowUrlOptionsState();
}
