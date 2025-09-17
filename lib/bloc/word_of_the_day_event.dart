part of 'word_of_the_day_bloc.dart';

abstract class WordOfTheDayEvent extends Equatable {
  const WordOfTheDayEvent();

  @override
  List<Object> get props => [];
}

class FetchWordOfTheDay extends WordOfTheDayEvent {}
