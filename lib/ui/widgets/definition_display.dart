import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/models/dictionary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefinitionDisplay extends StatelessWidget {
  final DictionaryLoaded loadedState;

  const DefinitionDisplay({super.key, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Determine which definition to display based on the translation state
    final definition = loadedState.isTranslated
        ? loadedState.translatedDefinition!
        : loadedState.definition;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER: WORD, PHONETIC, ACTION BUTTONS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(definition.word,
                            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        if (definition.phonetic != null)
                          Text(
                            definition.phonetic!,
                            style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                          ),
                      ],
                    ),
                  ),
                  // --- ACTION BUTTONS ---
                  Row(
                    children: [
                      // Favorite Button
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          bool isFavorite = false;
                          if (state is FavoritesLoaded) {
                            // Use the original word for checking favorite status
                            isFavorite = state.favoriteWords.contains(loadedState.definition.word);
                          }
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () {
                              context.read<FavoritesBloc>().add(ToggleFavorite(loadedState.definition.word));
                            },
                          );
                        },
                      ),
                      // Translate Button
                      IconButton(
                        icon: Icon(
                          Icons.translate,
                          color: loadedState.isTranslated
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () {
                          context.read<DictionaryBloc>().add(const ToggleTranslation());
                        },
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // --- MEANINGS ---
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: definition.meanings.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final meaning = definition.meanings[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Part of Speech
                      Chip(
                        label: Text(meaning.partOfSpeech),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      const SizedBox(height: 12),

                      // Definitions
                      ...meaning.definitions.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Definition def = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${idx + 1}. ',
                                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(def.definition, style: textTheme.bodyLarge),
                                    if (def.example != null && def.example!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '"${def.example!}"',
                                          style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}