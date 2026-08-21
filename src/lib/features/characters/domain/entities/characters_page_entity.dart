import 'package:equatable/equatable.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

class CharactersPageEntity extends Equatable {
  const CharactersPageEntity({
    required this.characters,
    required this.nextPage,
    required this.hasReachedMax,
  });

  final List<CharacterEntity> characters;
  final int? nextPage;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [characters, nextPage, hasReachedMax];
}
