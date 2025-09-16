import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_models.dart';

class LocalStorageRepository {
  static const String _historyBoxName = 'history';
  static const String _favoritesBoxName = 'favorites';

  // --- Box Getters ---
  Box<HistoryItem> get _historyBox => Hive.box<HistoryItem>(_historyBoxName);
  Box<FavoriteItem> get _favoritesBox => Hive.box<FavoriteItem>(_favoritesBoxName);

  // --- Initialization ---
  static Future<void> init() async {
    // Register Adapters
    Hive.registerAdapter(HistoryItemAdapter());
    Hive.registerAdapter(FavoriteItemAdapter());

    // Open Boxes
    await Hive.openBox<HistoryItem>(_historyBoxName);
    await Hive.openBox<FavoriteItem>(_favoritesBoxName);
  }

  // --- History Methods ---
  Future<void> addWordToHistory(String word) async {
    // Avoid duplicates, or update timestamp by removing and re-adding
    final existingIndex = _historyBox.values.toList().indexWhere((item) => item.word == word);
    if (existingIndex != -1) {
      await _historyBox.deleteAt(existingIndex);
    }

    final item = HistoryItem(word: word, timestamp: DateTime.now());
    await _historyBox.add(item);
  }

  List<HistoryItem> getHistory() {
    // Return in reverse chronological order (newest first)
    return _historyBox.values.toList().reversed.toList();
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  // --- Favorites Methods ---
  bool isFavorite(String word) {
    return _favoritesBox.values.any((item) => item.word == word);
  }

  Future<void> toggleFavorite(String word) async {
    if (isFavorite(word)) {
      final itemKey = _favoritesBox.keys.firstWhere(
        (key) => _favoritesBox.get(key)!.word == word,
      );
      await _favoritesBox.delete(itemKey);
    } else {
      final item = FavoriteItem(word: word);
      await _favoritesBox.add(item);
    }
  }

  List<FavoriteItem> getFavorites() {
    return _favoritesBox.values.toList();
  }
}
