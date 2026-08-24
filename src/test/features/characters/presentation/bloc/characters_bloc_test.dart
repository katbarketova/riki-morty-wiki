import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/characters_page_entity.dart';
import 'package:riki_morty_wiki/features/characters/domain/repository/i_characters_repository.dart';
import 'package:riki_morty_wiki/features/characters/domain/usecases/get_characters_use_case.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_state.dart';

void main() {
  group('CharactersBloc search', () {
    test('debounces search input and requests only latest name', () async {
      final repository = _FakeCharactersRepository();
      final bloc = CharactersBloc(GetCharactersUseCase(repository));
      addTearDown(bloc.close);

      bloc
        ..add(const CharactersSearchChanged('Ri'))
        ..add(const CharactersSearchChanged('Rick'));

      await Future<void>.delayed(const Duration(milliseconds: 700));

      expect(
        repository.requests,
        equals([const _Request(page: 1, name: 'Rick')]),
      );
      expect(bloc.state.status, CharactersStatus.success);
      expect(bloc.state.searchName, equals('Rick'));
      expect(
        bloc.state.characters,
        equals(const [CharacterEntity(name: 'Rick')]),
      );
    });

    test('ignores repeated normalized search name', () async {
      final repository = _FakeCharactersRepository();
      final bloc = CharactersBloc(GetCharactersUseCase(repository));
      addTearDown(bloc.close);

      bloc.add(const CharactersSearchChanged('Rick'));
      await Future<void>.delayed(const Duration(milliseconds: 700));

      bloc.add(const CharactersSearchChanged('  Rick  '));
      await Future<void>.delayed(const Duration(milliseconds: 700));

      expect(
        repository.requests,
        equals([const _Request(page: 1, name: 'Rick')]),
      );
    });
  });
}

class _FakeCharactersRepository implements ICharactersRepository {
  final List<_Request> requests = [];

  @override
  Future<DataState<CharactersPageEntity>> getCharacters({
    required int page,
    String? name,
  }) async {
    requests.add(_Request(page: page, name: name));

    return DataSuccess(
      data: CharactersPageEntity(
        characters: [CharacterEntity(name: name)],
        nextPage: null,
        hasReachedMax: true,
        totalCount: 1,
      ),
    );
  }
}

class _Request {
  const _Request({required this.page, required this.name});

  final int page;
  final String? name;

  @override
  bool operator ==(Object other) {
    return other is _Request && other.page == page && other.name == name;
  }

  @override
  int get hashCode => Object.hash(page, name);

  @override
  String toString() => '_Request(page: $page, name: $name)';
}
