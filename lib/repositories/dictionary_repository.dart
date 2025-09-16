import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/custom_exceptions.dart';
import '../models/dictionary_model.dart';

class DictionaryRepository {
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

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
        throw DictionaryException('Servis hatası: ${response.statusCode}. Lütfen daha sonra tekrar deneyin.');
      }
    } on SocketException {
      throw DictionaryException('İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.');
    } catch (e) {
      if (e is DictionaryException) {
        rethrow;
      }
      throw DictionaryException('Beklenmedik bir hata oluştu.');
    }
  }
}
