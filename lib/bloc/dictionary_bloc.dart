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
}
