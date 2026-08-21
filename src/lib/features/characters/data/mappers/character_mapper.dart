import 'package:riki_morty_wiki/features/characters/data/dto/character_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_response_dto.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';

extension CharacterMapper on CharacterDto {
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

extension CharactersResponseMapper on CharactersResponseDto {
  CharactersPageEntity toEntity({required int requestedPage}) {
    final hasReachedMax = info.next == null;

    return CharactersPageEntity(
      characters: results.map((character) => character.toEntity()).toList(),
      nextPage: hasReachedMax ? null : requestedPage + 1,
      hasReachedMax: hasReachedMax,
      totalCount: info.count ?? 0,
    );
  }
}
