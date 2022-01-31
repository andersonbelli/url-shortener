import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/data/models/original_url/original_url.model.dart';
import 'package:nubanktest/data/models/original_url/original_url_error.model.dart';
import 'package:nubanktest/domain/repositories/shortener.repository.dart';
import 'package:nubanktest/domain/usecases/get_original_url.usecase.dart';

import 'get_original_url.usecase.test.mocks.dart';

@GenerateMocks([ShortenerRepository])
void main() {
  late MockShortenerRepository mockShortenerRepository;
  late GetOriginalUrlUseCase useCase;

  setUpAll(() {
    mockShortenerRepository = MockShortenerRepository();
    useCase = GetOriginalUrlUseCaseImpl(repository: mockShortenerRepository);
  });

  group('Shortener GetOriginalUrlUseCase test', () {
    const testOriginalUrl = OriginalUrlModel(
      url: "https://www.google.com",
    );

    const testOriginalUrlNotFound = OriginalUrlNotFoundErrorModel(
      error: "Alias for 28431 not found",
    );

    const testId = "28431";

    test('Should return OriginalUrlModel from GetOriginalUrlUseCase', () async {
      // arrange
      when(mockShortenerRepository.getOriginalUrl(testId))
          .thenAnswer((_) async => const Right(testOriginalUrl));
      // act
      final result = await useCase(testId);
      // assert
      verify(mockShortenerRepository.getOriginalUrl(testId));

      expect(result, equals(const Right(testOriginalUrl)));
      verifyNoMoreInteractions(mockShortenerRepository);
    });

    test('''Should not find alias id and return
         OriginalUrlNotFoundErrorModel from GetOriginalUrlUseCase''', () async {
      // arrange
      when(mockShortenerRepository.getOriginalUrl(testId))
          .thenAnswer((_) async => const Right(testOriginalUrl));
      // act
      final result = await useCase(testId);
      // assert
      verify(mockShortenerRepository.getOriginalUrl(testId));

      expect(result, equals(const Right(testOriginalUrl)));
      verifyNoMoreInteractions(mockShortenerRepository);
    });
  });
}
