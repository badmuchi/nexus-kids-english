import 'package:equatable/equatable.dart';

enum WpmPaceStatus {
  tooSlow,
  ideal,
  tooFast,
}

class WpmResult extends Equatable {
  final int wordsCount;
  final int durationSeconds;
  final int wordsPerMinute;
  final WpmPaceStatus status;
  final String recommendation;

  const WpmResult({
    required this.wordsCount,
    required this.durationSeconds,
    required this.wordsPerMinute,
    required this.status,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
        wordsCount,
        durationSeconds,
        wordsPerMinute,
        status,
        recommendation,
      ];
}

class WpmCalculator {
  const WpmCalculator();

  WpmResult calculate({
    required int wordsCount,
    required int durationSeconds,
  }) {
    if (wordsCount <= 0 || durationSeconds <= 0) {
      return const WpmResult(
        wordsCount: 0,
        durationSeconds: 0,
        wordsPerMinute: 0,
        status: WpmPaceStatus.tooSlow,
        recommendation: 'Запись слишком короткая для анализа.',
      );
    }

    final wpm = ((wordsCount / durationSeconds) * 60).round();

    if (wpm < 90) {
      return WpmResult(
        wordsCount: wordsCount,
        durationSeconds: durationSeconds,
        wordsPerMinute: wpm,
        status: WpmPaceStatus.tooSlow,
        recommendation: 'Темп речи медленный ($wpm WPM). На ОГЭ старайся читать без затяжных пауз, норма: 100–120 слов/мин.',
      );
    } else if (wpm > 130) {
      return WpmResult(
        wordsCount: wordsCount,
        durationSeconds: durationSeconds,
        wordsPerMinute: wpm,
        status: WpmPaceStatus.tooFast,
        recommendation: 'Темп речи слишком высокий ($wpm WPM). Эксперты ОГЭ ценят отчетливое произношение и логические паузы на знаках препинания.',
      );
    } else {
      return WpmResult(
        wordsCount: wordsCount,
        durationSeconds: durationSeconds,
        wordsPerMinute: wpm,
        status: WpmPaceStatus.ideal,
        recommendation: 'Идеальный темп ($wpm WPM)! Звучит уверенно, внятно и полностью соответствует стандарту ФИПИ.',
      );
    }
  }
}
