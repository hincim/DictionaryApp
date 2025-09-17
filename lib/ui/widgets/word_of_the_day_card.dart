import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/word_of_the_day_bloc.dart';
import 'package:deneme/ui/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordOfTheDayCard extends StatelessWidget {
  const WordOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<WordOfTheDayBloc, WordOfTheDayState>(
      builder: (context, state) {
        if (state is WordOfTheDayLoading || state is WordOfTheDayInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WordOfTheDayError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () => context.read<WordOfTheDayBloc>().add(FetchWordOfTheDay()),
          );
        }
        if (state is WordOfTheDayLoaded) {
          final definition = state.definition;
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Günün Kelimesi',
                    style: textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    definition.word,
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (definition.phonetic != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        definition.phonetic!,
                        style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                  const Divider(height: 24),
                  Text(
                    definition.meanings.first.definitions.first.definition,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text('Tamamını Gör →'),
                      onPressed: () {
                        context.read<DictionaryBloc>().add(SearchWord(definition.word));
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
