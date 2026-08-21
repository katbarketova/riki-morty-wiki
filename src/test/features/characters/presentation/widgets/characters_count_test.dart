import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_count.dart';

void main() {
  group('CharactersCount', () {
    testWidgets('shows zero count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CharactersCount(totalCount: 0))),
      );

      expect(find.text('0'), findsOneWidget);
    });
  });
}
