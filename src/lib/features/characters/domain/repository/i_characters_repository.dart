import '../../../../core/resources/data_state.dart';
import '../entities/character_entity.dart';

abstract interface class ICharactersRepository {
  Future<DataState<List<CharacterEntity>>> getCharacters();
}
