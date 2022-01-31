import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/data/models/links/links.model.dart';
import 'package:nubanktest/data/models/original_url/original_url.model.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';
import 'package:nubanktest/domain/usecases/get_original_url.usecase.dart';
import 'package:nubanktest/domain/usecases/short_url.usecase.dart';
import 'package:nubanktest/presenter/home/home.bloc.dart';

import 'home.bloc.test.mocks.dart';

@GenerateMocks([GetOriginalUrlUseCase])
@GenerateMocks([ShortUrlUseCase])
void main() {
  late MockGetOriginalUrlUseCase mockGetOriginalUrlUseCase;
  late MockShortUrlUseCase mockShortUrlUseCase;

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
  });

  test('initialState should be HomeInitialState', () {
    // assert
    expect(
        HomeBloc(
          getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
          shortUrlUseCase: mockShortUrlUseCase,
        ).state,
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
        HomeBloc(
          getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
          shortUrlUseCase: mockShortUrlUseCase,
        ).add(ShortUrlEvent(urlToBeShortened: testUrl));
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
        HomeBloc(
          getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
          shortUrlUseCase: mockShortUrlUseCase,
        ).add(GetShortenedUrlEvent(id: testId));
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
        HomeBloc(
          getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
          shortUrlUseCase: mockShortUrlUseCase,
        ).add(GetShortenedUrlEvent(id: testId));
        await untilCalled(mockGetOriginalUrlUseCase(any));
        // assert
        verify(mockGetOriginalUrlUseCase(testId));
      },
    );
  });

  group('HomeBloc HomeState successful tests', () {
    blocTest<HomeBloc, HomeState>(
      'Should emit [Loading] and [Loaded] when data is gotten successfully',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockShortUrlUseCase(any))
          .thenAnswer((_) async => const Right(testShortUrl)),
      act: (bloc) => bloc.add(ShortUrlEvent(urlToBeShortened: testUrl)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeUrlShortenedState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'Should emit [Loading] and [Loaded] when data is gotten successfully',
      build: () => HomeBloc(
        getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        shortUrlUseCase: mockShortUrlUseCase,
      ),
      setUp: () => when(mockGetOriginalUrlUseCase(any))
          .thenAnswer((_) async => const Right(testOriginalUrl)),
      act: (bloc) => bloc.add(GetShortenedUrlEvent(id: testId)),
      expect: () => [
        const TypeMatcher<HomeLoadingState>(),
        const TypeMatcher<HomeShortenedUrlRetrievedState>(),
      ],
    );
  });
}
