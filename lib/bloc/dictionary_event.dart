part of 'dictionary_bloc.dart';

abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class SearchWord extends DictionaryEvent {
  final String word;

  const SearchWord(this.word);

  @override
  List<Object> get props => [word];
}

class ToggleTranslation extends DictionaryEvent {
  const ToggleTranslation();
}