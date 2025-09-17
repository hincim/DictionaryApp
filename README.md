# Sözlük Uygulaması

Bu proje, Flutter ile geliştirilmiş basit bir İngilizce sözlük uygulamasıdır. Kullanıcıların kelime aramasına, arama geçmişini görüntülemesine ve favori kelimelerini kaydetmesine olanak tanır.

## 📚 Özellikler

- **Kelime Arama:** `dictionaryapi.dev` API'sini kullanarak İngilizce kelimelerin anlamlarını, fonetik okunuşlarını ve kullanım örneklerini arama.
- **Arama Geçmişi:** Yapılan tüm kelime aramalarının bir listesini tutar.
- **Geçmiş Yönetimi:**
    - Tüm arama geçmişini tek seferde temizleme.
    - Geçmişteki her bir kelimeyi tek tek silebilme.
- **Favoriler:** Beğenilen kelimeleri favori listesine ekleme ve listeden çıkarma.
- **Detaylı Görünüm:** Kelimelerin farklı anlamlarını ve telaffuzlarını gösteren detaylı bir arayüz.

## 🏗️ Teknik Yapı ve Mimarisi

Bu proje, modern ve ölçeklenebilir bir Flutter uygulaması geliştirmek için standart pratikler kullanılarak oluşturulmuştur.

- **Framework:** Flutter
- **State Management:** BLoC (Business Logic Component) - `flutter_bloc` paketi kullanılarak uygulama durumu (state) ve iş mantığı arayüzden ayrılmıştır.
- **Mimari Desen:** Repository Pattern - Veri kaynakları (API, lokal veritabanı) ile iş mantığı arasına bir soyutlama katmanı eklenmiştir.
  - `DictionaryRepository`: Uzak API ile iletişimi yönetir.
  - `LocalStorageRepository`: Cihaz hafızası ile (geçmiş ve favoriler) iletişimi yönetir.
- **API İletişimi:** `http` paketi ile REST API istekleri yapılır.
- **Lokal Depolama:** `hive` paketi ile arama geçmişi ve favori kelimeler cihazda kalıcı olarak saklanır.
- **Testler:** Uygulamanın kararlılığını sağlamak için çeşitli testler yazılmıştır:
  - **Birim Testleri (Unit Tests):** Repository ve BLoC sınıflarının mantığını doğrulamak için.
  - **Widget Testleri (Widget Tests):** Arayüz bileşenlerinin doğru şekilde oluşturulduğunu kontrol etmek için.
  - **Entegrasyon Testleri (Integration Tests):** Uygulamanın uçtan uca akışını test etmek için.

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versiyon 3.x veya üstü)

### Adımlar
1.  **Projeyi Klonlayın:**
    ```bash
    git clone <proje-linki>
    cd <proje-dizini>
    ```

2.  **Bağımlılıkları Yükleyin:**
    Proje için gerekli olan tüm paketleri yüklemek için terminalde aşağıdaki komutu çalıştırın:
    ```bash
    flutter pub get
    ```

3.  **Uygulamayı Çalıştırın:**
    Bir emülatör veya fiziksel bir cihazda uygulamayı başlatmak için aşağıdaki komutu kullanın:
    ```bash
    flutter run
    ```

## 🧪 Testler

Projedeki testleri çalıştırmak için aşağıdaki komutları kullanabilirsiniz.

> **Not:** Bu komutların çalışması için `flutter` komutunun sisteminizin `PATH` ortam değişkenine ekli olması gerekmektedir.

- **Tüm Birim ve Widget Testlerini Çalıştırma:**
  ```bash
  flutter test
  ```

- **Entegrasyon (UI) Testlerini Çalıştırma:**
  Bu komut, bir emülatör veya cihazın bağlı olmasını gerektirir.
  ```bash
  flutter test integration_test
  ```