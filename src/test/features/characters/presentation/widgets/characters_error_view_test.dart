import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_error_view.dart';

void main() {
  group('CharactersErrorView', () {
    testWidgets('shows error message and retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharactersErrorView(
              message: 'Failed to load characters',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Failed to load characters'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
