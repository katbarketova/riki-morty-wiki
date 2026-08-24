import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';

abstract interface class ICharactersRepository {
  Future<DataState<CharactersPageEntity>> getCharacters({
    required int page,
    String? name,
  });
}
