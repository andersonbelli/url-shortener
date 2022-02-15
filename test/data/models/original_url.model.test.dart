import 'package:flutter_test/flutter_test.dart';
import 'package:teststudy/data/models/original_url/original_url.model.dart';
import 'package:teststudy/data/models/original_url/original_url_error.model.dart';
import 'package:teststudy/domain/entities/original_url.entity.dart';

void main() {
  const testResponseJson = {"url": "https://www.google.com"};

  const testErrorResponseJson = {"error": "Alias for 000 not found"};

  const testOriginalUrl = OriginalUrlModel(
    url: "https://www.google.com",
  );

  const testOriginalUrlNotFound = OriginalUrlNotFoundErrorModel(
    error: "Alias for 28431 not found",
  );

  test(
    'should be a subclass of OriginalUrl entity',
    () async {
      // assert
      expect(testOriginalUrl, isA<OriginalUrl>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid OriginalUrlModel with the given JSON',
      () async {
        // act
        final result = OriginalUrlModel.fromJson(testResponseJson);
        // assert
        expect(result, isInstanceOf<OriginalUrlModel>());
      },
    );

    test(
      'should return a valid OriginalUrlNotFoundErrorModel with the given JSON',
      () async {
        // act
        final result =
            OriginalUrlNotFoundErrorModel.fromJson(testErrorResponseJson);
        // assert
        expect(result, isInstanceOf<OriginalUrlNotFoundErrorModel>());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the OriginalUrlModel data',
      () async {
        // act
        final result = testOriginalUrl.toJson();
        // assert
        expect(result, testResponseJson);
      },
    );
  });
}
