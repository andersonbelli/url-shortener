import 'package:teststudy/data/models/original_url/original_url.model.dart';

class OriginalUrlNotFoundErrorModel extends OriginalUrlModel {
  final String error;

  const OriginalUrlNotFoundErrorModel({required this.error}) : super(url: "");

  factory OriginalUrlNotFoundErrorModel.fromJson(Map<String, dynamic> map) {
    return OriginalUrlNotFoundErrorModel(
      error: map['error'] as String,
    );
  }
}
