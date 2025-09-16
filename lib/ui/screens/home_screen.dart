import 'package:deneme/bloc/dictionary_bloc.dart';
import 'package:deneme/bloc/favorites_bloc.dart';
import 'package:deneme/bloc/history_bloc.dart';
import 'package:deneme/ui/screens/favorites_screen.dart';
import 'package:deneme/ui/screens/history_screen.dart';
import 'package:deneme/ui/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const SearchScreen(),
      HistoryScreen(onWordTapped: _handleWordTappedFromChild),
      FavoritesScreen(onWordTapped: _handleWordTappedFromChild),
    ];
  }

  void _handleWordTappedFromChild(String word) {
    // First, trigger the search for the given word
    context.read<DictionaryBloc>().add(SearchWord(word));
    // Then, switch to the search tab
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    // Refresh data when the user manually navigates to the history or favorites tab.
    if (index == 1) {
      context.read<HistoryBloc>().add(LoadHistory());
    } else if (index == 2) {
      context.read<FavoritesBloc>().add(LoadFavorites());
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
