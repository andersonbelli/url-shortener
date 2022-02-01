import 'package:nubanktest/core/http/models/base_exception.model.dart';

class UrlNotFoundException extends BaseException {
  final String? error;

  UrlNotFoundException({this.error})
      : super(error ?? "Alias could not be found");
}
