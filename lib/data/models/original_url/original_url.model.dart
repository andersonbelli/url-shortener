
import 'package:nubanktest/domain/entities/original_url.entity.dart';

class OriginalUrlModel extends OriginalUrl {
  const OriginalUrlModel({
    required String url,
  }) : super(
          url: url,
        );

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  factory OriginalUrlModel.fromJson(Map<String, dynamic> map) {
    return OriginalUrlModel(
      url: map['url'] as String,
    );
  }
}
