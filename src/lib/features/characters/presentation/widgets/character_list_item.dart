import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

class CharacterListItem extends StatelessWidget {
  const CharacterListItem({super.key, required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = character.name ?? 'Unknown character';
    final status = character.status ?? 'Unknown';
    final species = character.species ?? 'Unknown species';
    final image = character.image;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox.square(
          dimension: 56,
          child: image == null
              ? const ColoredBox(
                  color: Colors.black12,
                  child: Icon(Icons.person_outline),
                )
              : CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ColoredBox(
                    color: Colors.black12,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.person_outline),
                  ),
                ),
        ),
      ),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '$status - $species',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: character.id == null
          ? null
          : Text('#${character.id}', style: theme.textTheme.labelMedium),
    );
  }
}
