part of 'dictionary_bloc.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryLoaded extends DictionaryState {
  final WordDefinition definition;

  const DictionaryLoaded(this.definition);

  @override
  List<Object> get props => [definition];
}

class DictionaryError extends DictionaryState {
  final String message;

  const DictionaryError(this.message);

  @override
  List<Object> get props => [message];
}
