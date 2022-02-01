part of 'home.bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeShortUrlEvent extends HomeEvent {
  final String urlToBeShortened;

  HomeShortUrlEvent({required this.urlToBeShortened});
}

class HomeGetShortenedUrlEvent extends HomeEvent {
  final String id;

  HomeGetShortenedUrlEvent({required this.id});
}

class HomeShowUrlOptionsEvent extends HomeEvent {
  HomeShowUrlOptionsEvent();
}

class HomeCopyOriginalUrlEvent extends HomeEvent {
  final String id;

  HomeCopyOriginalUrlEvent({required this.id});
}

class HomeCopyShortenedUrlEvent extends HomeEvent {
  final String shortenedUrl;

  HomeCopyShortenedUrlEvent({required this.shortenedUrl});
}
