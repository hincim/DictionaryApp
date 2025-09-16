import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  final ValueChanged<String> onWordTapped;

  const HistoryScreen({super.key, required this.onWordTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama Geçmişi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Geçmişi Temizle',
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistory());
            },
          )
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryEmpty) {
            return const Center(
              child: Text(
                'Arama geçmişiniz boş.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          if (state is HistoryError) {
            return Center(
              child: Text(
                'Hata: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final item = state.history[index];
                return ListTile(
                  title: Text(item.word),
                  subtitle: Text(item.timestamp.toString().substring(0, 16)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    tooltip: 'Geçmişten Sil',
                    onPressed: () {
                      // Tek bir kelimeyi silmek için BLoC'a event gönderir.
                      context.read<HistoryBloc>().add(RemoveWordFromHistory(item.word));
                    },
                  ),
                  onTap: () {
                    // Kelimeye tıklandığında arama yapmak için ana ekrana bilgi verir.
                    onWordTapped(item.word);
                  },
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
