import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:deneme/models/hive_models.dart';
import 'package:deneme/repositories/local_storage_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

/// Arama geçmişinin state'ini yönetir.
/// [LocalStorageRepository] üzerinden arama geçmişini okur ve temizler.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final LocalStorageRepository _localStorageRepository;

  HistoryBloc(this._localStorageRepository) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<ClearHistory>(_onClearHistory);
    on<RemoveWordFromHistory>(_onRemoveWordFromHistory);
  }

  /// Cihaz hafızasındaki arama geçmişini yükler ve state'i günceller.
  void _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) {
    emit(HistoryLoading());
    _emitCurrentHistory(emit);
  }

  /// Cihaz hafızasındaki tüm arama geçmişini temizler.
  void _onClearHistory(ClearHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      await _localStorageRepository.clearHistory();
      emit(HistoryEmpty());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  /// Geçmişten tek bir kelimeyi siler.
  Future<void> _onRemoveWordFromHistory(RemoveWordFromHistory event, Emitter<HistoryState> emit) async {
    try {
      await _localStorageRepository.removeWordFromHistory(event.word);
      // Silme sonrası güncel listeyi tekrar emit et.
      _emitCurrentHistory(emit);
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  /// Depodaki mevcut geçmişi okur ve ilgili state'i emit eder.
  void _emitCurrentHistory(Emitter<HistoryState> emit) {
    try {
      final history = _localStorageRepository.getHistory();
      if (history.isEmpty) {
        emit(HistoryEmpty());
      } else {
        emit(HistoryLoaded(history));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
