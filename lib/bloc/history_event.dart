part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

/// Hafızadaki geçmişi yüklemek için event.
class LoadHistory extends HistoryEvent {}

/// Tüm geçmişi temizlemek için event.
class ClearHistory extends HistoryEvent {}

/// Geçmişten tek bir kelimeyi silmek için event.
class RemoveWordFromHistory extends HistoryEvent {
  final String word;

  const RemoveWordFromHistory(this.word);

  @override
  List<Object> get props => [word];
}

