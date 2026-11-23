import 'package:equatable/equatable.dart';

enum DeviceCategory {
  addition,
  contrast,
  causeEffect,
  sequencing,
  conclusion,
}

class CohesiveDeviceMatch extends Equatable {
  final String phrase;
  final DeviceCategory category;

  const CohesiveDeviceMatch({
    required this.phrase,
    required this.category,
  });

  @override
  List<Object?> get props => [phrase, category];
}

class WritingAnalysisResult extends Equatable {
  final int wordCount;
  final int paragraphCount;
  final List<CohesiveDeviceMatch> foundDevices;
  final int uniqueCategoriesCount;
  final double cohesionScoreOutOf8;
  final List<String> suggestions;

  const WritingAnalysisResult({
    required this.wordCount,
    required this.paragraphCount,
    required this.foundDevices,
    required this.uniqueCategoriesCount,
    required this.cohesionScoreOutOf8,
    required this.suggestions,
  });

  @override
  List<Object?> get props => [
        wordCount,
        paragraphCount,
        foundDevices,
        uniqueCategoriesCount,
        cohesionScoreOutOf8,
        suggestions,
      ];
}

class CohesiveDevicesAnalyzer {
  const CohesiveDevicesAnalyzer();

  static const Map<DeviceCategory, List<String>> _devicesDictionary = {
    DeviceCategory.addition: [
      'furthermore',
      'in addition',
      'moreover',
      'as well as',
      'besides',
      'not only',
      'what is more',
      'additionally',
    ],
    DeviceCategory.contrast: [
      'however',
      'on the other hand',
      'in contrast',
      'nevertheless',
      'although',
      'even though',
      'whereas',
      'despite',
      'in spite of',
      'on the contrary',
    ],
    DeviceCategory.causeEffect: [
      'consequently',
      'therefore',
      'as a result',
      'for this reason',
      'due to',
      'owing to',
      'thus',
      'hence',
    ],
    DeviceCategory.sequencing: [
      'firstly',
      'secondly',
      'thirdly',
      'to begin with',
      'in the first place',
      'subsequently',
      'meanwhile',
      'following this',
    ],
    DeviceCategory.conclusion: [
      'to sum up',
      'in conclusion',
      'all in all',
      'to conclude',
      'taking everything into account',
      'in summary',
      'overall',
    ],
  };

  WritingAnalysisResult analyze(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return const WritingAnalysisResult(
        wordCount: 0,
        paragraphCount: 0,
        foundDevices: [],
        uniqueCategoriesCount: 0,
        cohesionScoreOutOf8: 0,
        suggestions: ['Текст пустой. Начни с введения или тезиса.'],
      );
    }

    final words = cleanText.split(RegExp(r'\s+'));
    final wordCount = words.length;

    final paragraphs = cleanText
        .split(RegExp(r'\n+'))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    final paragraphCount = paragraphs.length;

    final lower = cleanText.toLowerCase();
    final List<CohesiveDeviceMatch> matches = [];
    final Set<DeviceCategory> categoriesUsed = {};

    for (final entry in _devicesDictionary.entries) {
      for (final device in entry.value) {
        // Match phrase with word boundaries or punctuation
        final pattern = RegExp(r'(?:^|[\s,.;:!?])' + RegExp.escape(device) + r'(?:$|[\s,.;:!?])');
        if (pattern.hasMatch(lower)) {
          matches.add(CohesiveDeviceMatch(phrase: device, category: entry.key));
          categoriesUsed.add(entry.key);
        }
      }
    }

    // Scoring logic for IB Criterion D (out of 8)
    double score = 2.0; // Base score for non-empty text

    if (wordCount >= 100 && wordCount <= 300) {
      score += 1.5;
    } else if (wordCount > 300) {
      score += 1.0;
    }

    if (paragraphCount >= 3) {
      score += 1.5;
    } else if (paragraphCount == 2) {
      score += 0.5;
    }

    if (categoriesUsed.length >= 4) {
      score += 3.0;
    } else if (categoriesUsed.length == 3) {
      score += 2.0;
    } else if (categoriesUsed.isNotEmpty) {
      score += 1.0;
    }

    final finalScore = score.clamp(1.0, 8.0);

    final List<String> suggestions = [];
    if (wordCount < 100) {
      suggestions.add('Объем маловат ($wordCount слов). Для эссе IB MYP рекомендуется от 150 до 250 слов.');
    }
    if (paragraphCount < 3) {
      suggestions.add('Раздели текст минимум на 3 абзаца (введение, основная часть, заключение).');
    }
    if (!categoriesUsed.contains(DeviceCategory.contrast)) {
      suggestions.add('Добавь контрастирующие связки (however, on the other hand, although) для многогранности.');
    }
    if (!categoriesUsed.contains(DeviceCategory.causeEffect)) {
      suggestions.add('Используй причинно-следственные союзы (therefore, consequently, as a result) для аргументации.');
    }
    if (!categoriesUsed.contains(DeviceCategory.conclusion)) {
      suggestions.add('Заверши текст четким выводом (in conclusion, to sum up, overall).');
    }

    return WritingAnalysisResult(
      wordCount: wordCount,
      paragraphCount: paragraphCount,
      foundDevices: matches,
      uniqueCategoriesCount: categoriesUsed.length,
      cohesionScoreOutOf8: finalScore,
      suggestions: suggestions,
    );
  }
}
