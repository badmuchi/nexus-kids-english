import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../srs/domain/services/english_answer_evaluator.dart';
import '../../domain/entities/mistake_entity.dart';
import '../mistakes_bloc.dart';
import '../mistakes_event.dart';

class MistakesBlitzScreen extends StatefulWidget {
  final List<MistakeEntity> mistakesToPractice;

  const MistakesBlitzScreen({super.key, required this.mistakesToPractice});

  @override
  State<MistakesBlitzScreen> createState() => _MistakesBlitzScreenState();
}

class _MistakesBlitzScreenState extends State<MistakesBlitzScreen> {
  final EnglishAnswerEvaluator _evaluator = const EnglishAnswerEvaluator();
  final TextEditingController _answerController = TextEditingController();

  int _currentIndex = 0;
  int _correctInSession = 0;
  EvaluationResult? _evalResult;
  bool _isAnswerChecked = false;
  bool _isSessionFinished = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_answerController.text.trim().isEmpty) return;

    final currentMistake = widget.mistakesToPractice[_currentIndex];
    final result = _evaluator.evaluate(
      typed: _answerController.text.trim(),
      expected: currentMistake.correctAnswer,
    );

    final isCorrect = result.isAccepted;

    setState(() {
      _evalResult = result;
      _isAnswerChecked = true;
      if (isCorrect) {
        _correctInSession++;
      }
    });

    // Record in BLoC
    context.read<MistakesBloc>().add(
          RecordMistakeAttempt(
            id: currentMistake.id,
            isCorrect: isCorrect,
          ),
        );
  }

  void _nextCard() {
    if (_currentIndex < widget.mistakesToPractice.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswerChecked = false;
        _evalResult = null;
        _answerController.clear();
      });
    } else {
      setState(() {
        _isSessionFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mistakesToPractice.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Блиц-исправление ошибок')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sentiment_very_satisfied, size: 72, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Тетрадь ошибок пуста!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Все ошибки успешно исправлены и закреплены на 3/3 🔥. Отличная работа!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Вернуться назад'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isSessionFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Результаты блица')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech, size: 72, color: AppTheme.accentColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Сессия завершена!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Правильно: $_correctInSession из ${widget.mistakesToPractice.length}',
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'По правилу ОГЭ: карточка полностью снимается с контроля после 3 правильных ответов подряд.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('В тетрадь ошибок', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final currentMistake = widget.mistakesToPractice[_currentIndex];
    final isCorrect = _evalResult?.isAccepted ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Блиц: ${_currentIndex + 1} / ${widget.mistakesToPractice.length}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.mistakesToPractice.length,
              backgroundColor: Colors.grey.shade200,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentMistake.taskType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text('Стрик: ', style: TextStyle(color: Colors.grey)),
                            ...List.generate(
                              3,
                              (i) => Icon(
                                Icons.local_fire_department,
                                size: 20,
                                color: i < currentMistake.masteryStreak
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Задание:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentMistake.prompt,
                      style: const TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _answerController,
                      enabled: !_isAnswerChecked,
                      decoration: InputDecoration(
                        hintText: 'Введи правильную форму слова...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      onSubmitted: (_) => _isAnswerChecked ? null : _checkAnswer(),
                    ),
                    const SizedBox(height: 16),
                    if (!_isAnswerChecked)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _checkAnswer,
                        child: const Text('Проверить ответ', style: TextStyle(color: Colors.white)),
                      )
                    else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green.withOpacity(0.12)
                              : Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect ? Colors.green : Colors.redAccent,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isCorrect ? 'Верно!' : 'Ошибка!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Правильный ответ: ${currentMistake.correctAnswer}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Правило: ${currentMistake.explanation}',
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _nextCard,
                        child: Text(
                          _currentIndex < widget.mistakesToPractice.length - 1
                              ? 'Следующая карточка'
                              : 'Завершить блиц',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
