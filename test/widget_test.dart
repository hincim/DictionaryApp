// Bu dosya, temel bir Flutter widget testini içerir.
//
// Widget testleri, tek bir widget'ı test etmek için kullanılır. Test ortamında
// widget'ın arayüzünü oluşturur, etkileşime girer (tıklama, kaydırma vb.)
// ve widget ağacındaki değerlerin doğru olup olmadığını kontrol eder.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deneme/main.dart';

void main() {

  // testWidgets, bir widget testi tanımlar.
  testWidgets('Uygulama başlığını doğrula', (WidgetTester tester) async {
    // MyApp widget'ını test ortamında oluşturur ve ilk frame'i çizer.
    await tester.pumpWidget(const MyApp());

    // Ekranda 'Sözlük' metnini içeren bir widget olup olmadığını kontrol eder.
    // Bu test, uygulamanın ana AppBar başlığının doğru ayarlandığını doğrular.
    expect(find.text('Sözlük'), findsOneWidget);
  });

}
