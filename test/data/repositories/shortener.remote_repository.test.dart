import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/data/datasource/shortener.data_source.dart';
import 'package:nubanktest/data/models/links/links.model.dart';
import 'package:nubanktest/data/models/original_url/original_url.model.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';
import 'package:nubanktest/data/repositories/shortener.repository_impl.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';

import 'shortener.remote_repository.test.mocks.dart';

@GenerateMocks([ShortenerDataSourceImpl])
void main() {
  late ShortenerRepository shortenerRepository;
  late MockShortenerDataSourceImpl shortenerRemoteDataSourceImplMock;

  setUpAll(() {
    shortenerRemoteDataSourceImplMock = MockShortenerDataSourceImpl();
    shortenerRepository =
        ShortenerRepositoryImpl(remote: shortenerRemoteDataSourceImplMock);
  });

  group('Shortener Repository test', () {
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

    test('Should not found the searched alias Id and return an error', () async {
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
  });
}
