import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:deneme/models/hive_models.dart';
import 'package:deneme/repositories/local_storage_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final LocalStorageRepository _localStorageRepository;

  FavoritesBloc(this._localStorageRepository) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoading());
    _emitCurrentFavorites(emit);
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<FavoritesState> emit) async {
    await _localStorageRepository.toggleFavorite(event.word);
    _emitCurrentFavorites(emit);
  }

  void _emitCurrentFavorites(Emitter<FavoritesState> emit) {
    try {
      final favorites = _localStorageRepository.getFavorites();
      if (favorites.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        final favoriteWords = favorites.map((e) => e.word).toSet();
        emit(FavoritesLoaded(favorites, favoriteWords));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
