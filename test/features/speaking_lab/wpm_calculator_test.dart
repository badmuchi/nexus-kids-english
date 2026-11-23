import 'package:flutter_test/flutter_test.dart';
import 'package:english_for_children/features/speaking_lab/domain/services/wpm_calculator.dart';

void main() {
  const calculator = WpmCalculator();

  group('WpmCalculator Tests', () {
    test('handles zero or negative duration safely', () {
      final res = calculator.calculate(wordsCount: 50, durationSeconds: 0);
      expect(res.wordsPerMinute, 0);
      expect(res.status, WpmPaceStatus.tooSlow);
    });

    test('detects too slow speech pace (< 90 WPM)', () {
      // 50 words in 50 seconds = 60 WPM
      final res = calculator.calculate(wordsCount: 50, durationSeconds: 50);
      expect(res.wordsPerMinute, 60);
      expect(res.status, WpmPaceStatus.tooSlow);
      expect(res.recommendation, contains('медленный'));
    });

    test('detects ideal OGE speech pace (90–130 WPM)', () {
      // 100 words in 55 seconds = 109 WPM
      final res = calculator.calculate(wordsCount: 100, durationSeconds: 55);
      expect(res.wordsPerMinute, 109);
      expect(res.status, WpmPaceStatus.ideal);
      expect(res.recommendation, contains('Идеальный темп'));
    });

    test('detects too fast speech pace (> 130 WPM)', () {
      // 120 words in 40 seconds = 180 WPM
      final res = calculator.calculate(wordsCount: 120, durationSeconds: 40);
      expect(res.wordsPerMinute, 180);
      expect(res.status, WpmPaceStatus.tooFast);
      expect(res.recommendation, contains('слишком высокий'));
    });
  });
}
