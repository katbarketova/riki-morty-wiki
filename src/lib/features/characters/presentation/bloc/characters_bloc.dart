import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/params/get_characters_params.dart';
import 'package:riki_morty_wiki/features/characters/domain/usecases/get_characters_use_case.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._getCharactersUseCase) : super(const CharactersState()) {
    on<CharactersFetchRequested>(_onFetchRequested);
  }

  final GetCharactersUseCase _getCharactersUseCase;

  Future<void> _onFetchRequested(
    CharactersFetchRequested event,
    Emitter<CharactersState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.status == CharactersStatus.loading) {
      return;
    }

    final page = state.nextPage;

    if (page == null) {
      return;
    }

    if (state.status == CharactersStatus.initial) {
      emit(state.copyWith(status: CharactersStatus.loading));
    } else {
      emit(state.copyWith(isLoadingMore: true, clearErrorMessage: true));
    }

    final result = await _getCharactersUseCase(GetCharactersParams(page: page));

    switch (result) {
      case DataSuccess(data: final charactersPage?):
        emit(
          state.copyWith(
            status: CharactersStatus.success,
            characters: [...state.characters, ...charactersPage.characters],
            nextPage: charactersPage.nextPage,
            clearNextPage: charactersPage.nextPage == null,
            hasReachedMax: charactersPage.hasReachedMax,
            isLoadingMore: false,
            totalCount: charactersPage.totalCount,
            clearErrorMessage: true,
          ),
        );
      case DataError(error: final error?):
        emit(
          state.copyWith(
            status: state.characters.isEmpty
                ? CharactersStatus.failure
                : CharactersStatus.success,
            isLoadingMore: false,
            errorMessage: error.message ?? 'Failed to load characters',
          ),
        );
      default:
        emit(
          state.copyWith(
            status: state.characters.isEmpty
                ? CharactersStatus.failure
                : CharactersStatus.success,
            isLoadingMore: false,
            errorMessage: 'Failed to load characters',
          ),
        );
    }
  }
}
