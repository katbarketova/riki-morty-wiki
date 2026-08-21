import 'package:json_annotation/json_annotation.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

part 'character_dto.g.dart';

@JsonSerializable()
class CharacterDto {
  const CharacterDto({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.image,
  });

  final String? id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;
  final String? image;

  factory CharacterDto.fromJson(Map<String, dynamic> json) =>
      _$CharacterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterDtoToJson(this);

  CharacterEntity toEntity() => CharacterEntity(
    id: id,
    name: name,
    status: status,
    species: species,
    type: type,
    gender: gender,
    image: image,
  );
}
