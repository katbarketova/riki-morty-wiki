import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_effect.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_state.dart';
import 'package:riki_morty_wiki/features/characters/presentation/pages/character_details_page.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/character_list_item.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_count.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_error_snack_bar.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/characters_error_view.dart';

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  final _scrollController = ScrollController();
  StreamSubscription<CharactersEffect>? _effectSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectSubscription ??= context.read<CharactersBloc>().effects.listen(
      _handleEffect,
    );
  }

  @override
  void dispose() {
    _effectSubscription?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CharactersBloc, CharactersState>(
          buildWhen: (previous, current) =>
              previous.totalCount != current.totalCount,
          builder: (context, state) {
            return Row(
              children: [
                const Text('Wiki'),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (value) => context.read<CharactersBloc>().add(
                        CharactersSearchChanged(value),
                      ),
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Search by name',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                CharactersCount(totalCount: state.totalCount),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          return switch (state.status) {
            CharactersStatus.initial || CharactersStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            CharactersStatus.failure when state.characters.isEmpty =>
              CharactersErrorView(
                message: state.errorMessage ?? 'Failed to load characters',
                onRetry: () => context.read<CharactersBloc>().add(
                  const CharactersFetchRequested(),
                ),
              ),
            _ when state.characters.isEmpty => const Center(
              child: Text('No characters found'),
            ),
            _ => ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax || state.isLoadMoreRetryRequired
                  ? state.characters.length
                  : state.characters.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.characters.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final character = state.characters[index];

                return CharacterListItem(
                  character: character,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          CharacterDetailsPage(character: character),
                    ),
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }

  void _handleEffect(CharactersEffect effect) {
    switch (effect) {
      case CharactersLoadMoreFailed(message: final message):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            buildCharactersErrorSnackBar(
              context: context,
              message: message,
              onRetry: () => context.read<CharactersBloc>().add(
                const CharactersFetchRequested(force: true),
              ),
            ),
          );
    }
  }

  void _onScroll() {
    if (!_isBottom) {
      return;
    }

    context.read<CharactersBloc>().add(const CharactersFetchRequested());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= maxScroll * 0.9;
  }
}
