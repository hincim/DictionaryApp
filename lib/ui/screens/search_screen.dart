import 'dart:async';

import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/theme_bloc.dart';
import 'package:deneme/ui/widgets/definition_display.dart';
import 'package:deneme/ui/widgets/definition_skeleton.dart';
import 'package:deneme/ui/widgets/error_display.dart';
import 'package:deneme/ui/widgets/word_of_the_day_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _submitWord(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<DictionaryBloc>().add(SearchWord(_controller.text.trim()));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sözlük'),
        actions: [
          // Tema değiştirme butonu
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                tooltip: 'Temayı Değiştir',
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SEARCH BAR ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Bir kelime arayın...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search, size: 30),
                  onPressed: () => _submitWord(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- RESULTS ---
            Expanded(
              child: BlocBuilder<DictionaryBloc, DictionaryState>(
                builder: (context, state) {
                  if (state is DictionaryInitial) {
                    return const WordOfTheDayCard();
                  }
                  if (state is DictionaryLoading) {
                    return const DefinitionSkeleton(); // Show shimmer effect
                  }
                  if (state is DictionaryError) {
                    return ErrorDisplay(
                      message: state.message,
                      onRetry: () => _submitWord(context),
                    );
                  }
                  if (state is DictionaryLoaded) {
                    return DefinitionDisplay(loadedState: state);
                  }
                  return const SizedBox.shrink(); // Should not happen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}