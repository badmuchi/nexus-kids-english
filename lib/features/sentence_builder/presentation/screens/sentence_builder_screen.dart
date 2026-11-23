import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../sentence_builder_bloc.dart';
import '../sentence_builder_event.dart';
import '../sentence_builder_state.dart';

class SentenceBuilderScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const SentenceBuilderScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<SentenceBuilderScreen> createState() => _SentenceBuilderScreenState();
}

class _SentenceBuilderScreenState extends State<SentenceBuilderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SentenceBuilderBloc>().add(const LoadSentencePuzzlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧩 Пазл предложений'),
      ),
      body: BlocConsumer<SentenceBuilderBloc, SentenceBuilderState>(
        listener: (context, state) {
          if (state is SentenceBuilderActive && state.isCorrect == true) {
            widget.audioService.speakText(state.currentPuzzle.correctSentence);
          }
        },
        builder: (context, state) {
          return switch (state) {
            SentenceBuilderInitial() || SentenceBuilderLoading() =>
              const Center(child: CircularProgressIndicator()),
            SentenceBuilderErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            SentenceBuilderActive() => _buildPuzzleBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildPuzzleBody(BuildContext context, SentenceBuilderActive state) {
    final puzzle = state.currentPuzzle;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${puzzle.grade} класс • ${puzzle.grammarTopic}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.secondaryColor),
                ),
              ),
              Text(
                '${state.currentIndex + 1} / ${state.puzzles.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Собери английскую фразу для перевода:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(
                    puzzle.translation,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Assembled sentence area
          const Text('Твое предложение (нажми на слово, чтобы убрать):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: state.isCorrect == null
                    ? Colors.grey.shade300
                    : (state.isCorrect! ? Colors.green : Colors.red),
                width: 2,
              ),
            ),
            child: state.selectedWords.isEmpty
                ? const Center(
                    child: Text('Нажимай на слова внизу, чтобы поставить их сюда', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.selectedWords.asMap().entries.map((entry) {
                      return ActionChip(
                        label: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                        onPressed: () {
                          context.read<SentenceBuilderBloc>().add(DeselectWordEvent(entry.key));
                        },
                      );
                    }).toList(),
                  ),
          ),
          if (state.feedbackMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: state.isCorrect! ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(state.isCorrect! ? Icons.check_circle : Icons.error, color: state.isCorrect! ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.feedbackMessage!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: state.isCorrect! ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          // Available word bank
          const Text('Банк слов:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.availableWords.map((word) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E293B),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<SentenceBuilderBloc>().add(SelectWordEvent(word));
                },
                child: Text(word, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: state.selectedWords.isEmpty
                      ? null
                      : () {
                          context.read<SentenceBuilderBloc>().add(const CheckSentenceEvent());
                        },
                  child: const Text('Проверить порядок'),
                ),
              ),
              if (state.isCorrect == true) ...[
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onPressed: () {
                    context.read<SentenceBuilderBloc>().add(const NextPuzzleEvent());
                  },
                  child: const Row(
                    children: [
                      Text('Дальше'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
