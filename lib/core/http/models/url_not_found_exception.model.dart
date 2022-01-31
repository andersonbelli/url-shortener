import 'package:nubanktest/core/http/models/base_exception.model.dart';

class UrlNotFoundException extends BaseException {
  UrlNotFoundException(String message) : super(message);
}