import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../mascot_duel_bloc.dart';
import '../mascot_duel_event.dart';
import '../mascot_duel_state.dart';

class MascotDuelScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const MascotDuelScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<MascotDuelScreen> createState() => _MascotDuelScreenState();
}

class _MascotDuelScreenState extends State<MascotDuelScreen> {
  Timer? _gameTimer;
  final Random _random = Random();
  int _sparkyCounter = 0;

  @override
  void initState() {
    super.initState();
    _startDuel();
  }

  void _startDuel() {
    _gameTimer?.cancel();
    context.read<MascotDuelBloc>().add(const StartDuelEvent());
    _sparkyCounter = 0;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final bloc = context.read<MascotDuelBloc>();
      if (bloc.state is MascotDuelInProgress) {
        bloc.add(const TickDuelTimerEvent());

        _sparkyCounter++;
        // Sparky attempts to answer every 3 seconds
        if (_sparkyCounter % 3 == 0) {
          final sparkyIsCorrect = _random.nextDouble() < 0.75;
          bloc.add(SparkyAnswerEvent(sparkyIsCorrect));
        }
      } else if (bloc.state is MascotDuelFinished) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚔️ Блиц-дуэль со Спарки (60с)'),
      ),
      body: BlocConsumer<MascotDuelBloc, MascotDuelState>(
        listener: (context, state) {
          if (state is MascotDuelFinished) {
            _gameTimer?.cancel();
            if (state.isUserWinner) {
              widget.audioService.speakText('Victory! You defeated Sparky!');
            }
          }
        },
        builder: (context, state) {
          return switch (state) {
            MascotDuelInitial() || MascotDuelLoading() =>
              const Center(child: CircularProgressIndicator()),
            MascotDuelErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            MascotDuelInProgress() => _buildActiveDuel(context, state),
            MascotDuelFinished() => _buildFinishedDuel(context, state),
          };
        },
      ),
    );
  }

  Widget _buildActiveDuel(BuildContext context, MascotDuelInProgress state) {
    final q = state.currentQuestion;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Scoreboard Header
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User score
                  Column(
                    children: [
                      const Text('👤 Ты', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        '${state.userScore}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: state.secondsRemaining <= 10 ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⏱️ ${state.secondsRemaining} сек',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: state.secondsRemaining <= 10 ? AppTheme.errorColor : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  // Sparky score
                  Column(
                    children: [
                      const Text('🦊 Спарки', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        '${state.sparkyScore}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Вопрос ${state.currentQuestionIndex + 1} • ${q.type}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      q.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    for (int i = 0; i < q.options.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getOptionColor(state, i),
                            foregroundColor: _getOptionTextColor(state, i),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          onPressed: state.lastChosenIndex == null
                              ? () {
                                  context.read<MascotDuelBloc>().add(
                                        AnswerDuelQuestionEvent(i),
                                      );
                                }
                              : null,
                          child: Text(
                            q.options[i],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(MascotDuelInProgress state, int index) {
    if (state.lastChosenIndex == null) {
      return Colors.white;
    }
    if (index == state.currentQuestion.correctIndex) {
      return const Color(0xFFDCFCE7);
    }
    if (index == state.lastChosenIndex && state.lastIsCorrect == false) {
      return const Color(0xFFFEE2E2);
    }
    return Colors.white;
  }

  Color _getOptionTextColor(MascotDuelInProgress state, int index) {
    if (state.lastChosenIndex == null) {
      return Colors.black87;
    }
    if (index == state.currentQuestion.correctIndex) {
      return AppTheme.successColor;
    }
    if (index == state.lastChosenIndex && state.lastIsCorrect == false) {
      return AppTheme.errorColor;
    }
    return Colors.black54;
  }

  Widget _buildFinishedDuel(BuildContext context, MascotDuelFinished state) {
    final title = state.isUserWinner
        ? '🏆 Ты победил Спарки!'
        : (state.isDraw ? '🤝 Боевая ничья!' : '🦊 Спарки победил!');

    final subtitle = state.isUserWinner
        ? 'Невероятная скорость и точность! Спарки аплодирует стоя.'
        : (state.isDraw
            ? 'Вы шли ноздря в ноздрю! Отличный результат!'
            : 'Лисёнок сегодня был быстрее. Потренируйся и возьми реванш!');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.isUserWinner ? '🎉🦊🥇' : (state.isDraw ? '🤝✨' : '🦊💪'),
                  style: const TextStyle(fontSize: 54),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text('Ты:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${state.userScore}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.primaryColor),
                        ),
                      ],
                    ),
                    const Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Column(
                      children: [
                        const Text('Спарки:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${state.sparkyScore}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.accentColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Chip(
                  backgroundColor: AppTheme.accentColor.withAlpha(40),
                  avatar: const Icon(Icons.star, color: AppTheme.accentColor),
                  label: Text(
                    '+${state.xpEarned} XP получено!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _startDuel,
                  icon: const Icon(Icons.replay),
                  label: const Text('Сыграть реванш (60с)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
