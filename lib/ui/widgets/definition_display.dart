import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/models/dictionary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefinitionDisplay extends StatefulWidget {
  final WordDefinition definition;

  const DefinitionDisplay({super.key, required this.definition});

  @override
  State<DefinitionDisplay> createState() => _DefinitionDisplayState();
}

class _DefinitionDisplayState extends State<DefinitionDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DefinitionDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the word changes, restart the animation
    if (oldWidget.definition.word != widget.definition.word) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER: WORD, PHONETIC, FAVORITE BUTTON ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.definition.word, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                            if (widget.definition.phonetic != null)
                              Text(
                                widget.definition.phonetic!,
                                style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                              ),
                          ],
                        ),
                      ),
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          bool isFavorite = false;
                          if (state is FavoritesLoaded) {
                            isFavorite = state.favoriteWords.contains(widget.definition.word);
                          }
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () {
                              context.read<FavoritesBloc>().add(ToggleFavorite(widget.definition.word));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- MEANINGS ---
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.definition.meanings.length,
                    separatorBuilder: (context, index) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final meaning = widget.definition.meanings[index];
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
        ),
      ),
    );
  }
}

