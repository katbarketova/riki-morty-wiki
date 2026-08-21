sealed class CharactersEvent {
  const CharactersEvent();
}

class CharactersFetchRequested extends CharactersEvent {
  const CharactersFetchRequested({this.force = false});

  final bool force;
}
