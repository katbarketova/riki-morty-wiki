import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/data/datasources/characters_api.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/character_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_info_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_response_dto.dart';
import 'package:riki_morty_wiki/features/characters/data/repository/characters_repository.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';

void main() {
  group('CharactersRepository', () {
    test('passes page and name to API and maps successful response', () async {
      final api = _FakeCharactersApi(
        response: const CharactersResponseDto(
          info: CharactersInfoDto(count: 1),
          results: [CharacterDto(name: 'Rick Sanchez')],
        ),
      );
      final repository = CharactersRepository(api);

      final result = await repository.getCharacters(page: 1, name: 'Rick');

      expect(api.requests, equals([const _ApiRequest(page: 1, name: 'Rick')]));
      expect(
        result,
        isA<DataSuccess<CharactersPageEntity>>().having(
          (state) => state.data,
          'data',
          const CharactersPageEntity(
            characters: [CharacterEntity(name: 'Rick Sanchez')],
            nextPage: null,
            hasReachedMax: true,
            totalCount: 1,
          ),
        ),
      );
    });

    test('maps 404 response to empty successful page', () async {
      final api = _FakeCharactersApi(
        error: DioException(
          requestOptions: RequestOptions(path: '/character'),
          response: Response(
            requestOptions: RequestOptions(path: '/character'),
            statusCode: 404,
          ),
        ),
      );
      final repository = CharactersRepository(api);

      final result = await repository.getCharacters(page: 1, name: 'Unknown');

      expect(
        result,
        isA<DataSuccess<CharactersPageEntity>>().having(
          (state) => state.data,
          'data',
          const CharactersPageEntity(
            characters: [],
            nextPage: null,
            hasReachedMax: true,
            totalCount: 0,
          ),
        ),
      );
    });
  });
}

class _FakeCharactersApi implements CharactersApi {
  _FakeCharactersApi({this.response, this.error});

  final CharactersResponseDto? response;
  final DioException? error;
  final List<_ApiRequest> requests = [];

  @override
  Future<CharactersResponseDto> getCharacters(int page, String? name) async {
    requests.add(_ApiRequest(page: page, name: name));

    final error = this.error;
    if (error != null) {
      throw error;
    }

    return response!;
  }
}

class _ApiRequest {
  const _ApiRequest({required this.page, required this.name});

  final int page;
  final String? name;

  @override
  bool operator ==(Object other) {
    return other is _ApiRequest && other.page == page && other.name == name;
  }

  @override
  int get hashCode => Object.hash(page, name);

  @override
  String toString() => '_ApiRequest(page: $page, name: $name)';
}
