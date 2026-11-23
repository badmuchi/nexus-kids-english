import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/ib_speaking_entity.dart';
import '../ib_speaking_bloc.dart';
import '../ib_speaking_event.dart';
import '../ib_speaking_state.dart';

class IbSpeakingStudioScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const IbSpeakingStudioScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<IbSpeakingStudioScreen> createState() => _IbSpeakingStudioScreenState();
}

class _IbSpeakingStudioScreenState extends State<IbSpeakingStudioScreen> {
  Timer? _timer;
  int _secondsLeft = 60;
  bool _isPreparation = true;
  bool _isRunning = false;
  int _selfScore = 7;
  bool _showSampleAnswer = false;

  @override
  void initState() {
    super.initState();
    context.read<IbSpeakingBloc>().add(const LoadIbSpeakingTasksEvent());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int totalSeconds, bool isPrep) {
    _timer?.cancel();
    setState(() {
      _secondsLeft = totalSeconds;
      _isPreparation = isPrep;
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _isRunning = false;
          if (_isPreparation) {
            // Auto-switch to speaking phase
            _isPreparation = false;
            _secondsLeft = 90;
          } else {
            _secondsLeft = 0;
          }
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer(IbSpeakingTaskEntity task) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPreparation = true;
      _secondsLeft = task.prepTimeSeconds;
    });
  }

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎙️ IB MYP Speaking Studio'),
      ),
      body: BlocBuilder<IbSpeakingBloc, IbSpeakingState>(
        builder: (context, state) {
          return switch (state) {
            IbSpeakingInitial() || IbSpeakingLoading() =>
              const Center(child: CircularProgressIndicator()),
            IbSpeakingErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            IbSpeakingLoaded() => _buildLoadedBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context, IbSpeakingLoaded state) {
    final task = state.currentTask;
    if (task == null) {
      return const Center(child: Text('Задания устной части не найдены'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Task switcher chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: state.tasks.map((t) {
              final isSelected = t.id == task.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('${t.imageEmoji} ${t.title}'),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withAlpha(50),
                  onSelected: (selected) {
                    if (selected) {
                      _resetTimer(t);
                      context.read<IbSpeakingBloc>().add(SelectIbSpeakingTaskEvent(t.id));
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Visual Illustration Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Global Context: ${task.globalContext}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                    if (task.isCompleted)
                      Chip(
                        backgroundColor: const Color(0xFFDCFCE7),
                        label: Text(
                          '${task.scoreOutOf8}/8 баллов ⭐',
                          style: const TextStyle(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    task.imageEmoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Interactive Speaking Timer
        Card(
          color: _isPreparation ? const Color(0xFFEFF6FF) : const Color(0xFFFEF3C7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isPreparation ? AppTheme.primaryColor : AppTheme.accentColor,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isPreparation ? '⏳ Фаза 1: Подготовка (1 мин)' : '🗣️ Фаза 2: Ответ (1.5 мин)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _isPreparation ? AppTheme.primaryColor : Colors.amber.shade900,
                      ),
                    ),
                    Text(
                      _formatTime(_secondsLeft),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _isPreparation ? AppTheme.primaryColor : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning ? Colors.grey : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_isRunning) {
                            _pauseTimer();
                          } else {
                            _startTimer(_secondsLeft, _isPreparation);
                          }
                        },
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'Пауза' : 'Старт таймера'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Сбросить',
                      onPressed: () => _resetTimer(task),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Guiding questions
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.help_outline, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Опорные вопросы (Guiding Questions):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...task.guidingQuestions.map((q) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(q, style: const TextStyle(fontSize: 14))),
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 20, color: AppTheme.primaryColor),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Послушать вопрос',
                            onPressed: () => widget.audioService.speakText(q),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Phrase Bank
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: AppTheme.secondaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Банк речевых клише (Speech Bank):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: task.phraseBank.map((phrase) {
                    return ActionChip(
                      avatar: const Icon(Icons.volume_up, size: 16),
                      label: Text(phrase),
                      onPressed: () => widget.audioService.speakText(phrase),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sample Model Response
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🌟 Эталонный ответ (8/8 баллов):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showSampleAnswer = !_showSampleAnswer;
                        });
                      },
                      child: Text(_showSampleAnswer ? 'Скрыть' : 'Показать'),
                    ),
                  ],
                ),
                if (_showSampleAnswer) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.sampleAnswer,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => widget.audioService.speakText(task.sampleAnswer),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Слушать эталон целиком'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Criterion C Rubric Score Submission
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Оценка Criterion C: Speaking (1-8 баллов)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  'Самооценка или оценка наставника: уверенность речи, организация и использование речевых клише.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                Slider(
                  value: _selfScore.toDouble(),
                  min: 1,
                  max: 8,
                  divisions: 7,
                  label: '$_selfScore / 8',
                  onChanged: (val) {
                    setState(() {
                      _selfScore = val.round();
                    });
                  },
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      context.read<IbSpeakingBloc>().add(
                            SubmitSpeakingScoreEvent(
                              taskId: task.id,
                              scoreOutOf8: _selfScore,
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Балл $_selfScore/8 сохранен! +50 XP получено! 🎉'),
                        ),
                      );
                    },
                    child: Text('Сохранить результат ($_selfScore / 8)'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
