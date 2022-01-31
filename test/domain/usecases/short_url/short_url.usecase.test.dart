import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/data/models/links/links.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';
import 'package:nubanktest/domain/usecases/short_url.usecase.dart';

import 'short_url.usecase.mocks.dart';

@GenerateMocks([ShortenerRepository])
void main() {
  late MockShortenerRepository mockShortenerRepository;
  late ShortUrlUseCase useCase;

  setUpAll(() {
    mockShortenerRepository = MockShortenerRepository();
    useCase = ShortUrlUseCaseImpl(repository: mockShortenerRepository);
  });

  group('Shortener ShortUrlUseCase test', () {
    const testShortUrl = ShortUrlModel(
      alias: '28431',
      links: LinksModel(
        self: "https://www.google.com",
        short: "https://url-shortener-nu.herokuapp.com/short/28431",
      ),
    );

    const testUrl = "https://www.google.com";

    test('Should return ShortUrlModel from ShortUrlUseCase', () async {
      // arrange
      when(mockShortenerRepository.shortUrl(testUrl))
          .thenAnswer((_) async => const Right(testShortUrl));
      // act
      final result = await useCase(testUrl);
      // assert
      verify(mockShortenerRepository.shortUrl(testUrl));

      expect(result, equals(const Right(testShortUrl)));
      verifyNoMoreInteractions(mockShortenerRepository);
    });
  });
}
