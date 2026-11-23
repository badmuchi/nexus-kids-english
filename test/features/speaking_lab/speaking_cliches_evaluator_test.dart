import 'package:flutter_test/flutter_test.dart';
import 'package:english_for_children/features/speaking_lab/domain/services/speaking_cliches_evaluator.dart';

void main() {
  const evaluator = SpeakingClichesEvaluator();

  group('SpeakingClichesEvaluator Tests', () {
    test('returns invalid result for empty monologue', () {
      final res = evaluator.evaluateMonologue('   ');
      expect(res.isPass, isFalse);
      expect(res.hasIntro, isFalse);
      expect(res.hasConclusion, isFalse);
      expect(res.sentenceCount, 0);
    });

    test('flags missing intro and conclusion clichés', () {
      const text =
          'School is great. I like studying physics. It is very useful. My friends also study hard. Every Friday we play football. Our teachers help us. Finally, it makes us confident.';
      final res = evaluator.evaluateMonologue(text);
      expect(res.isPass, isFalse);
      expect(res.hasIntro, isFalse);
      expect(res.hasConclusion, isFalse);
    });

    test('passes valid full monologue with intro, conclusion, linkers, and sentences', () {
      const text = '''
I am going to give a talk about my school. 
Firstly, my weekday starts at 8 in the morning with math and history. 
Secondly, I really enjoy science classes because we do cool lab experiments. 
Furthermore, our school has an excellent sports club where we train. 
In addition, we organize an annual charity fair every spring. 
Besides, my classmates are very friendly and supportive. 
I would like to have more interactive coding workshops in the future. 
School is essential because it prepares adolescents for future careers. 
That is all I wanted to say. Thank you for listening.
''';
      final res = evaluator.evaluateMonologue(text);
      expect(res.isPass, isTrue);
      expect(res.hasIntro, isTrue);
      expect(res.hasConclusion, isTrue);
      expect(res.detectedLinkers.length, greaterThanOrEqualTo(2));
      expect(res.sentenceCount, greaterThanOrEqualTo(8));
      expect(res.feedback, contains('7/7'));
    });

    test('evaluates dialogue answer completeness', () {
      expect(evaluator.isDialogueAnswerComplete('Yes, I do.'), isFalse);
      expect(
        evaluator.isDialogueAnswerComplete(
          'I go to the gym twice a week. We also play football with friends on weekends.',
        ),
        isTrue,
      );
    });
  });
}
