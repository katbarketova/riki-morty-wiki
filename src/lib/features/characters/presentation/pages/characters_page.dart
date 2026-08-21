import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:riki_morty_wiki/core/di/service_locator.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_event.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_state.dart';
import 'package:riki_morty_wiki/features/characters/presentation/widgets/character_list_item.dart';

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

class CharactersView extends StatefulWidget {
  const CharactersView({super.key});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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
                const Text('Rick and Morty'),
                const SizedBox(width: 12),
                if (state.totalCount > 0)
                  _CharactersCount(totalCount: state.totalCount),
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
              _ErrorView(
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
              itemCount: state.hasReachedMax
                  ? state.characters.length
                  : state.characters.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.characters.length) {
                  if (state.errorMessage != null) {
                    return _LoadMoreError(
                      message: state.errorMessage!,
                      onRetry: () => context.read<CharactersBloc>().add(
                        const CharactersFetchRequested(),
                      ),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return CharacterListItem(character: state.characters[index]);
              },
            ),
          };
        },
      ),
    );
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

class _CharactersCount extends StatelessWidget {
  const _CharactersCount({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Iconify(Mdi.alien, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          '$totalCount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
