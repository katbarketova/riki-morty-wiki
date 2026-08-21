import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/character_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_info_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_response_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/mappers/character_mapper.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

void main() {
  group('CharacterMapper', () {
    test('maps every character field to an entity', () {
      const dto = CharacterDto(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: 'Genetic experiment',
        gender: 'Male',
        image: 'https://example.com/rick.png',
      );

      expect(
        dto.toEntity(),
        equals(
          const CharacterEntity(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            type: 'Genetic experiment',
            gender: 'Male',
            image: 'https://example.com/rick.png',
          ),
        ),
      );
    });

    test('preserves nullable character fields', () {
      const dto = CharacterDto();

      expect(dto.toEntity(), equals(const CharacterEntity()));
    });
  });

  group('CharactersResponseMapper', () {
    test('maps results and calculates next page when API has next page', () {
      const dto = CharactersResponseDto(
        info: CharactersInfoDto(
          count: 826,
          next: 'https://example.test/characters?page=3',
        ),
        results: [
          CharacterDto(id: 1, name: 'Rick Sanchez', status: 'Alive'),
          CharacterDto(id: 2, name: 'Morty Smith', status: 'Alive'),
        ],
      );

      final entity = dto.toEntity(requestedPage: 2);

      expect(
        entity.characters,
        equals(const [
          CharacterEntity(id: 1, name: 'Rick Sanchez', status: 'Alive'),
          CharacterEntity(id: 2, name: 'Morty Smith', status: 'Alive'),
        ]),
      );
      expect(entity.nextPage, equals(3));
      expect(entity.hasReachedMax, isFalse);
      expect(entity.totalCount, equals(826));
    });

    test('marks maximum reached and defaults total count to zero', () {
      const dto = CharactersResponseDto(info: CharactersInfoDto(), results: []);

      final entity = dto.toEntity(requestedPage: 42);

      expect(entity.characters, isEmpty);
      expect(entity.nextPage, isNull);
      expect(entity.hasReachedMax, isTrue);
      expect(entity.totalCount, equals(0));
    });
  });
}
