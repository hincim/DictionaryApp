import 'dart:convert';
import 'dart:io';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import '../models/custom_exceptions.dart';
import '../models/dictionary_model.dart';

class DictionaryRepository {
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  final _translator = GoogleTranslator();

  Future<WordDefinition> getDefinition(String word) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$word'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return WordDefinition.fromJson(data[0]);
        } else {
          throw DictionaryException('Bu kelime için bir tanım bulunamadı.');
        }
      } else if (response.statusCode == 404) {
        throw DictionaryException('Aradığınız kelime sözlükte bulunamadı.');
      } else {
        throw DictionaryException(
            'Servis hatası: ${response.statusCode}. Lütfen daha sonra tekrar deneyin.');
      }
    } on SocketException {
      throw DictionaryException(
          'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.');
    } catch (e) {
      if (e is DictionaryException) {
        rethrow;
      }
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
