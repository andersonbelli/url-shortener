part of 'home.bloc.dart';

@immutable
abstract class HomeEvent {}

class ShortUrlEvent extends HomeEvent {
  final String urlToBeShortened;

  ShortUrlEvent({required this.urlToBeShortened});
}

class GetShortenedUrlEvent extends HomeEvent {
  final String id;

  GetShortenedUrlEvent({required this.id});
}