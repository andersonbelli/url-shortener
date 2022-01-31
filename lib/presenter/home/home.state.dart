part of 'home.bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeUrlShortenedState extends HomeState {
  final ShortUrl shortUrl;

  HomeUrlShortenedState({required this.shortUrl});
}

class HomeShortenedUrlRetrievedState extends HomeState {
  final OriginalUrl originalUrl;

  HomeShortenedUrlRetrievedState({required this.originalUrl});
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}
