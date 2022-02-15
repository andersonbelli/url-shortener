import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teststudy/data/models/links/links.model.dart';
import 'package:teststudy/data/models/original_url/original_url.model.dart';
import 'package:teststudy/data/models/original_url/original_url_error.model.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';
import 'package:teststudy/data/models/url_generic_error.model.dart';
import 'package:teststudy/domain/usecases/get_original_url.usecase.dart';
import 'package:teststudy/domain/usecases/short_url.usecase.dart';
import 'package:teststudy/presenter/home/home.bloc.dart';

import 'home.bloc.test.mocks.dart';

@GenerateMocks([GetOriginalUrlUseCase])
@GenerateMocks([ShortUrlUseCase])
void main() {
  late MockGetOriginalUrlUseCase mockGetOriginalUrlUseCase;
  late MockShortUrlUseCase mockShortUrlUseCase;
  late HomeBloc bloc;

  const testOriginalUrl = OriginalUrlModel(
    url: "https://www.google.com",
  );

  const testOriginalUrlNotFound = OriginalUrlNotFoundErrorModel(
    error: "Alias for 28431 not found",
  );

  const testId = "28431";

  const testShortUrl = ShortUrlModel(
    alias: '28431',
    links: LinksModel(
      self: "https://www.google.com",
      short: "https://url-shortener-nu.herokuapp.com/short/28431",
    ),
  );

  const testUrl = "https://www.google.com";

  setUpAll(() {
    mockGetOriginalUrlUseCase = MockGetOriginalUrlUseCase();
    mockShortUrlUseCase = MockShortUrlUseCase();

    bloc = HomeBloc(
      shortUrlUseCase: mockShortUrlUseCase,
      getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
    );
  });

  test('initialState should be HomeInitialState', () {
    // assert
    expect(
        bloc.state,
        isInstanceOf<HomeInitialState>());
  });

  group('HomeBloc UseCases tests', () {
    test(
      'should call the ShortUrlUseCase passing a url to be shortened',
      () async {
        // arrange
        when(mockShortUrlUseCase(any))
            .thenAnswer((_) async => const Right(testShortUrl));
        // act
        bloc.add(HomeShortUrlEvent(urlToBeShortened: testUrl));
        await untilCalled(mockShortUrlUseCase(any));
        // assert
        verify(mockShortUrlUseCase(testUrl));
      },
    );

    test(
      '''should call the GetOriginalUrlUseCase passing a id
         to retrieve the original URL''',
      () async {
        // arrange
        when(mockGetOriginalUrlUseCase(any))
            .thenAnswer((_) async => const Right(testOriginalUrl));
        // act
        bloc.add(HomeGetShortenedUrlEvent(id: testId));
        await untilCalled(mockGetOriginalUrlUseCase(any));
        // assert
        verify(mockGetOriginalUrlUseCase(testId));
      },
    );

    test(
      '''Should call the GetOriginalUrlUseCase passing a fake id
         and returning OriginalUrlNotFoundErrorModel''',
      () async {
        // arrange
        when(mockGetOriginalUrlUseCase(any))
            .thenAnswer((_) async => const Right(testOriginalUrlNotFound));
        // act
        bloc.add(HomeGetShortenedUrlEvent(id: testId));
        await untilCalled(mockGetOriginalUrlUseCase(any));
        // assert
        verify(mockGetOriginalUrlUseCase(testId));
      },
    );
  });

  group('HomeBloc HomeState successful tests', () {
    blocTest<HomeBloc, HomeState>(
      '''HomeShortUrlEvent should emit [Loading] and [UrlShortened]
         when URL has been shortened successfully''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockShortUrlUseCase(any))
          .thenAnswer((_) async => const Right(testShortUrl)),
      act: (bloc) => bloc.add(HomeShortUrlEvent(urlToBeShortened: testUrl)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeUrlShortenedState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      '''HomeGetShortenedUrlEvent should emit [Loading] and [UrlCopiedToClipBoardS]
           when URL has been copied successfully''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockGetOriginalUrlUseCase(any))
          .thenAnswer((_) async => const Right(testOriginalUrl)),
      act: (bloc) => bloc.add(HomeGetShortenedUrlEvent(id: testId)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeUrlCopiedToClipBoardState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      '''HomeShowUrlOptionsEvent should emit [ShowUrlOptions] successfully''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      act: (bloc) => bloc.add(HomeShowUrlOptionsEvent()),
      expect: () => [
        const TypeMatcher<HomeShowUrlOptionsState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      '''HomeCopyShortenedUrlEvent should emit [UrlCopiedToClipBoard] successfully''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      act: (bloc) => bloc.add(HomeCopyShortenedUrlEvent(shortenedUrl: testUrl)),
      expect: () => [
        const TypeMatcher<HomeUrlCopiedToClipBoardState>(),
      ],
    );
  });

  group('HomeBloc HomeState fail tests', () {
    blocTest<HomeBloc, HomeState>(
      '''HomeGetShortenedUrlEvent should emit [Loading] and [Error]
           when a error occur''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockGetOriginalUrlUseCase(any))
          .thenAnswer((_) async => Left(UrlGenericErrorModel())),
      act: (bloc) => bloc.add(HomeGetShortenedUrlEvent(id: testId)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeErrorState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      '''HomeGetShortenedUrlEvent should emit [Loading] and [ShortenedUrlNotFound]
           when URL is not found''',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockGetOriginalUrlUseCase(any))
          .thenAnswer((_) async => const Right(testOriginalUrlNotFound)),
      act: (bloc) => bloc.add(HomeGetShortenedUrlEvent(id: testId)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeShortenedUrlNotFoundState>(),
      ],
    );
  });
}
