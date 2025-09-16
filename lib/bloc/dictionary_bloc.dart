import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/custom_exceptions.dart';
import '../models/dictionary_model.dart';
import '../repositories/dictionary_repository.dart';
import '../repositories/local_storage_repository.dart';

part 'dictionary_event.dart';
part 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository _dictionaryRepository;
  final LocalStorageRepository _localStorageRepository;

  DictionaryBloc(
    this._dictionaryRepository,
    this._localStorageRepository,
  ) : super(DictionaryInitial()) {
    on<SearchWord>(_onSearchWord);
    on<ToggleTranslation>(_onToggleTranslation);
  }

  void _onSearchWord(SearchWord event, Emitter<DictionaryState> emit) async {
    emit(DictionaryLoading());
    try {
      final definition = await _dictionaryRepository.getDefinition(event.word);
      emit(DictionaryLoaded(definition));
      // Also add the word to history on successful search
      await _localStorageRepository.addWordToHistory(event.word);
    } on DictionaryException catch (e) {
      emit(DictionaryError(e.message));
    } catch (e) {
      // For any other unexpected errors
      emit(const DictionaryError('Beklenmedik bir hata oluştu.'));
    }
  }

  void _onToggleTranslation(
      ToggleTranslation event, Emitter<DictionaryState> emit) async {
    final currentState = state;
    if (currentState is DictionaryLoaded) {
      // If translation already exists, just toggle the view
      if (currentState.translatedDefinition != null) {
        emit(currentState.copyWith(isTranslated: !currentState.isTranslated));
        return;
      }

      // If translating for the first time
      try {
        // No separate loading state to avoid UI jump, translation is fast
        final translatedDefinition = await _dictionaryRepository
            .translateDefinition(currentState.definition);
        emit(currentState.copyWith(
          translatedDefinition: translatedDefinition,
          isTranslated: true,
        ));
      } on DictionaryException catch (e) {
        emit(DictionaryError(e.message));
      } catch (e) {
        emit(const DictionaryError('Çeviri sırasında beklenmedik bir hata oluştu.'));
      }
    }
    // If the state is not DictionaryLoaded, do nothing.
  }
}