import 'package:deneme/bloc/history_bloc.dart';
import 'package:deneme/ui/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
          ),
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
            return ErrorDisplay(
              message: state.message,
              onRetry: () => context.read<HistoryBloc>().add(LoadHistory()),
            );
          }
          if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final item = state.history[index];

                return Dismissible(
                  key: ValueKey(
                    item.word + item.timestamp.toString(),
                  ), // Unique key
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    // Dispatch event to remove from history
                    context.read<HistoryBloc>().add(
                      RemoveWordFromHistory(item.word),
                    );
                    // Show a confirmation snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${item.word}" geçmişten silindi.'),
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
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(item.timestamp),
                    ),
                    onTap: () {
                      // Kelimeye tıklandığında arama yapmak için ana ekrana bilgi verir.
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
