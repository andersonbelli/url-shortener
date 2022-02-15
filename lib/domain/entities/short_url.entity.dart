import 'package:teststudy/domain/entities/links.entity.dart';

class ShortUrl {
  final String alias;
  final Links links;

  const ShortUrl({
    required this.alias,
    required this.links,
  });
}