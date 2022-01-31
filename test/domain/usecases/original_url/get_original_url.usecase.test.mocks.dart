// Mocks generated by Mockito 5.0.17 from annotations
// in nubanktest/test/domain/usecases/original_url/get_original_url.usecase.test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:nubanktest/core/http/models/base_exception.model.dart' as _i5;
import 'package:nubanktest/domain/entities/original_url.entity.dart' as _i7;
import 'package:nubanktest/domain/entities/short_url.entity.dart' as _i6;
import 'package:nubanktest/domain/repositories/shortener.repository.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [ShortenerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockShortenerRepository extends _i1.Mock
    implements _i3.ShortenerRepository {
  MockShortenerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.BaseException, _i6.ShortUrl>> shortUrl(
          String? urlToBeShortened) =>
      (super.noSuchMethod(Invocation.method(#shortUrl, [urlToBeShortened]),
              returnValue:
                  Future<_i2.Either<_i5.BaseException, _i6.ShortUrl>>.value(
                      _FakeEither_0<_i5.BaseException, _i6.ShortUrl>()))
          as _i4.Future<_i2.Either<_i5.BaseException, _i6.ShortUrl>>);
  @override
  _i4.Future<_i2.Either<_i5.BaseException, _i7.OriginalUrl>> getOriginalUrl(
          String? id) =>
      (super.noSuchMethod(Invocation.method(#getOriginalUrl, [id]),
              returnValue:
                  Future<_i2.Either<_i5.BaseException, _i7.OriginalUrl>>.value(
                      _FakeEither_0<_i5.BaseException, _i7.OriginalUrl>()))
          as _i4.Future<_i2.Either<_i5.BaseException, _i7.OriginalUrl>>);
}
