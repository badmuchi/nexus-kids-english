import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../srs/domain/services/english_answer_evaluator.dart';
import '../../domain/entities/vpr_task_entity.dart';
import '../vpr_bloc.dart';
import '../vpr_event.dart';
import '../vpr_state.dart';

class VprSimulatorScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const VprSimulatorScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<VprSimulatorScreen> createState() => _VprSimulatorScreenState();
}

class _VprSimulatorScreenState extends State<VprSimulatorScreen> {
  int _selectedGrade = 5;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    context.read<VprBloc>().add(LoadVprTasksEvent(grade: _selectedGrade));
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id) {
    return _controllers.putIfAbsent(id, () => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎒 Симулятор ВПР (5–7 классы)'),
      ),
      body: Column(
        children: [
          _buildGradeSelector(),
          Expanded(
            child: BlocBuilder<VprBloc, VprState>(
              builder: (context, state) {
                return switch (state) {
                  VprInitial() || VprLoading() => const Center(child: CircularProgressIndicator()),
                  VprErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
                  VprLoaded(tasks: final list, feedbacks: final fbs) => _buildTaskList(list, fbs),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [5, 6, 7].map((grade) {
          final isSelected = grade == _selectedGrade;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text('$grade класс', style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              selected: isSelected,
              selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
              onSelected: (val) {
                if (val) {
                  setState(() => _selectedGrade = grade);
                  context.read<VprBloc>().add(LoadVprTasksEvent(grade: grade));
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskList(List<VprTaskEntity> tasks, Map<String, EvaluationResult> feedbacks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('Задания пока не добавлены'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final feedback = feedbacks[task.id];
        return _buildTaskCard(task, feedback);
      },
    );
  }

  Widget _buildTaskCard(VprTaskEntity task, EvaluationResult? feedback) {
    final controller = _getController(task.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: task.isCompleted ? AppTheme.accentColor : Colors.grey.shade200,
          width: task.isCompleted ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(task.taskType.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                if (task.isCompleted)
                  const Icon(Icons.check_circle, color: AppTheme.accentColor, size: 22),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.instructions,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            if (task.textPassage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.textPassage!,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.audioService.speakText(task.textPassage!);
                      },
                      icon: const Icon(Icons.volume_up, size: 18),
                      label: const Text('Слушать текст (UK/US)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (task.options.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Варианты:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: task.options.map((opt) {
                  return ActionChip(
                    label: Text(opt),
                    onPressed: () {
                      controller.text = opt;
                      _checkAnswer(task, opt);
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Введи ответ...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _checkAnswer(task, controller.text),
                  child: const Text('Проверить'),
                ),
              ],
            ),
            if (feedback != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: feedback.isAccepted ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: feedback.isAccepted ? Colors.green.shade300 : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      feedback.isAccepted ? Icons.check_circle : Icons.info,
                      color: feedback.isAccepted ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feedback.feedbackMessage ??
                            (feedback.isAccepted ? 'Верно! Отличная работа! ⭐' : 'Попробуй еще раз!'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: feedback.isAccepted ? Colors.green.shade900 : Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (task.explanation != null) ...[
              const SizedBox(height: 8),
              Text(
                '💡 ${task.explanation!}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _checkAnswer(VprTaskEntity task, String answer) {
    if (answer.trim().isEmpty) return;
    context.read<VprBloc>().add(
          CheckVprAnswerEvent(
            taskId: task.id,
            userAnswer: answer,
            expectedAnswer: task.correctAnswer,
          ),
        );
  }
}
