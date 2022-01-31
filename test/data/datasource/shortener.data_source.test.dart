import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/core/http/dio_impl.dart';
import 'package:nubanktest/data/datasource/shortener.data_source.dart';
import 'package:nubanktest/data/models/original_url/original_url.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';

import 'shortener.data_source.test.mocks.dart';

@GenerateMocks([DioImpl])
void main() {
  const testUrl = "https://www.google.com";

  late MockDioImpl dioMock;
  late ShortenerDataSourceImpl shortenerDataSourceImpl;

  setUpAll(() {
    dioMock = MockDioImpl();
    shortenerDataSourceImpl = ShortenerDataSourceImpl(httpManager: dioMock);
  });

  group('Shortener POST datasource test', () {
    const testResponseJson = {
      "alias": "28431",
      "_links": {
        "self": "https://www.google.com",
        "short": "https://url-shortener-nu.herokuapp.com/short/28431"
      }
    };

    test(
      '''Should perform a POST request passing the url
         to be shortened as a parameter''',
      () async {
        // arrange
        when(dioMock.post(any, {"url": testUrl})).thenAnswer(
          (_) async => Response(
            data: testResponseJson,
            requestOptions: RequestOptions(path: ""),
          ),
        );
        // act
        shortenerDataSourceImpl.shortUrl(testUrl);
        // assert
        verify(
          dioMock.post(any, {"url": testUrl}),
        );
      },
    );

    test(
      '''Should perform a POST request passing the url
         to be shortened as a parameter and receive
         successful response''',
      () async {
        // arrange
        when(dioMock.post(any, {"url": testUrl})).thenAnswer(
          (_) async => Response(
            data: testResponseJson,
            requestOptions: RequestOptions(path: ""),
          ),
        );
        // act
        final result = await shortenerDataSourceImpl.shortUrl(testUrl);
        // assert
        expect(result, isA<ShortUrlModel>());
      },
    );
  });

  group('Shortener GET datasource test', () {
    const testResponseJson = {"url": "https://www.google.com"};

    const testErrorResponseJson = {"error": "Alias for 000 not found"};

    const testSuccessId = "28431";

    const testFailId = "000";

    test(
      '''Should perform a GET request passing a real alias id
         in the parameter and receiving the original url in response''',
      () async {
        // arrange
        when(dioMock.get(any)).thenAnswer(
          (_) async => Response(
            data: testResponseJson,
            requestOptions: RequestOptions(path: ""),
          ),
        );
        // act
        final result =
            await shortenerDataSourceImpl.getOriginalUrl(testSuccessId);
        // assert
        expect(result, isA<OriginalUrlModel>());
      },
    );

    test(
      '''Should perform a GET request passing a fake alias id
         in the parameter and receiving an error in response''',
      () async {
        // arrange
        when(dioMock.get(any)).thenAnswer(
          (_) async => Response(
            data: testErrorResponseJson,
            requestOptions: RequestOptions(path: ""),
          ),
        );
        // act
        final result = await shortenerDataSourceImpl.getOriginalUrl(testFailId);
        // assert
        expect(result, isA<OriginalUrlModel>());
      },
    );
  });
}
