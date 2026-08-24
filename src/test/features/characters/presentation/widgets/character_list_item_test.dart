import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/character_list_item.dart';

void main() {
  group('CharacterListItem', () {
    testWidgets('shows character name and species', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterListItem(
              character: CharacterEntity(name: 'Morty Smith', species: 'Human'),
            ),
          ),
        ),
      );

      expect(find.text('Morty Smith'), findsOneWidget);
      expect(find.text('Human'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterListItem(
              character: const CharacterEntity(name: 'Summer Smith'),
              onTap: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CharacterListItem));
      await tester.pump();

      expect(tapCount, equals(1));
    });
  });
}
