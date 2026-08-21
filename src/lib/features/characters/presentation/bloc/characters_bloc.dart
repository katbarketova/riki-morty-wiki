import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riki_morty_wiki/core/resources/data_state.dart';
import 'package:riki_morty_wiki/features/characters/domain/params/get_characters_params.dart';
import 'package:riki_morty_wiki/features/characters/domain/usecases/get_characters_use_case.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_effect.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_state.dart';
import 'package:stream_transform/stream_transform.dart';

const _fetchThrottleDuration = Duration(milliseconds: 700);
const _searchDebounceDuration = Duration(milliseconds: 500);

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._getCharactersUseCase) : super(const CharactersState()) {
    on<CharactersFetchRequested>(
      _onFetchRequested,
      transformer: _throttleDroppable(_fetchThrottleDuration),
    );
    on<CharactersSearchChanged>(
      _onSearchChanged,
      transformer: _debounceRestartable(_searchDebounceDuration),
    );
  }

  final GetCharactersUseCase _getCharactersUseCase;
  final _effectController = StreamController<CharactersEffect>.broadcast();
  int _requestToken = 0;

  Stream<CharactersEffect> get effects => _effectController.stream;

  Future<void> _onFetchRequested(
    CharactersFetchRequested event,
    Emitter<CharactersState> emit,
  ) async {
    await _fetchCharacters(force: event.force, emit: emit);
  }

  Future<void> _fetchCharacters({
    required bool force,
    required Emitter<CharactersState> emit,
  }) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.status == CharactersStatus.loading ||
        state.isLoadMoreRetryRequired && !force) {
      return;
    }

    final page = state.nextPage;

    if (page == null) {
      return;
    }

    final requestToken = ++_requestToken;
    final normalizedName = _normalizeSearchName(state.searchName);

    if (state.status == CharactersStatus.initial) {
      emit(state.copyWith(status: CharactersStatus.loading));
    } else {
      emit(
        state.copyWith(
          isLoadingMore: true,
          isLoadMoreRetryRequired: false,
          clearErrorMessage: true,
        ),
      );
    }

    final result = await _getCharactersUseCase(
      GetCharactersParams(page: page, name: normalizedName),
    );

    if (requestToken != _requestToken) {
      return;
    }

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
            isLoadMoreRetryRequired: false,
            totalCount: charactersPage.totalCount,
            clearErrorMessage: true,
          ),
        );
      case DataError(error: final error?):
        _handleFailure(emit, error.message ?? 'Failed to load characters');
      default:
        _handleFailure(emit, 'Failed to load characters');
    }
  }

  Future<void> _onSearchChanged(
    CharactersSearchChanged event,
    Emitter<CharactersState> emit,
  ) async {
    final searchName = event.name.trim();

    if (searchName == state.searchName) {
      return;
    }

    emit(
      state.copyWith(
        status: CharactersStatus.initial,
        characters: const [],
        nextPage: 1,
        hasReachedMax: false,
        isLoadingMore: false,
        isLoadMoreRetryRequired: false,
        totalCount: 0,
        searchName: searchName,
        clearErrorMessage: true,
      ),
    );

    await _fetchCharacters(force: true, emit: emit);
  }

  void _handleFailure(Emitter<CharactersState> emit, String message) {
    if (state.characters.isEmpty) {
      emit(
        state.copyWith(
          status: CharactersStatus.failure,
          isLoadingMore: false,
          errorMessage: message,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: CharactersStatus.success,
        isLoadingMore: false,
        isLoadMoreRetryRequired: true,
        clearErrorMessage: true,
      ),
    );
    _effectController.add(CharactersLoadMoreFailed(message: message));
  }

  @override
  Future<void> close() async {
    await _effectController.close();
    return super.close();
  }
}

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounce(duration), mapper);
  };
}

String? _normalizeSearchName(String value) {
  final trimmed = value.trim();

  return trimmed.isEmpty ? null : trimmed;
}
