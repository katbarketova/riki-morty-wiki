import 'package:json_annotation/json_annotation.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/character_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_info_dto.dart';

part 'characters_response_dto.g.dart';

@JsonSerializable()
class CharactersResponseDto {
  const CharactersResponseDto({required this.info, required this.results});

  final CharactersInfoDto info;
  final List<CharacterDto> results;

  factory CharactersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CharactersResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersResponseDtoToJson(this);
}
