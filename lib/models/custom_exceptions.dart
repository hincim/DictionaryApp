class DictionaryException implements Exception {
  final String message;

  DictionaryException(this.message);

  @override
  String toString() => message;
}
