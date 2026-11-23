import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/entities/srs_card_entity.dart';
import '../domain/services/english_answer_evaluator.dart';
import 'srs_bloc.dart';
import 'srs_event.dart';
import 'srs_state.dart';

class SrsScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const SrsScreen({super.key, required this.audioService});

  @override
  State<SrsScreen> createState() => _SrsScreenState();
}

class _SrsScreenState extends State<SrsScreen> {
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
        title: const Text('Карточки SRS • Словарный запас'),
      ),
      body: BlocConsumer<SrsBloc, SrsState>(
        listener: (context, state) {
          if (state is SrsActive && !state.isAnswerRevealed) {
            _inputController.clear();
          }
        },
        builder: (context, state) {
          return switch (state) {
            SrsInitial() => const Center(child: Text('Нажмите, чтобы начать тренировку')),
            SrsLoading() => const Center(child: CircularProgressIndicator()),
            SrsEmpty() => _buildEmptyState(context),
            SrsCompleted(totalReviewed: final count) => _buildCompletedState(context, count),
            SrsErrorState(message: final msg) => Center(child: Text('Ошибка: $msg')),
            SrsActive() => _buildActiveStudyView(context, state),
          };
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 72, color: AppTheme.successColor),
          const SizedBox(height: 16),
          const Text(
            'На сегодня все карточки изучены!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Возвращайся завтра или начни свободное повторение.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<SrsBloc>().add(const LoadDueCardsEvent()),
            child: const Text('Повторить снова'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context, int count) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 72, color: AppTheme.accentColor),
          const SizedBox(height: 16),
          Text(
            'Отличная работа! Изучено слов: $count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('+50 XP добавлено к твоему профилю!'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Вернуться в меню'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStudyView(BuildContext context, SrsActive state) {
    final card = state.currentCard;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressBar(current: state.currentIndex + 1, total: state.cards.length),
          const SizedBox(height: 20),
          _SrsCardWidget(
            card: card,
            isRevealed: state.isAnswerRevealed,
            audioService: widget.audioService,
          ),
          const SizedBox(height: 24),
          if (!state.isAnswerRevealed) ...[
            TextField(
              controller: _inputController,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Напиши слово на английском...',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  context.read<SrsBloc>().add(CheckAnswerEvent(
                        cardId: card.id,
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
                  context.read<SrsBloc>().add(CheckAnswerEvent(
                        cardId: card.id,
                        typedAnswer: text,
                      ));
                }
              },
              child: const Text('Проверить ответ'),
            ),
          ] else ...[
            if (state.lastEvaluation != null) ...[
              _EvaluationFeedback(evaluation: state.lastEvaluation!),
              const SizedBox(height: 20),
            ],
            const Text(
              'Насколько сложно было вспомнить?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _RatingButtonsRow(cardId: card.id),
          ],
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Карточка $current из $total',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${((current / total) * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / total,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ],
    );
  }
}

class _SrsCardWidget extends StatelessWidget {
  final SrsCardEntity card;
  final bool isRevealed;
  final HybridAudioPlaybackService audioService;

  const _SrsCardWidget({
    required this.card,
    required this.isRevealed,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    card.level,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  card.category,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              card.backRussian,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            if (isRevealed) ...[
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    card.frontEnglish,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor),
                    onPressed: () => audioService.speakText(card.frontEnglish),
                  ),
                ],
              ),
              if (card.transcriptionIpa != null) ...[
                const SizedBox(height: 4),
                Text(
                  card.transcriptionIpa!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              if (card.exampleSentence != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        card.exampleSentence!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                      ),
                      if (card.exampleTranslation != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          card.exampleTranslation!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _EvaluationFeedback extends StatelessWidget {
  final EvaluationResult evaluation;

  const _EvaluationFeedback({required this.evaluation});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (evaluation.status) {
      EvaluationStatus.exactMatch => (AppTheme.successColor, Icons.check_circle),
      EvaluationStatus.almostCorrect => (AppTheme.accentColor, Icons.warning_amber),
      EvaluationStatus.incorrect => (AppTheme.errorColor, Icons.cancel),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              evaluation.feedbackMessage ?? '',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingButtonsRow extends StatelessWidget {
  final String cardId;

  const _RatingButtonsRow({required this.cardId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
              side: const BorderSide(color: AppTheme.errorColor),
            ),
            onPressed: () => context.read<SrsBloc>().add(RateCurrentCardEvent(
                  cardId: cardId,
                  rating: 1,
                )),
            child: const Text('Повторить\n(Again)', textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              side: const BorderSide(color: AppTheme.accentColor),
            ),
            onPressed: () => context.read<SrsBloc>().add(RateCurrentCardEvent(
                  cardId: cardId,
                  rating: 2,
                )),
            child: const Text('Трудно\n(Hard)', textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            onPressed: () => context.read<SrsBloc>().add(RateCurrentCardEvent(
                  cardId: cardId,
                  rating: 3,
                )),
            child: const Text('Хорошо\n(Good)', textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            onPressed: () => context.read<SrsBloc>().add(RateCurrentCardEvent(
                  cardId: cardId,
                  rating: 4,
                )),
            child: const Text('Легко\n(Easy)', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
