import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/oge_exam_entity.dart';
import '../oge_exam_bloc.dart';
import '../oge_exam_event.dart';
import '../oge_exam_state.dart';

class OgeExamSimulatorScreen extends StatefulWidget {
  const OgeExamSimulatorScreen({super.key});

  @override
  State<OgeExamSimulatorScreen> createState() => _OgeExamSimulatorScreenState();
}

class _OgeExamSimulatorScreenState extends State<OgeExamSimulatorScreen> {
  Timer? _examTimer;
  int _secondsRemaining = 7200; // 120 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        context.read<OgeExamBloc>().add(const CompleteExamEvent());
      }
    });
  }

  @override
  void dispose() {
    _examTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    final s = sec % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Полный симулятор ОГЭ (120 мин)'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: AppTheme.primaryColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_secondsRemaining),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<OgeExamBloc, OgeExamState>(
        builder: (context, state) {
          return switch (state) {
            OgeExamInitial() || OgeExamLoading() => const Center(child: CircularProgressIndicator()),
            OgeExamErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            OgeExamFinished(summary: final s) => _buildFinishedView(context, s),
            OgeExamInProgress() => _buildExamView(context, state),
          };
        },
      ),
    );
  }

  Widget _buildFinishedView(BuildContext context, ExamResultSummary summary) {
    final markColor = summary.gradeMark == 5
        ? AppTheme.successColor
        : (summary.gradeMark == 4 ? AppTheme.primaryColor : AppTheme.accentColor);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: markColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: markColor, width: 3),
              ),
              alignment: Alignment.center,
              child: Text(
                '${summary.gradeMark}',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: markColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Оценка: ${summary.gradeMark} (${summary.totalScore} из 68 баллов)',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              summary.gradeMark == 5
                  ? 'Блестяще! По шкале ФИПИ это высший балл (от 59 до 68).'
                  : 'Хороший результат! Разбери ошибки для выхода на «5».',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildScoreRow('1. Аудирование (Задания 1–11):', '${summary.listeningScore}/15'),
                    _buildScoreRow('2. Чтение (Задания 12–19):', '${summary.readingScore}/13'),
                    _buildScoreRow('3. Грамматика и лексика (20–34):', '${summary.grammarScore}/15'),
                    _buildScoreRow('4. Электронное письмо (35):', '${summary.emailScore}/10'),
                    _buildScoreRow('5. Говорение (Устная часть 1–3):', '${summary.speakingScore}/15'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Вернуться в хаб'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildExamView(BuildContext context, OgeExamInProgress state) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Экзаменационный бланк ОГЭ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Выполняй задания последовательно. В конце нажми "Сдать экзамен".',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('Раздел 1: Аудирование (Задания 1–4)'),
        ...state.listeningTasks1_4.map((q) {
          final sel = state.selectedListeningAnswers[q.id];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...List.generate(q.options.length, (idx) {
                    return RadioListTile<int>(
                      dense: true,
                      value: idx,
                      groupValue: sel,
                      title: Text(q.options[idx]),
                      onChanged: (val) {
                        context.read<OgeExamBloc>().add(
                              SelectListeningOptionEvent(
                                questionId: q.id,
                                selectedIndex: val!,
                              ),
                            );
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        _buildSectionHeader('Раздел 2: Чтение (Задания 13–19 True/False/Not Stated)'),
        ...state.readingTrueFalse.map((q) {
          final sel = state.selectedTrueFalse[q.id];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.statement, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['TRUE', 'FALSE', 'NOT_STATED'].map((choice) {
                      final isChosen = sel == choice;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isChosen ? AppTheme.primaryColor : null,
                              foregroundColor: isChosen ? Colors.white : null,
                            ),
                            onPressed: () {
                              context.read<OgeExamBloc>().add(
                                    SelectTrueFalseEvent(
                                      questionId: q.id,
                                      choice: choice,
                                    ),
                                  );
                            },
                            child: Text(choice, style: const TextStyle(fontSize: 11)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            context.read<OgeExamBloc>().add(const CompleteExamEvent());
          },
          child: const Text('Сдать экзамен и получить оценку ОГЭ', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
      ),
    );
  }
}
