import 'package:nubanktest/core/http/models/base_exception.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';

class UrlGenericErrorModel extends BaseException {
  final String? exception;

  UrlGenericErrorModel({this.exception}) : super(exception ?? 'Something went wrong :(');
}
