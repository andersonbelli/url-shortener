import 'package:nubanktest/domain/entities/links.entity.dart';

class LinksModel extends Links {
  const LinksModel({
    required String self,
    required String short,
  }) : super(
    self: self,
    short: short,
  );

  Map<String, dynamic> toJson() {
    return {
      'self': self,
      'short': short,
    };
  }

  factory LinksModel.fromJson(Map<String, dynamic> map) {
    return LinksModel(
      self: map['self'] as String,
      short: map['short'] as String,
    );
  }
}
