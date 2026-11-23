import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../oge_bloc.dart';
import '../oge_event.dart';
import '../oge_state.dart';

class OgeWordFormationScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const OgeWordFormationScreen({super.key, required this.audioService});

  @override
  State<OgeWordFormationScreen> createState() => _OgeWordFormationScreenState();
}

class _OgeWordFormationScreenState extends State<OgeWordFormationScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ОГЭ • Словообразование (29–34)'),
      ),
      body: BlocConsumer<OgeBloc, OgeState>(
        listener: (context, state) {
          if (state is OgeWordFormationActive && !state.isAnswerChecked) {
            _inputController.clear();
          }
        },
        builder: (context, state) {
          return switch (state) {
            OgeInitial() => const Center(child: Text('Загрузка заданий...')),
            OgeLoading() => const Center(child: CircularProgressIndicator()),
            OgeCompleted(title: final t, totalCount: final c) => _buildCompletedView(context, t, c),
            OgeErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            OgeWordFormationActive() => _buildActiveView(context, state),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildCompletedView(BuildContext context, String title, int count) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 72, color: AppTheme.accentColor),
          const SizedBox(height: 16),
          Text(
            'Блок пройден: $title',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Решено заданий: $count. Навык работы с суффиксами прокачан!'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Вернуться в хаб'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveView(BuildContext context, OgeWordFormationActive state) {
    final task = state.currentTask;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Задание ${state.currentIndex + 1} из ${state.tasks.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${task.partOfSpeech} • ${task.affix}',
                  style: const TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Исходная основа: ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        task.baseWord,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18,
                            height: 1.6,
                          ),
                      children: [
                        TextSpan(text: '${task.sentenceBefore} '),
                        TextSpan(
                          text: state.isAnswerChecked
                              ? '[ ${task.correctAnswer} ]'
                              : '[ ____________ ]',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.isAnswerChecked
                                ? (state.isCorrect
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor)
                                : AppTheme.secondaryColor,
                          ),
                        ),
                        TextSpan(text: ' ${task.sentenceAfter}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.grey),
                      onPressed: () {
                        final fullText = '${task.sentenceBefore} ${task.correctAnswer} ${task.sentenceAfter}';
                        widget.audioService.speakText(fullText);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!state.isAnswerChecked) ...[
            TextField(
              controller: _inputController,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Образуй новое слово от "${task.baseWord}"...',
                prefixIcon: const Icon(Icons.build_circle_outlined),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  context.read<OgeBloc>().add(SubmitWordFormationAnswerEvent(
                        taskId: task.id,
                        typedAnswer: val,
                      ));
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final text = _inputController.text.trim();
                if (text.isNotEmpty) {
                  context.read<OgeBloc>().add(SubmitWordFormationAnswerEvent(
                        taskId: task.id,
                        typedAnswer: text,
                      ));
                }
              },
              child: const Text('Проверить ответ'),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (state.isCorrect ? AppTheme.successColor : AppTheme.errorColor)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (state.isCorrect ? AppTheme.successColor : AppTheme.errorColor)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.isCorrect ? Icons.check_circle : Icons.error_outline,
                        color: state.isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.feedback ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.isCorrect
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Разбор словообразования:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.explanation,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<OgeBloc>().add(const NextWordFormationTaskEvent()),
              child: Text(state.isLastTask ? 'Завершить блок' : 'Следующее задание'),
            ),
          ],
        ],
      ),
    );
  }
}
