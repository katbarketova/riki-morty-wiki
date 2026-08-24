import 'package:flutter/material.dart';
import 'package:riki_morty_wiki/core/di/service_locator.dart';
import 'package:riki_morty_wiki/features/characters/presentation/pages/characters_page.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riki and Morty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const CharactersPage(),
    );
  }
}
