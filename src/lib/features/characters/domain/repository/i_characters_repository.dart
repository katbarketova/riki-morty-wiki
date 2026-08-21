import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

abstract interface class ICharactersRepository {
  Future<DataState<List<CharacterEntity>>> getCharacters();
}
