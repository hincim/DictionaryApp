import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:deneme/main.dart' as app;

// Bu dosya, uygulamanın tam bir entegrasyon (UI veya uçtan uca) testini içerir.
// Test, gerçek bir cihazda veya emülatörde çalışarak kullanıcı arayüzünü kontrol eder.

void main() {
  // Entegrasyon test altyapısını başlatır.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Uçtan uca uygulama testi', () {
    testWidgets('Uygulama başlar ve AppBar başlığını doğrular', (WidgetTester tester) async {
      // Uygulamanın ana fonksiyonunu (main) çalıştırarak uygulamayı başlatır.
      app.main();
      // Tüm animasyonların ve frame'lerin tamamlanmasını bekler.
      await tester.pumpAndSettle();

      // Ekranda 'Sözlük' metnini içeren bir widget (AppBar başlığı) olup olmadığını kontrol eder.
      expect(find.text('Sözlük'), findsOneWidget);
    });
  });
}
