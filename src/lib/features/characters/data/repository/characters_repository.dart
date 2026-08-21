import 'package:dio/dio.dart';
import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/data/datasources/characters_api.dart';
import 'package:riki_morty_wiki/features/characters/data/mappers/character_mapper.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/repository/i_characters_repository.dart';

class CharactersRepository implements ICharactersRepository {
  const CharactersRepository(this._api);

  final CharactersApi _api;

  @override
  Future<DataState<CharactersPageEntity>> getCharacters({
    required int page,
    String? name,
  }) async {
    try {
      final response = await _api.getCharacters(page, name);

      return DataSuccess(data: response.toEntity(requestedPage: page));
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const DataSuccess(
          data: CharactersPageEntity(
            characters: [],
            nextPage: null,
            hasReachedMax: true,
            totalCount: 0,
          ),
        );
      }

      return DataError(error: error);
    }
  }
}
