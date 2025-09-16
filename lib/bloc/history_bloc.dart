import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:deneme/models/hive_models.dart';
import 'package:deneme/repositories/local_storage_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final LocalStorageRepository _localStorageRepository;

  HistoryBloc(this._localStorageRepository) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<ClearHistory>(_onClearHistory);
  }

  void _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) {
    emit(HistoryLoading());
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

  void _onClearHistory(ClearHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      await _localStorageRepository.clearHistory();
      emit(HistoryEmpty());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
