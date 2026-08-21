import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/domain/entities/character_entity.dart';
import 'package:riki_morty_wiki/features/characters/presentation/pages/character_details_page.dart';

void main() {
  group('CharacterDetailsPage', () {
    testWidgets(
      'shows character image placeholder and top-left aligned details',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CharacterDetailsPage(
              character: CharacterEntity(
                id: 1,
                name: 'Rick Sanchez',
                status: 'Alive',
                species: 'Human',
                type: '',
                gender: 'Male',
              ),
            ),
          ),
        );

        expect(find.text('К списку'), findsOneWidget);
        expect(find.text('Rick Sanchez'), findsWidgets);
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Alive'), findsOneWidget);
        expect(find.text('Species'), findsOneWidget);
        expect(find.text('Human'), findsOneWidget);
        expect(find.text('Gender'), findsOneWidget);
        expect(find.text('Male'), findsOneWidget);
        expect(find.text('ID'), findsNothing);
        expect(find.text('1'), findsNothing);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);

        final imageAlignment = tester.widget<Align>(
          find.byKey(const ValueKey('character_details_image_alignment')),
        );
        expect(imageAlignment.alignment, Alignment.topCenter);

        final textAlignment = tester.widget<Align>(
          find.byKey(const ValueKey('character_details_text_alignment')),
        );
        expect(textAlignment.alignment, Alignment.topLeft);

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.padding, equals(const EdgeInsets.all(24)));

        final nameText = tester.widget<Text>(
          find.byKey(const ValueKey('character_details_name')),
        );
        expect(nameText.textAlign, TextAlign.left);
        expect(nameText.style?.fontWeight, FontWeight.w700);
        expect(nameText.style?.fontSize, equals(20));
      },
    );

    testWidgets('maps status text using the shared status presentation logic', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CharacterDetailsPage(
            character: CharacterEntity(name: 'Birdperson', status: 'unknown'),
          ),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Unknown'), findsWidgets);
    });
  });
}
