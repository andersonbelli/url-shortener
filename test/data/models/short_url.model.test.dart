import 'package:flutter_test/flutter_test.dart';
import 'package:teststudy/data/models/links/links.model.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';
import 'package:teststudy/domain/entities/short_url.entity.dart';

void main() {
  const testLinksJson = {
    "self": "https://www.google.com",
    "short": "https://url-shortener-nu.herokuapp.com/short/28431"
  };

  const testCompleteJson = {"alias": "28431", "_links": testLinksJson};

  const testCompleteJsonWithLinkModel = {
    "alias": "28431",
    "_links": LinksModel(
      self: "https://www.google.com",
      short: "https://url-shortener-nu.herokuapp.com/short/28431",
    ),
  };

  const testLinks = LinksModel(
    self: "https://www.google.com",
    short: "https://url-shortener-nu.herokuapp.com/short/28431",
  );

  const testShortUrl = ShortUrlModel(
    alias: '28431',
    links: testLinks,
  );

  test(
    'should be a subclass of ShortUrl entity',
    () async {
      // assert
      expect(testShortUrl, isA<ShortUrl>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid ShortUrlModel with the given JSON',
      () async {
        // act
        final result = ShortUrlModel.fromJson(testCompleteJson);
        // assert
        expect(result, isInstanceOf<ShortUrlModel>());
      },
    );

    test(
      'should return a valid LinksModel with the given JSON',
      () async {
        // act
        final result = LinksModel.fromJson(testLinksJson);
        // assert
        expect(result, isInstanceOf<LinksModel>());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the ShortUrlModel data',
      () async {
        // act
        final result = testShortUrl.toJson();
        // assert
        expect(result, testCompleteJsonWithLinkModel);
      },
    );

    test(
      'should return a JSON map containing the LinksModel data',
      () async {
        // act
        final result = testLinks.toJson();
        // assert
        expect(result, testLinksJson);
      },
    );
  });
}
