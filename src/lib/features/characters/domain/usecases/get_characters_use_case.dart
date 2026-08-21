import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/params/get_characters_params.dart';
import 'package:riki_morty_wiki/features/characters/domain/repository/i_characters_repository.dart';

class GetCharactersUseCase {
  const GetCharactersUseCase(this._repository);

  final ICharactersRepository _repository;

  Future<DataState<CharactersPageEntity>> call(GetCharactersParams params) {
    return _repository.getCharacters(page: params.page, name: params.name);
  }
}
