import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/character_entity.dart';

part 'character_dto.g.dart';

@JsonSerializable()
class CharacterDto extends CharacterEntity {
  const CharacterDto({
    super.id,
    super.name,
    super.status,
    super.species,
    super.type,
    super.gender,
    super.image,
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) =>
      _$CharacterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterDtoToJson(this);
}
