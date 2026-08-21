import 'package:flutter/material.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/character_image.dart';

class CharacterListItem extends StatelessWidget {
  const CharacterListItem({super.key, required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final name = character.name ?? 'Unknown character';
    final species = character.species ?? 'Unknown species';
    final image = character.image;

    return ListTile(
      leading: CharacterImage(imageUrl: image, status: character.status),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(species, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
