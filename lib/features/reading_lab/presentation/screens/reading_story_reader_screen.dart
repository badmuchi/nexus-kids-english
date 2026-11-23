import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/reading_story_entity.dart';
import '../reading_lab_bloc.dart';
import '../reading_lab_event.dart';

class ReadingStoryReaderScreen extends StatefulWidget {
  final ReadingStoryEntity story;
  final HybridAudioPlaybackService audioService;

  const ReadingStoryReaderScreen({
    super.key,
    required this.story,
    required this.audioService,
  });

  @override
  State<ReadingStoryReaderScreen> createState() => _ReadingStoryReaderScreenState();
}

class _ReadingStoryReaderScreenState extends State<ReadingStoryReaderScreen> {
  final Map<int, int> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Scaffold(
      appBar: AppBar(
        title: Text('${story.coverEmoji} ${story.title}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        backgroundColor: AppTheme.primaryColor.withAlpha(30),
                        label: Text(
                          '${story.grade} класс • ${story.theme}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Озвучить весь рассказ',
                        onPressed: () {
                          final fullText = story.paragraphs.join(' ');
                          widget.audioService.speakText(fullText);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    story.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    story.summary,
                    style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Story Paragraphs with per-paragraph audio
          const Text(
            '📖 Текст рассказа:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < story.paragraphs.length; i++) ...[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            story.paragraphs[i],
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor, size: 20),
                          tooltip: 'Озвучить абзац',
                          onPressed: () {
                            widget.audioService.speakText(story.paragraphs[i]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),

          // Vocabulary Glossary Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.menu_book, color: AppTheme.secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Словарик ключевых слов (Glossary):',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...story.glossary.map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 18, color: AppTheme.secondaryColor),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => widget.audioService.speakText(g.word),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            g.word,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            g.ipa,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const Text(' — '),
                          Expanded(
                            child: Text(
                              g.meaning,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reading Comprehension Quiz
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.quiz, color: AppTheme.accentColor),
                      SizedBox(width: 8),
                      Text(
                        'Тест на понимание текста (Quiz):',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (int qIdx = 0; qIdx < story.questions.length; qIdx++) ...[
                    _buildQuestionBlock(qIdx, story.questions[qIdx]),
                    const SizedBox(height: 16),
                  ],
                  if (!_quizSubmitted)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      onPressed: _selectedAnswers.length == story.questions.length
                          ? _submitQuiz
                          : null,
                      child: const Text('Проверить тест'),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Результат теста: $_score / ${story.questions.length} верно! 🎉',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBlock(int qIdx, ComprehensionQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${qIdx + 1}. ${q.question}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        for (int optIdx = 0; optIdx < q.options.length; optIdx++) ...[
          RadioListTile<int>(
            dense: true,
            title: Text(q.options[optIdx]),
            value: optIdx,
            groupValue: _selectedAnswers[qIdx],
            onChanged: _quizSubmitted
                ? null
                : (val) {
                    if (val != null) {
                      setState(() {
                        _selectedAnswers[qIdx] = val;
                      });
                    }
                  },
          ),
        ],
        if (_quizSubmitted) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _selectedAnswers[qIdx] == q.correctIndex
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _selectedAnswers[qIdx] == q.correctIndex ? Icons.check_circle : Icons.error,
                  color: _selectedAnswers[qIdx] == q.correctIndex
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    q.explanation,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _submitQuiz() {
    int score = 0;
    for (int i = 0; i < widget.story.questions.length; i++) {
      if (_selectedAnswers[i] == widget.story.questions[i].correctIndex) {
        score++;
      }
    }

    setState(() {
      _quizSubmitted = true;
      _score = score;
    });

    context.read<ReadingLabBloc>().add(
          SubmitStoryQuizScoreEvent(
            storyId: widget.story.id,
            score: score,
          ),
        );
  }
}
