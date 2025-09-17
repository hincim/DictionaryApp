import 'dart:convert';
import 'dart:io';

import 'package:deneme/models/custom_exceptions.dart';
import 'package:deneme/models/dictionary_model.dart';
import 'package:deneme/repositories/dictionary_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Bu dosya, DictionaryRepository sınıfı için birim testlerini (unit tests) içerir.
// Bu testler, repository'nin API'den gelen farklı yanıtlara karşı doğru davranıp
// davranmadığını doğrular. Gerçek ağ istekleri yapılmaz.

void main() {
  group('DictionaryRepository Birim Testleri', () {
    late DictionaryRepository dictionaryRepository;

    // Başarılı bir API yanıtını simüle eden sahte JSON verisi.
    final successJson = json.encode([
      {
        "word": "hello",
        "phonetics": [
          {"text": "/həˈloʊ/", "audio": "url"}
        ],
        "meanings": [
          {
            "partOfSpeech": "exclamation",
            "definitions": [
              {"definition": "Used as a greeting or to begin a phone conversation."}
            ]
          }
        ]
      }
    ]);

    test('Başarılı API yanıtında (200) WordDefinition döndürmeli', () async {
      // http/testing paketinden gelen MockClient, sahte HTTP yanıtları oluşturur.
      // Bu istemci, yapılan isteğe karşılık her zaman 200 status kodu ve successJson verisini döndürür.
      final mockClient = MockClient((request) async {
        return http.Response(successJson, 200, headers: {'content-type': 'application/json'});
      });
      dictionaryRepository = DictionaryRepository(client: mockClient);

      final result = await dictionaryRepository.getDefinition('hello');

      // Sonucun beklenen türde (WordDefinition) olduğunu ve doğru veriyi içerdiğini doğrula.
      expect(result, isA<WordDefinition>());
      expect(result.word, 'hello');
    });

    test('Bulunamadı yanıtında (404) DictionaryException fırlatmalı', () async {
      // Bu sahte istemci, her zaman 404 Not Found yanıtı döndürür.
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      dictionaryRepository = DictionaryRepository(client: mockClient);

      // getDefinition metodunun DictionaryException fırlattığını doğrula.
      expect(
        () => dictionaryRepository.getDefinition('nonexistent'),
        throwsA(isA<DictionaryException>()),
      );
    });

    test('Sunucu hatası yanıtında (500) DictionaryException fırlatmalı', () async {
      // Bu sahte istemci, her zaman 500 Internal Server Error yanıtı döndürür.
       final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });
      dictionaryRepository = DictionaryRepository(client: mockClient);

      // getDefinition metodunun DictionaryException fırlattığını doğrula.
      expect(
        () => dictionaryRepository.getDefinition('any'),
        throwsA(isA<DictionaryException>()),
      );
    });

    test('İnternet bağlantısı olmadığında (SocketException) DictionaryException fırlatmalı', () async {
      // Bu sahte istemci, bir ağ isteği yapıldığında SocketException fırlatır.
      final mockClient = MockClient((request) async {
        throw const SocketException('No Internet');
      });
      dictionaryRepository = DictionaryRepository(client: mockClient);

      // getDefinition metodunun DictionaryException fırlattığını doğrula.
      expect(
        () => dictionaryRepository.getDefinition('any'),
        throwsA(isA<DictionaryException>()),
      );
    });
  });
}
