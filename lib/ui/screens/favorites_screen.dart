import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/ui/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  final ValueChanged<String> onWordTapped;

  const FavoritesScreen({super.key, required this.onWordTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Kelimeler'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoritesEmpty) {
            return const Center(
              child: Text(
                'Henüz favori kelimeniz yok.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          if (state is FavoritesError) {
            return ErrorDisplay(
              message: state.message,
              onRetry: () => context.read<FavoritesBloc>().add(LoadFavorites()),
            );
          }
          if (state is FavoritesLoaded) {
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final item = state.favorites[index];
                return Dismissible(
                  key: Key(item.word), // Unique key for the item
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    context.read<FavoritesBloc>().add(ToggleFavorite(item.word));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${item.word}" favorilerden kaldırıldı.'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(item.word),
                    onTap: () {
                      // Notify the parent (HomeScreen) to handle the search and navigation
                      onWordTapped(item.word);
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
