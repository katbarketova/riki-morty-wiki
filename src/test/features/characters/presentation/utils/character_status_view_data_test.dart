import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riki_morty_wiki/features/characters/presentation/utils/character_status_view_data.dart';

void main() {
  group('character status view data', () {
    test('maps alive status to alive text and green color', () {
      expect(characterStatusText('Alive'), equals('Alive'));
      expect(characterStatusColor('Alive'), equals(Colors.green));
    });

    test('maps dead status to dead text and red color', () {
      expect(characterStatusText('Dead'), equals('Dead'));
      expect(characterStatusColor('Dead'), equals(Colors.red));
    });

    test('maps unknown status to unknown text and grey color', () {
      expect(characterStatusText('unknown'), equals('Unknown'));
      expect(characterStatusColor('unknown'), equals(Colors.grey));
    });
  });
}
