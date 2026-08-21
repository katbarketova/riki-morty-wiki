import 'package:json_annotation/json_annotation.dart';

part 'characters_info_dto.g.dart';

@JsonSerializable()
class CharactersInfoDto {
  const CharactersInfoDto({this.count, this.pages, this.next, this.prev});

  final int? count;
  final int? pages;
  final String? next;
  final String? prev;

  factory CharactersInfoDto.fromJson(Map<String, dynamic> json) =>
      _$CharactersInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersInfoDtoToJson(this);
}
