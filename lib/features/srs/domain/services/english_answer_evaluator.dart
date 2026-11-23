import 'package:equatable/equatable.dart';

enum EvaluationStatus {
  exactMatch,
  almostCorrect,
  incorrect,
}

class EvaluationResult extends Equatable {
  final EvaluationStatus status;
  final String typed;
  final String expected;
  final int levenshteinDistance;
  final String? feedbackMessage;

  const EvaluationResult({
    required this.status,
    required this.typed,
    required this.expected,
    required this.levenshteinDistance,
    this.feedbackMessage,
  });

  bool get isAccepted => status == EvaluationStatus.exactMatch || status == EvaluationStatus.almostCorrect;

  @override
  List<Object?> get props => [status, typed, expected, levenshteinDistance, feedbackMessage];
}

class EnglishAnswerEvaluator {
  const EnglishAnswerEvaluator();

  static const Map<String, String> _contractionsMap = {
    "don't": "do not",
    "doesn't": "does not",
    "didn't": "did not",
    "i'm": "i am",
    "you're": "you are",
    "we're": "we are",
    "they're": "they are",
    "he's": "he is",
    "she's": "she is",
    "it's": "it is",
    "that's": "that is",
    "what's": "what is",
    "there's": "there is",
    "can't": "cannot",
    "won't": "will not",
    "isn't": "is not",
    "aren't": "are not",
    "wasn't": "was not",
    "weren't": "were not",
    "haven't": "have not",
    "hasn't": "has not",
    "hadn't": "had not",
    "i've": "i have",
    "you've": "you have",
    "we've": "we have",
    "they've": "they have",
    "i'll": "i will",
    "you'll": "you will",
    "he'll": "he will",
    "she'll": "she will",
    "we'll": "we will",
    "they'll": "they will",
    "i'd": "i would",
    "you'd": "you would",
    "he'd": "he would",
    "she'd": "she would",
    "we'd": "we would",
    "they'd": "they would",
  };

  String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var text = input
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('`', "'")
        .toLowerCase()
        .trim();

    final words = text.split(RegExp(r'\s+'));
    final expandedWords = words.map((w) {
      final cleanWord = w.replaceAll(RegExp(r'^[^\w\x27]+|[^\w\x27]+$'), '');
      return _contractionsMap[cleanWord] ?? cleanWord;
    });

    text = expandedWords.join(' ');
    text = text.replaceAll(RegExp(r'[.,!?;:"()\[\]{}]'), '').trim();
    return text.replaceAll(RegExp(r'\s+'), ' ');
  }

  EvaluationResult evaluate({
    required String typed,
    required String expected,
  }) {
    final normTyped = normalize(typed);
    final normExpected = normalize(expected);

    if (normTyped.isEmpty) {
      return EvaluationResult(
        status: EvaluationStatus.incorrect,
        typed: typed,
        expected: expected,
        levenshteinDistance: normExpected.length,
        feedbackMessage: 'Ответ пустой',
      );
    }

    if (normTyped == normExpected) {
      return EvaluationResult(
        status: EvaluationStatus.exactMatch,
        typed: normTyped,
        expected: normExpected,
        levenshteinDistance: 0,
        feedbackMessage: 'Идеально! Точное совпадение.',
      );
    }

    final distance = _calculateLevenshteinDistance(normTyped, normExpected);

    if (distance == 1 && normExpected.length > 4) {
      return EvaluationResult(
        status: EvaluationStatus.almostCorrect,
        typed: normTyped,
        expected: normExpected,
        levenshteinDistance: distance,
        feedbackMessage: 'Почти верно! Допущена мелкая опечатка.',
      );
    }

    return EvaluationResult(
      status: EvaluationStatus.incorrect,
      typed: normTyped,
      expected: normExpected,
      levenshteinDistance: distance,
      feedbackMessage: 'Неверно. Правильный ответ: $expected',
    );
  }

  int _calculateLevenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    final List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < s2.length; j++) {
        final int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = [
          v1[j] + 1,
          v0[j + 1] + 1,
          v0[j] + cost
        ].reduce((min, val) => val < min ? val : min);
      }

      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[s2.length];
  }
}
