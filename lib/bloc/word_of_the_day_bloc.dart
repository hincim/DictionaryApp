import 'package:bloc/bloc.dart';
import 'package:deneme/models/custom_exceptions.dart';
import 'package:deneme/repositories/dictionary_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:deneme/models/dictionary_model.dart';

part 'word_of_the_day_event.dart';
part 'word_of_the_day_state.dart';

class WordOfTheDayBloc extends Bloc<WordOfTheDayEvent, WordOfTheDayState> {
  final DictionaryRepository _dictionaryRepository;

  WordOfTheDayBloc(this._dictionaryRepository) : super(WordOfTheDayInitial()) {
    on<FetchWordOfTheDay>(_onFetchWordOfTheDay);
  }

  // A predefined list of words for the "Word of the Day" feature.
  final _wordList = [
    'ephemeral', 'ubiquitous', 'mellifluous', 'serendipity', 'petrichor',
    'sonder', 'defenestration', 'ineffable', 'limerence', 'eloquence',
    'aurora', 'chroma', 'solitude', 'cynosure', 'eunoia',
  ];

  Future<void> _onFetchWordOfTheDay(
    FetchWordOfTheDay event,
    Emitter<WordOfTheDayState> emit,
  ) async {
    emit(WordOfTheDayLoading());
    try {
      // Select a word based on the day of the year to ensure it's consistent for the whole day.
      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final word = _wordList[dayOfYear % _wordList.length];

      final definition = await _dictionaryRepository.getDefinition(word);
      emit(WordOfTheDayLoaded(definition));
    } on DictionaryException catch (e) {
      emit(WordOfTheDayError(e.message));
    } catch (e) {
      emit(const WordOfTheDayError('Günün kelimesi yüklenirken beklenmedik bir hata oluştu.'));
    }
  }
}
