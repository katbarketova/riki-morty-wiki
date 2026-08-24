sealed class CharactersEffect {
  const CharactersEffect();
}

class CharactersLoadMoreFailed extends CharactersEffect {
  const CharactersLoadMoreFailed({required this.message});

  final String message;
}
