import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:english_for_children/features/srs/domain/services/english_answer_evaluator.dart';
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

  TextEditingController _getController(String taskId) {
    return _controllers.putIfAbsent(taskId, () => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎒 Симулятор ВПР'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildGradeSelector(),
          Expanded(
            child: BlocBuilder<VprBloc, VprState>(
              builder: (context, state) {
                return switch (state) {
                  VprInitial() || VprLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  VprErrorState(message: final msg) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Ошибка: $msg',
                          style: const TextStyle(color: AppTheme.errorColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  VprLoaded() => _buildTasksList(context, state),
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Класс: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          for (final grade in [5, 6, 7]) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('$grade класс'),
                selected: _selectedGrade == grade,
                selectedColor: AppTheme.primaryColor.withAlpha(50),
                onSelected: (selected) {
                  if (selected && _selectedGrade != grade) {
                    setState(() {
                      _selectedGrade = grade;
                    });
                    context.read<VprBloc>().add(LoadVprTasksEvent(grade: grade));
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, VprLoaded state) {
    final completedCount = state.tasks.where((t) => t.isCompleted).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(completedCount, state.tasks.length),
        const SizedBox(height: 16),
        for (final task in state.tasks) ...[
          _buildTaskCard(context, task, state.feedbacks[task.id]),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Прогресс ВПР $_selectedGrade класс',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '$completed / $total выполнено',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    VprTaskEntity task,
    EvaluationResult? feedback,
  ) {
    final controller = _getController(task.id);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: task.isCompleted ? AppTheme.successColor : Colors.grey.shade200,
          width: task.isCompleted ? 2 : 1,
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.taskType.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.taskType.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (task.isCompleted)
                  const Chip(
                    backgroundColor: Color(0xFFDCFCE7),
                    label: Text(
                      'Решено 🎉',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 20),
            Text(
              task.instructions,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (task.textPassage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Текст задания:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor),
                          tooltip: 'Озвучить текст',
                          onPressed: () {
                            widget.audioService.speakText(task.textPassage!);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.textPassage!,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (task.taskType == VprTaskType.readingAloud) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<VprBloc>().add(
                        CheckVprAnswerEvent(
                          taskId: task.id,
                          userAnswer: 'fluent_read',
                          expectedAnswer: task.correctAnswer,
                        ),
                      );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Я прочитал(а) вслух! ✅'),
              ),
            ] else ...[
              if (task.options.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final opt in task.options) ...[
                      ActionChip(
                        label: Text(opt),
                        backgroundColor: controller.text == opt
                            ? AppTheme.primaryColor.withAlpha(40)
                            : Colors.grey.shade100,
                        onPressed: () {
                          controller.text = opt;
                          setState(() {});
                        },
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Введи ответ...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;
                      context.read<VprBloc>().add(
                            CheckVprAnswerEvent(
                              taskId: task.id,
                              userAnswer: controller.text.trim(),
                              expectedAnswer: task.correctAnswer,
                            ),
                          );
                    },
                    child: const Text('Проверить'),
                  ),
                ],
              ),
            ],
            if (feedback != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: feedback.isAccepted
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      feedback.isAccepted ? Icons.check_circle : Icons.error_outline,
                      color: feedback.isAccepted ? AppTheme.successColor : AppTheme.errorColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feedback.isAccepted
                                ? 'Отлично! Верный ответ! 🌟'
                                : 'Попробуй еще раз! (Ожидалось: ${feedback.expected})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: feedback.isAccepted
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                          if (task.explanation != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.explanation!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
