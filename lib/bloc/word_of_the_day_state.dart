part of 'word_of_the_day_bloc.dart';

abstract class WordOfTheDayState extends Equatable {
  const WordOfTheDayState();

  @override
  List<Object> get props => [];
}

class WordOfTheDayInitial extends WordOfTheDayState {}

class WordOfTheDayLoading extends WordOfTheDayState {}

class WordOfTheDayLoaded extends WordOfTheDayState {
  final WordDefinition definition;

  const WordOfTheDayLoaded(this.definition);

  @override
  List<Object> get props => [definition];
}

class WordOfTheDayError extends WordOfTheDayState {
  final String message;

  const WordOfTheDayError(this.message);

  @override
  List<Object> get props => [message];
}
