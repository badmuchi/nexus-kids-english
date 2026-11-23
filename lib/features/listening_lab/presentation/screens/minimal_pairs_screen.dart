import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../listening_lab_bloc.dart';
import '../listening_lab_event.dart';
import '../listening_lab_state.dart';

class MinimalPairsScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const MinimalPairsScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<MinimalPairsScreen> createState() => _MinimalPairsScreenState();
}

class _MinimalPairsScreenState extends State<MinimalPairsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ListeningLabBloc>().add(const LoadMinimalPairsEvent());
  }

  void _playTargetWord(String word) {
    widget.audioService.speakText(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Minimal Pairs Lab'),
      ),
      body: BlocConsumer<ListeningLabBloc, ListeningLabState>(
        listener: (context, state) {
          if (state is ListeningLabActive && state.selectedChoice == null) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _playTargetWord(state.targetWord);
            });
          }
        },
        builder: (context, state) {
          return switch (state) {
            ListeningLabInitial() || ListeningLabLoading() =>
              const Center(child: CircularProgressIndicator()),
            ListeningLabErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            ListeningLabActive() => _buildActiveBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildActiveBody(BuildContext context, ListeningLabActive state) {
    final pair = state.currentPair;

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
                  color: AppTheme.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pair.soundFocus,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.accentColor),
                ),
              ),
              Text(
                'Счет: ${state.score} • Пара ${state.currentIndex + 1}/${state.pairs.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: InkWell(
              onTap: () => _playTargetWord(state.targetWord),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.volume_up, size: 50, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Нажми, чтобы послушать звук',
              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Какое слово прозвучало?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  context,
                  word: pair.wordA,
                  ipa: pair.ipaA,
                  meaning: pair.meaningA,
                  state: state,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildChoiceCard(
                  context,
                  word: pair.wordB,
                  ipa: pair.ipaB,
                  meaning: pair.meaningB,
                  state: state,
                ),
              ),
            ],
          ),
          if (state.selectedChoice != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.isCorrect! ? Icons.check_circle : Icons.info,
                        color: state.isCorrect! ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        state.isCorrect! ? 'Супер слух! Правильно!' : 'Было слово: ${state.targetWord}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state.isCorrect! ? Colors.green.shade900 : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('💡 Подсказка: ${pair.tip}', style: const TextStyle(fontSize: 13, height: 1.3)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.read<ListeningLabBloc>().add(const NextPairEvent());
              },
              child: const Text('Следующая пара слов ➔'),
            ),
          ] else ...[
            const Spacer(),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceCard(
    BuildContext context, {
    required String word,
    required String ipa,
    required String meaning,
    required ListeningLabActive state,
  }) {
    final isSelected = state.selectedChoice == word;
    final isTarget = state.targetWord == word;

    Color bg = Colors.white;
    Color border = Colors.grey.shade300;

    if (state.selectedChoice != null) {
      if (isTarget) {
        bg = Colors.green.shade50;
        border = Colors.green;
      } else if (isSelected) {
        bg = Colors.red.shade50;
        border = Colors.red;
      }
    }

    return InkWell(
      onTap: state.selectedChoice != null
          ? null
          : () {
              context.read<ListeningLabBloc>().add(SelectPairChoiceEvent(word));
            },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: isSelected || (state.selectedChoice != null && isTarget) ? 2.5 : 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              word,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Text(
              ipa,
              style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              meaning,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
