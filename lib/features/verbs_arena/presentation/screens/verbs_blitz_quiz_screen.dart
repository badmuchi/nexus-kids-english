import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/irregular_verb_entity.dart';

class VerbsBlitzQuizScreen extends StatefulWidget {
  final List<IrregularVerbEntity> allVerbs;
  final HybridAudioPlaybackService audioService;

  const VerbsBlitzQuizScreen({
    super.key,
    required this.allVerbs,
    required this.audioService,
  });

  @override
  State<VerbsBlitzQuizScreen> createState() => _VerbsBlitzQuizScreenState();
}

class _VerbsBlitzQuizScreenState extends State<VerbsBlitzQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedOption;
  late List<IrregularVerbEntity> _quizQuestions;
  late List<String> _currentOptions;
  late bool _askForV2;

  @override
  void initState() {
    super.initState();
    _quizQuestions = List.of(widget.allVerbs)..shuffle(Random());
    if (_quizQuestions.length > 10) {
      _quizQuestions = _quizQuestions.sublist(0, 10);
    }
    _setupQuestion();
  }

  void _setupQuestion() {
    _answered = false;
    _selectedOption = null;
    final verb = _quizQuestions[_currentIndex];
    _askForV2 = Random().nextBool();
    final correctAnswer = _askForV2 ? verb.v2 : verb.v3;

    final wrongPool = widget.allVerbs
        .where((v) => v.id != verb.id)
        .map((v) => _askForV2 ? v.v2 : v.v3)
        .toSet()
        .toList()
      ..shuffle();

    final options = <String>{correctAnswer};
    for (final wrong in wrongPool) {
      if (options.length >= 4) break;
      options.add(wrong);
    }

    _currentOptions = options.toList()..shuffle();
  }

  void _handleOptionTap(String option) {
    if (_answered) return;
    final currentVerb = _quizQuestions[_currentIndex];
    final correctAnswer = _askForV2 ? currentVerb.v2 : currentVerb.v3;
    final isCorrect = option == correctAnswer;

    setState(() {
      _answered = true;
      _selectedOption = option;
      if (isCorrect) {
        _score++;
        widget.audioService.speakText('Great! $correctAnswer');
      } else {
        widget.audioService.speakText('Correct was $correctAnswer');
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_currentIndex + 1 < _quizQuestions.length) {
        setState(() {
          _currentIndex++;
          _setupQuestion();
        });
      } else {
        _showResultsDialog();
      }
    });
  }

  void _showResultsDialog() {
    final earnedXp = _score * 10;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Блиц завершен!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🦊', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Твой результат: $_score из ${_quizQuestions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '+$earnedXp XP получено!',
                style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('В Атлас глаголов'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verb = _quizQuestions[_currentIndex];
    final correctAnswer = _askForV2 ? verb.v2 : verb.v3;
    final formName = _askForV2 ? '2-ю форму (Past Simple / V2)' : '3-ю форму (Past Participle / V3)';

    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${_currentIndex + 1} из ${_quizQuestions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _quizQuestions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Выбери $formName:',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      verb.v1.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      verb.translation,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.8,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: _currentOptions.map((opt) {
                  Color btnBg = Colors.white;
                  Color textColor = const Color(0xFF1E293B);
                  BorderSide border = BorderSide(color: Colors.grey.shade300, width: 1.5);

                  if (_answered) {
                    if (opt == correctAnswer) {
                      btnBg = Colors.green.shade50;
                      border = const BorderSide(color: Colors.green, width: 2.5);
                      textColor = Colors.green.shade900;
                    } else if (opt == _selectedOption) {
                      btnBg = Colors.red.shade50;
                      border = const BorderSide(color: Colors.red, width: 2.5);
                      textColor = Colors.red.shade900;
                    }
                  }

                  return ElevatedButton(
                    onPressed: _answered ? null : () => _handleOptionTap(opt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnBg,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: border,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
