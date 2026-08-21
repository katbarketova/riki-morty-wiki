import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/repository/i_characters_repository.dart';

class CharactersReporitory implements ICharactersRepository {
  CharactersReporitory();

  @override
  Future<DataState<List<CharacterEntity>>> getCharacters() {
    // TODO: implement getCharacters
    throw UnimplementedError();
  }
}
