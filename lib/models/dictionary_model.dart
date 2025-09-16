
import 'package:equatable/equatable.dart';

class WordDefinition extends Equatable {
  final String word;
  final String? phonetic;
  final List<Meaning> meanings;

  const WordDefinition({
    required this.word,
    this.phonetic,
    required this.meanings,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    // The API returns a list, we'll handle the list in the repository
    // This factory expects a single object from that list.
    return WordDefinition(
      word: json['word'] ?? 'No word found',
      phonetic: json['phonetic'],
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((meaningJson) =>
                  Meaning.fromJson(meaningJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [word, phonetic, meanings];
}

class Meaning extends Equatable {
  final String partOfSpeech;
  final List<Definition> definitions;

  const Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((defJson) =>
                  Definition.fromJson(defJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [partOfSpeech, definitions];
}

class Definition extends Equatable {
  final String definition;
  final String? example;

  const Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? 'No definition found',
      example: json['example'],
    );
  }

  @override
  List<Object?> get props => [definition, example];
}

