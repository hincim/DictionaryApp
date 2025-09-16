import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/bloc/history_bloc.dart';
import 'package:deneme/repositories/dictionary_repository.dart';
import 'package:deneme/repositories/local_storage_repository.dart';
import 'package:deneme/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  await LocalStorageRepository.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DictionaryRepository>(
          create: (context) => DictionaryRepository(),
        ),
        RepositoryProvider<LocalStorageRepository>(
          create: (context) => LocalStorageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DictionaryBloc>(
            create: (context) => DictionaryBloc(
              context.read<DictionaryRepository>(),
              context.read<LocalStorageRepository>(),
            ),
          ),
          BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(
              context.read<LocalStorageRepository>(),
            )..add(LoadHistory()), // Load history on start
          ),
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(
              context.read<LocalStorageRepository>(),
            )..add(LoadFavorites()), // Load favorites on start
          ),
        ],
        child: MaterialApp(
          title: 'Sözlük',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            )
          ),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
