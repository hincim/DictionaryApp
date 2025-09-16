import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/custom_exceptions.dart';
import '../models/dictionary_model.dart';
import '../repositories/dictionary_repository.dart';
import '../repositories/local_storage_repository.dart';

part 'dictionary_event.dart';
part 'dictionary_state.dart';

/// Kullanıcının kelime arama arayüzüyle etkileşimlerini ve state'ini yönetir.
/// [DictionaryRepository] üzerinden API'den kelime verilerini alır ve
/// [LocalStorageRepository] üzerinden arama geçmişine ekler.
class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepository _dictionaryRepository;
  final LocalStorageRepository _localStorageRepository;

  DictionaryBloc(
    this._dictionaryRepository,
    this._localStorageRepository,
  ) : super(DictionaryInitial()) {
    // SearchWord event'i geldiğinde _onSearchWord metodunu tetikler.
    on<SearchWord>(_onSearchWord);
  }

  /// Bir kelime arandığında tetiklenir.
  void _onSearchWord(SearchWord event, Emitter<DictionaryState> emit) async {
    // Arayüzde bir yüklenme göstergesi gösterilmesi için DictionaryLoading state'i emit edilir.
    emit(DictionaryLoading());
    try {
      // Repository üzerinden kelime tanımı alınır.
      final definition = await _dictionaryRepository.getDefinition(event.word);
      // Başarılı sonuç arayüze gönderilir.
      emit(DictionaryLoaded(definition));
      // Başarılı arama sonucunda kelime arama geçmişine eklenir.
      await _localStorageRepository.addWordToHistory(event.word);
    } on DictionaryException catch (e) {
      // API'den veya beklenen bir yerden hata gelirse, aranan kelime yine de geçmişe eklenir.
      await _localStorageRepository.addWordToHistory(event.word);
      // Hata mesajı arayüze gönderilir.
      emit(DictionaryError(e.message));
    } catch (e) {
      // Beklenmedik bir hata oluşursa, genel bir hata mesajı gönderilir.
      emit(const DictionaryError('Beklenmedik bir hata oluştu.'));
    }
  }
}
