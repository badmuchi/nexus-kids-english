import 'package:flutter_test/flutter_test.dart';
import 'package:english_for_children/features/ib_myp/domain/services/cohesive_devices_analyzer.dart';

void main() {
  group('CohesiveDevicesAnalyzer Tests', () {
    const analyzer = CohesiveDevicesAnalyzer();

    test('analyzes empty text gracefully', () {
      final res = analyzer.analyze('');
      expect(res.wordCount, 0);
      expect(res.cohesionScoreOutOf8, 0);
      expect(res.suggestions, isNotEmpty);
    });

    test('identifies multiple categories of cohesive devices', () {
      const sampleEssay = '''
To begin with, technological devices are shaping modern adolescence.
Furthermore, they facilitate cross-cultural communication and research.
However, excessive screen usage might negatively affect deep sleep cycles.
Consequently, teenagers must develop mindful digital habits.
In conclusion, balance between screen time and real-world relationships is essential.
''';

      final res = analyzer.analyze(sampleEssay);
      expect(res.wordCount, greaterThan(40));
      expect(res.paragraphCount, 5);
      expect(res.foundDevices, isNotEmpty);
      expect(res.uniqueCategoriesCount, 5); // Sequencing, Addition, Contrast, CauseEffect, Conclusion
      expect(res.cohesionScoreOutOf8, greaterThanOrEqualTo(6.0));
    });

    test('generates helpful suggestions when cohesive categories are missing', () {
      const simpleText = 'I like cats. They are cute. Dogs are also nice.';
      final res = analyzer.analyze(simpleText);
      expect(res.suggestions.any((s) => s.contains('контрастирующие связки')), isTrue);
      expect(res.suggestions.any((s) => s.contains('причинно-следственные')), isTrue);
    });
  });
}
