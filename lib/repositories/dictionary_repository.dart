import 'dart:convert';
import 'dart:io';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import '../models/custom_exceptions.dart';
import '../models/dictionary_model.dart';

/// Bu sınıf, kelime sözlüğü API'si ile olan tüm iletişimi yönetir.
/// Uygulamanın veri katmanının bir parçasıdır.
class DictionaryRepository {
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  final http.Client client;
  final GoogleTranslator _translator = GoogleTranslator();

  /// Bir [http.Client] alarak veya varsayılan bir istemci oluşturarak başlatılır.
  /// Bu yapı, test sırasında sahte (mock) bir istemci enjekte etmeyi kolaylaştırır.
  DictionaryRepository({http.Client? client})
      : client = client ?? http.Client();

  /// Verilen bir [word] için API'den kelime tanımını alır.
  ///
  /// Başarılı olursa bir [WordDefinition] nesnesi döndürür.
  /// Hata durumlarında (örn: kelime bulunamadı, internet yok) [DictionaryException] fırlatır.
  Future<WordDefinition> getDefinition(String word) async {
    try {
      final response = await client.get(Uri.parse('$_baseUrl$word'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          // API'den gelen JSON yanıtını WordDefinition modeline dönüştürür.
          return WordDefinition.fromJson(data[0]);
        } else {
          throw DictionaryException('Bu kelime için bir tanım bulunamadı.');
        }
      } else if (response.statusCode == 404) {
        // Kelime bulunamadığında fırlatılan özel hata.
        throw DictionaryException('Aradığınız kelime sözlükte bulunamadı.');
      } else {
        throw DictionaryException(
            'Servis hatası: ${response.statusCode}. Lütfen daha sonra tekrar deneyin.');
      }
    } on SocketException {
      throw DictionaryException(
          'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.');
    } catch (e) {
      // Zaten bilinen bir hata türü değilse, yeniden fırlat.
      if (e is DictionaryException) {
        rethrow;
      }
      // Beklenmedik diğer tüm hatalar için genel bir hata fırlat.
      throw DictionaryException('Beklenmedik bir hata oluştu.');
    }
  }

  Future<WordDefinition> translateDefinition(WordDefinition definition) async {
    try {
      // Translate the word itself
      final translatedWord =
          await _translator.translate(definition.word, from: 'en', to: 'tr');

      final translatedMeanings = <Meaning>[];
      for (final meaning in definition.meanings) {
        final translatedPartOfSpeech = await _translator
            .translate(meaning.partOfSpeech, from: 'en', to: 'tr');

        final translatedDefinitions = <Definition>[];
        for (final def in meaning.definitions) {
          final translatedDef =
              await _translator.translate(def.definition, from: 'en', to: 'tr');
          final translatedEx = def.example != null
              ? await _translator.translate(def.example!, from: 'en', to: 'tr')
              : null;

          translatedDefinitions.add(Definition(
            definition: translatedDef.text,
            example: translatedEx?.text,
          ));
        }
        translatedMeanings.add(Meaning(
          partOfSpeech: translatedPartOfSpeech.text,
          definitions: translatedDefinitions,
        ));
      }

      return WordDefinition(
        word: translatedWord.text, // Use the translated word
        phonetic: definition.phonetic, // Keep original phonetic
        meanings: translatedMeanings,
      );
    } catch (e) {
      // Rethrow as a dictionary exception to be handled by the BLoC
      throw DictionaryException('Çeviri sırasında bir hata oluştu.');
    }
  }
}
