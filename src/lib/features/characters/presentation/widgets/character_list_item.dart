import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';

class CharacterListItem extends StatelessWidget {
  const CharacterListItem({super.key, required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final name = character.name ?? 'Unknown character';
    final species = character.species ?? 'Unknown species';
    final image = character.image;

    return ListTile(
      leading: _CharacterImage(imageUrl: image, status: character.status),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(species, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  const _CharacterImage({required this.imageUrl, required this.status});

  final String? imageUrl;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl == null
                  ? const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.person_outline),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
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
          Positioned(
            right: 2,
            bottom: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _statusColor(status),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: const SizedBox.square(dimension: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    return switch (status?.toLowerCase()) {
      'alive' => Colors.green,
      'dead' => Colors.red,
      _ => Colors.grey,
    };
  }
}
