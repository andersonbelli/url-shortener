import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teststudy/data/datasource/shortener.data_source.dart';
import 'package:teststudy/data/models/links/links.model.dart';
import 'package:teststudy/data/models/original_url/original_url.model.dart';
import 'package:teststudy/data/models/original_url/original_url_error.model.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';
import 'package:teststudy/data/models/url_generic_error.model.dart';
import 'package:teststudy/data/repositories/shortener.repository_impl.dart';
import 'package:teststudy/domain/repositories/shortener.repository.dart';

import 'shortener.remote_repository.test.mocks.dart';

@GenerateMocks([ShortenerDataSourceImpl])
void main() {
  late ShortenerRepository shortenerRepository;
  late MockShortenerDataSourceImpl shortenerRemoteDataSourceImplMock;

  const testShortUrl = ShortUrlModel(
    alias: '28431',
    links: LinksModel(
      self: "https://www.google.com",
      short: "https://url-shortener-nu.herokuapp.com/short/28431",
    ),
  );

  const testOriginalUrl = OriginalUrlModel(
    url: "https://www.google.com",
  );

  const testOriginalUrlNotFound = OriginalUrlNotFoundErrorModel(
    error: "Alias for 28431 not found",
  );

  const testUrl = "https://www.google.com";

  const testId = "28431";

  setUpAll(() {
    shortenerRemoteDataSourceImplMock = MockShortenerDataSourceImpl();
    shortenerRepository =
        ShortenerRepositoryImpl(remote: shortenerRemoteDataSourceImplMock);
  });

  group('ShortenerRepository shortUrl test', () {
    test('Should successfully short a url', () async {
      // arrange
      when(shortenerRemoteDataSourceImplMock.shortUrl(testUrl)).thenAnswer(
            (_) async => testShortUrl,
      );

      // act
      final result = await shortenerRepository.shortUrl(testUrl);

      // assert
      verify(shortenerRemoteDataSourceImplMock.shortUrl(testUrl));
      verifyNoMoreInteractions(shortenerRemoteDataSourceImplMock);

      expect(result, equals(const Right(testShortUrl)));
    });

    test('Should not short a url and throw an error', () async {
      // arrange
      when(shortenerRemoteDataSourceImplMock.shortUrl(testId)).thenThrow(
        Left(UrlGenericErrorModel()),
      );

      // act
      // assert
      expectLater(() async => await shortenerRepository.shortUrl(testId),
          throwsA(isInstanceOf<Left<UrlGenericErrorModel, dynamic>>()));

      verify(shortenerRemoteDataSourceImplMock.shortUrl(testId));
      verifyNoMoreInteractions(shortenerRemoteDataSourceImplMock);
    });
  });

  group('ShortenerRepository getOriginalUrl test', () {
    test('Should successfully retrieve the original url', () async {
      // arrange
      when(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId)).thenAnswer(
        (_) async => testOriginalUrl,
      );

      // act
      final result = await shortenerRepository.getOriginalUrl(testId);

      // assert
      verify(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId));
      verifyNoMoreInteractions(shortenerRemoteDataSourceImplMock);

      expect(result, equals(const Right(testOriginalUrl)));
    });

    test(
        '''Should not found the searched alias Id 
        and return an OriginalUrlNotFoundErrorModel''',
        () async {
      // arrange
      when(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId)).thenAnswer(
        (_) async => testOriginalUrlNotFound,
      );

      // act
      final result = await shortenerRepository.getOriginalUrl(testId);

      // assert
      verify(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId));
      verifyNoMoreInteractions(shortenerRemoteDataSourceImplMock);

      expect(result, equals(const Right(testOriginalUrlNotFound)));
    });

    test('Should not retrieve a url and throw an error', () async {
      // arrange
      when(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId)).thenThrow(
        Left(UrlGenericErrorModel()),
      );

      // act
      // assert
      expectLater(() async => await shortenerRepository.getOriginalUrl(testId),
          throwsA(isInstanceOf<Left<UrlGenericErrorModel, dynamic>>()));

      verify(shortenerRemoteDataSourceImplMock.getOriginalUrl(testId));
      verifyNoMoreInteractions(shortenerRemoteDataSourceImplMock);
    });
  });
}
