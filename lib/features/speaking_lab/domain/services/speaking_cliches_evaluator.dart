import 'package:equatable/equatable.dart';

class MonologueEvaluationResult extends Equatable {
  final bool hasIntro;
  final bool hasConclusion;
  final List<String> detectedLinkers;
  final int sentenceCount;
  final int wordCount;
  final bool isPass;
  final String feedback;

  const MonologueEvaluationResult({
    required this.hasIntro,
    required this.hasConclusion,
    required this.detectedLinkers,
    required this.sentenceCount,
    required this.wordCount,
    required this.isPass,
    required this.feedback,
  });

  @override
  List<Object?> get props => [
        hasIntro,
        hasConclusion,
        detectedLinkers,
        sentenceCount,
        wordCount,
        isPass,
        feedback,
      ];
}

class SpeakingClichesEvaluator {
  const SpeakingClichesEvaluator();

  static const List<String> _introPhrases = [
    'i am going to give a talk about',
    "i'm going to give a talk about",
    'i would like to give a talk about',
    "i'd like to give a talk about",
    'today i am going to talk about',
    "today i'm going to talk about",
  ];

  static const List<String> _conclusionPhrases = [
    'that is all i wanted to say',
    "that's all i wanted to say",
    'thank you for listening',
    'thank you for your attention',
    "that is all from me",
    "that's all from me",
  ];

  static const List<String> _commonLinkers = [
    'firstly',
    'secondly',
    'to begin with',
    'in addition',
    'furthermore',
    'besides',
    'moreover',
    'for example',
    'for instance',
    'to sum up',
    'in conclusion',
    'finally',
    'as a result',
    'however',
    'on the one hand',
    'on the other hand',
  ];

  MonologueEvaluationResult evaluateMonologue(String text) {
    final cleaned = text.trim();
    if (cleaned.isEmpty) {
      return const MonologueEvaluationResult(
        hasIntro: false,
        hasConclusion: false,
        detectedLinkers: [],
        sentenceCount: 0,
        wordCount: 0,
        isPass: false,
        feedback: 'Введите или продиктуйте текст монолога для анализа.',
      );
    }

    final lower = cleaned.toLowerCase();
    final hasIntro = _introPhrases.any((phrase) => lower.contains(phrase));
    final hasConclusion = _conclusionPhrases.any((phrase) => lower.contains(phrase));

    final detected = <String>[];
    for (final linker in _commonLinkers) {
      if (lower.contains(linker) && !detected.contains(linker)) {
        detected.add(linker);
      }
    }

    final words = cleaned
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty && RegExp(r'[a-zA-Z]').hasMatch(w))
        .length;

    final sentences = cleaned
        .split(RegExp(r'[.!?]+'))
        .where((s) => s.trim().isNotEmpty)
        .length;

    final hasEnoughSentences = sentences >= 8;
    final hasEnoughLinkers = detected.length >= 2;
    final isPass = hasIntro && hasConclusion && hasEnoughSentences && hasEnoughLinkers;

    final feedbackList = <String>[];
    if (!hasIntro) {
      feedbackList.add('Добавь вступительное клише (например: "I am going to give a talk about...")');
    }
    if (!hasConclusion) {
      feedbackList.add('Добавь завершающую фразу (например: "That is all I wanted to say. Thank you for listening.")');
    }
    if (!hasEnoughLinkers) {
      feedbackList.add('Используй минимум 2 вводных слова/связки (detected: ${detected.length})');
    }
    if (!hasEnoughSentences) {
      feedbackList.add('Объем монолога меньше нормы: $sentences/10–12 фраз');
    }

    final feedback = isPass
        ? 'Отличный монолог! Все критерии ОГЭ (вступление, заключение, связки и объем $sentences фраз) выполнены на максимум (7/7 баллов).'
        : feedbackList.join('; ');

    return MonologueEvaluationResult(
      hasIntro: hasIntro,
      hasConclusion: hasConclusion,
      detectedLinkers: detected,
      sentenceCount: sentences,
      wordCount: words,
      isPass: isPass,
      feedback: feedback,
    );
  }

  bool isDialogueAnswerComplete(String answer) {
    final cleaned = answer.trim();
    if (cleaned.isEmpty) return false;
    final sentences = cleaned
        .split(RegExp(r'[.!?]+'))
        .where((s) => s.trim().isNotEmpty)
        .length;
    final words = cleaned.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    return sentences >= 2 || words >= 12;
  }
}
