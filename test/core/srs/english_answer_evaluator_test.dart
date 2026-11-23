import 'package:flutter_test/flutter_test.dart';
import 'package:english_for_children/features/srs/domain/services/english_answer_evaluator.dart';

void main() {
  group('EnglishAnswerEvaluator Tests', () {
    const evaluator = EnglishAnswerEvaluator();

    test('exact matches are recognized as exactMatch', () {
      final res = evaluator.evaluate(typed: 'environment', expected: 'environment');
      expect(res.status, EvaluationStatus.exactMatch);
      expect(res.isAccepted, isTrue);
      expect(res.levenshteinDistance, 0);
    });

    test('case and extra whitespace are normalized', () {
      final res = evaluator.evaluate(typed: '  EnViRoNmEnT  ', expected: 'environment');
      expect(res.status, EvaluationStatus.exactMatch);
      expect(res.isAccepted, isTrue);
    });

    test('curved apostrophes and contractions are recognized as equivalent', () {
      // "don’t" -> "do not"
      final res = evaluator.evaluate(typed: "don’t know", expected: "do not know");
      expect(res.status, EvaluationStatus.exactMatch);
      expect(res.isAccepted, isTrue);

      // "I'm" -> "i am"
      final res2 = evaluator.evaluate(typed: "I'm ready", expected: "I am ready");
      expect(res2.status, EvaluationStatus.exactMatch);
      expect(res2.isAccepted, isTrue);
    });

    test('allows 1 typo for words longer than 4 chars (almostCorrect)', () {
      // environmetn (1 typo)
      final res = evaluator.evaluate(typed: 'environmnt', expected: 'environment');
      expect(res.status, EvaluationStatus.almostCorrect);
      expect(res.isAccepted, isTrue);
      expect(res.levenshteinDistance, 1);
    });

    test('rejects completely wrong answers', () {
      final res = evaluator.evaluate(typed: 'apple', expected: 'environment');
      expect(res.status, EvaluationStatus.incorrect);
      expect(res.isAccepted, isFalse);
    });
  });
}
