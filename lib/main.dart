import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/bloc/history_bloc.dart';
import 'package:deneme/bloc/theme_bloc.dart';
import 'package:deneme/bloc/word_of_the_day_bloc.dart';
import 'package:deneme/repositories/dictionary_repository.dart';
import 'package:deneme/repositories/local_storage_repository.dart';
import 'package:deneme/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

// Uygulamanın ana başlangıç noktası.
void main() async {
  // Flutter binding'lerinin başlatıldığından emin olunur.
  WidgetsFlutterBinding.ensureInitialized();

  // Lokal veritabanı (Hive) başlatılır.
  await Hive.initFlutter();
  await LocalStorageRepository.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiRepositoryProvider, uygulama boyunca erişilebilecek olan
    // repository sınıflarını (veri katmanı) widget ağacına sağlar.
    return MultiRepositoryProvider(
      providers: [
        // Kelime arama API'si ile iletişimi sağlar.
        RepositoryProvider<DictionaryRepository>(
          create: (context) => DictionaryRepository(client: http.Client()),
        ),
        // Cihaz hafızasındaki favori ve geçmiş kelimeleri yönetir.
        RepositoryProvider<LocalStorageRepository>(
          create: (context) => LocalStorageRepository(),
        ),
      ],
      // MultiBlocProvider, state yönetimini yapan BLoC sınıflarını
      // widget ağacına sağlar.
      child: MultiBlocProvider(
        providers: [
          // Tema durumunu yönetir.
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(
              context.read<LocalStorageRepository>(),
            )..add(LoadTheme()), // Kayıtlı temayı yükle.
          ),
          // Günün kelimesini yönetir.
          BlocProvider<WordOfTheDayBloc>(
            create: (context) => WordOfTheDayBloc(
              context.read<DictionaryRepository>(),
            )..add(FetchWordOfTheDay()), // Günün kelimesini yükle.
          ),
          // Kelime arama işleminin state'ini yönetir.
          BlocProvider<DictionaryBloc>(
            create: (context) => DictionaryBloc(
              context.read<DictionaryRepository>(),
              context.read<LocalStorageRepository>(),
            ),
          ),
          // Arama geçmişinin state'ini yönetir.
          BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(
              context.read<LocalStorageRepository>(),
            )..add(LoadHistory()), // Başlangıçta geçmişi yükler.
          ),
          // Favori kelimelerin state'ini yönetir.
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(
              context.read<LocalStorageRepository>(),
            )..add(LoadFavorites()), // Başlangıçta favorileri yükler.
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Sözlük',
              themeMode: themeState.themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal, brightness: Brightness.light),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
// kontrol