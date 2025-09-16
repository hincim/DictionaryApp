import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/models/dictionary_model.dart';
import 'package:deneme/ui/widgets/definition_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

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
                    decoration: InputDecoration(
                      hintText: "Bir kelime arayın...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _submitWord(context),
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
                    return const Center(
                      child: Text(
                        'Yukarıdan bir kelime arayarak başlayın.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  if (state is DictionaryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DictionaryError) {
                    return Center(
                      child: Text(
                        'Hata: ${state.message}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
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
    super.dispose();
  }
}