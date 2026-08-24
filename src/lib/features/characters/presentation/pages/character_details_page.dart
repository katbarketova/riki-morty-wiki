import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/presentation/utils/character_status_view_data.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/character_details_field.dart';

class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({super.key, required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final imageUrl = character.image;
    final screenSize = MediaQuery.sizeOf(context);
    final imageSize = math.min(screenSize.width - 48, screenSize.height * 0.5);

    return Scaffold(
      appBar: AppBar(
        title: Text('К списку', style: Theme.of(context).textTheme.titleSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                key: const ValueKey('character_details_image_alignment'),
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox.square(
                    dimension: imageSize,
                    child: imageUrl == null
                        ? const ColoredBox(
                            color: Colors.black12,
                            child: Icon(Icons.person_outline, size: 96),
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ColoredBox(
                              color: Colors.black12,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const ColoredBox(
                                  color: Colors.black12,
                                  child: Icon(Icons.person_outline, size: 96),
                                ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                key: const ValueKey('character_details_text_alignment'),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      character.name ?? 'Unknown character',
                      key: const ValueKey('character_details_name'),
                      textAlign: TextAlign.left,
                      style: _characterNameStyle(context),
                    ),
                    const SizedBox(height: 16),
                    CharacterDetailsField(
                      label: 'Status',
                      value: characterStatusText(character.status),
                    ),
                    CharacterDetailsField(
                      label: 'Species',
                      value: character.species,
                    ),
                    CharacterDetailsField(label: 'Type', value: character.type),
                    CharacterDetailsField(
                      label: 'Gender',
                      value: character.gender,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle? _characterNameStyle(BuildContext context) {
  final style = Theme.of(context).textTheme.titleMedium;

  return style?.copyWith(
    fontSize: (style.fontSize ?? 16) + 4,
    fontWeight: FontWeight.w700,
  );
}
