import 'package:teststudy/data/models/links/links.model.dart';
import 'package:teststudy/domain/entities/short_url.entity.dart';

class ShortUrlModel extends ShortUrl {
  const ShortUrlModel({
    required String alias,
    required LinksModel links,
  }) : super(
          alias: alias,
          links: links,
        );

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      '_links': links,
    };
  }

  factory ShortUrlModel.fromJson(Map<String, dynamic> map) {
    return ShortUrlModel(
      alias: map['alias'] as String,
      links: LinksModel.fromJson(map['_links']),
    );
  }
}
