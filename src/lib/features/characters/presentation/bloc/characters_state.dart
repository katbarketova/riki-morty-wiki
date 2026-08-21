import 'package:equatable/equatable.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const <CharacterEntity>[],
    this.nextPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isLoadMoreRetryRequired = false,
    this.totalCount = 0,
    this.errorMessage,
  });

  final CharactersStatus status;
  final List<CharacterEntity> characters;
  final int? nextPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isLoadMoreRetryRequired;
  final int totalCount;
  final String? errorMessage;

  CharactersState copyWith({
    CharactersStatus? status,
    List<CharacterEntity>? characters,
    int? nextPage,
    bool clearNextPage = false,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isLoadMoreRetryRequired,
    int? totalCount,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      nextPage: clearNextPage ? null : nextPage ?? this.nextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadMoreRetryRequired:
          isLoadMoreRetryRequired ?? this.isLoadMoreRetryRequired,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    characters,
    nextPage,
    hasReachedMax,
    isLoadingMore,
    isLoadMoreRetryRequired,
    totalCount,
    errorMessage,
  ];
}
