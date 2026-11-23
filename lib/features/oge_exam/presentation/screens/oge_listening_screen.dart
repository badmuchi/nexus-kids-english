import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/oge_exam_entity.dart';
import '../../domain/repositories/oge_exam_repository.dart';

class OgeListeningScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;
  final OgeExamRepository examRepository;

  const OgeListeningScreen({
    super.key,
    required this.audioService,
    required this.examRepository,
  });

  @override
  State<OgeListeningScreen> createState() => _OgeListeningScreenState();
}

class _OgeListeningScreenState extends State<OgeListeningScreen> {
  bool _isLoading = true;
  List<ListeningQuestionItem> _tasks1_4 = [];
  List<ListeningTableField> _tableFields = [];
  final Map<String, int> _selectedAnswers = {};
  final Map<String, String> _typedTableAnswers = {};
  bool _isSubmitted = false;

  final String _audioScript =
      "Dialogue A: Good morning! Can I see your passport and boarding pass, please? Sure, here you are. Do you have any luggage to check in, or just this carry-on backpack? Just the backpack. Perfect, your gate is B14. Dialogue B: Two tickets for the 3D showing of Galaxy Explorers, please. Row 7 in the middle is available. Would you like some large popcorn and drinks with that? Dialogue C: Excuse me, where can I find science fiction novels and dictionaries? Go straight to the second floor, next to the study desks. Dialogue D: Doctor, my dog hasn't eaten anything since yesterday and seems very tired. Let me examine his paws and temperature first.";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res1 = await widget.examRepository.getListeningTasks1_4();
    final res2 = await widget.examRepository.getListeningTableTasks6_11();

    if (mounted) {
      setState(() {
        _tasks1_4 = res1.getOrNull() ?? [];
        _tableFields = res2.getOrNull() ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('ОГЭ • Аудирование 1–11')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ОГЭ • Аудирование 1–11'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Audio player header
            Card(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.volume_up, size: 28),
                      onPressed: () => widget.audioService.speakText(_audioScript),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Аудиозапись ОГЭ (Диалоги 1–4)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Нажми на кнопку, чтобы прослушать диалоги в оригинальной озвучке.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Задания 1–4: Выберите правильный вариант',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._tasks1_4.map((q) => _buildQuestionCard(q)),
            const SizedBox(height: 24),
            const Text(
              'Задания 6–11: Заполнение таблицы фактов (Интервью)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTableSection(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() => _isSubmitted = true);
              },
              child: const Text('Проверить все ответы раздела'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(ListeningQuestionItem q) {
    final selected = _selectedAnswers[q.id];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.question,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (idx) {
              final isChosen = selected == idx;
              final isCorrect = q.correctIndex == idx;

              Color? tileColor;
              if (_isSubmitted) {
                if (isCorrect) tileColor = AppTheme.successColor.withValues(alpha: 0.15);
                if (isChosen && !isCorrect) tileColor = AppTheme.errorColor.withValues(alpha: 0.15);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: tileColor ?? (isChosen ? AppTheme.primaryColor.withValues(alpha: 0.08) : null),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isChosen ? AppTheme.primaryColor : Colors.grey.shade300,
                  ),
                ),
                child: RadioListTile<int>(
                  value: idx,
                  groupValue: selected,
                  title: Text(q.options[idx]),
                  activeColor: AppTheme.primaryColor,
                  onChanged: _isSubmitted
                      ? null
                      : (val) {
                          setState(() => _selectedAnswers[q.id] = val!);
                        },
                ),
              );
            }),
            if (_isSubmitted) ...[
              const SizedBox(height: 8),
              Text(
                q.explanation,
                style: const TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _tableFields.map((f) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(f.field, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      enabled: !_isSubmitted,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ответ...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        suffixIcon: _isSubmitted
                            ? const Icon(Icons.check_circle, color: AppTheme.successColor, size: 20)
                            : null,
                      ),
                      onChanged: (val) => _typedTableAnswers[f.id] = val,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
