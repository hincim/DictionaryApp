part of 'dictionary_bloc.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object?> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryLoaded extends DictionaryState {
  final WordDefinition definition;
  final WordDefinition? translatedDefinition;
  final bool isTranslated;

  const DictionaryLoaded(
    this.definition, {
    this.translatedDefinition,
    this.isTranslated = false,
  });

  @override
  List<Object?> get props => [definition, translatedDefinition, isTranslated];

  DictionaryLoaded copyWith({
    WordDefinition? definition,
    WordDefinition? translatedDefinition,
    bool? isTranslated,
  }) {
    return DictionaryLoaded(
      definition ?? this.definition,
      translatedDefinition: translatedDefinition ?? this.translatedDefinition,
      isTranslated: isTranslated ?? this.isTranslated,
    );
  }
}

class DictionaryError extends DictionaryState {
  final String message;

  const DictionaryError(this.message);

  @override
  List<Object> get props => [message];
}