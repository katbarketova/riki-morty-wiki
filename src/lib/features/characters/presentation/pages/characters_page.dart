import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riki_morty_wiki/core/di/service_locator.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_view.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CharactersBloc>()..add(const CharactersFetchRequested()),
      child: const CharactersView(),
    );
  }
}
