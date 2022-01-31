import 'package:nubanktest/core/http/models/base_exception.model.dart';

class UrlGenericErrorModel extends BaseException {
  final String? exception;

  UrlGenericErrorModel({this.exception}) : super(exception ?? 'Something went wrong, please try again');
}
