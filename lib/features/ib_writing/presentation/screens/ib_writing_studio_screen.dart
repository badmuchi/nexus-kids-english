import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:english_for_children/features/ib_myp/domain/services/cohesive_devices_analyzer.dart';
import '../ib_writing_bloc.dart';
import '../ib_writing_event.dart';
import '../ib_writing_state.dart';

class IbWritingStudioScreen extends StatefulWidget {
  const IbWritingStudioScreen({super.key});

  @override
  State<IbWritingStudioScreen> createState() => _IbWritingStudioScreenState();
}

class _IbWritingStudioScreenState extends State<IbWritingStudioScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _lastLoadedTaskId;

  @override
  void initState() {
    super.initState();
    context.read<IbWritingBloc>().add(const LoadIbWritingTasksEvent());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✍️ IB MYP Writing Studio'),
      ),
      body: BlocConsumer<IbWritingBloc, IbWritingState>(
        listener: (context, state) {
          if (state is IbWritingLoaded) {
            final task = state.currentTask;
            if (task != null && task.id != _lastLoadedTaskId) {
              _lastLoadedTaskId = task.id;
              _textController.text = state.currentText;
            }
          }
        },
        builder: (context, state) {
          return switch (state) {
            IbWritingInitial() || IbWritingLoading() =>
              const Center(child: CircularProgressIndicator()),
            IbWritingErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            IbWritingLoaded() => _buildLoadedBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildLoadedBody(BuildContext context, IbWritingLoaded state) {
    final task = state.currentTask;
    if (task == null) {
      return const Center(child: Text('Задания по письму не найдены'));
    }

    final analysis = state.analysis;
    final wordsCount = analysis?.wordCount ?? 0;
    final isWordCountOk = wordsCount >= task.minWords && wordsCount <= task.maxWords;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Task selection chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: state.tasks.map((t) {
              final isSelected = t.id == task.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('${t.format}: ${t.title}'),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor.withAlpha(50),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<IbWritingBloc>().add(SelectIbWritingTaskEvent(t.id));
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Brief Card
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
                    Chip(
                      backgroundColor: AppTheme.primaryColor.withAlpha(30),
                      label: Text(
                        task.format,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${task.minWords}–${task.maxWords} слов',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Global Context: ${task.globalContext}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
                const Divider(height: 20),
                Text(
                  task.instructions,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Чек-лист требований:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                ...task.requiredPrompts.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.secondaryColor),
                        const SizedBox(width: 6),
                        Expanded(child: Text(p, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Editor & Live Word Count
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
                      'Текст работы (Criterion D):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isWordCountOk
                            ? const Color(0xFFDCFCE7)
                            : (wordsCount < task.minWords ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$wordsCount слов (цель: ${task.minWords}-${task.maxWords})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isWordCountOk
                              ? AppTheme.successColor
                              : (wordsCount < task.minWords ? Colors.amber.shade900 : AppTheme.errorColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Пиши свой текст здесь на английском языке...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (text) {
                    context.read<IbWritingBloc>().add(
                          AnalyzeTextEvent(taskId: task.id, text: text),
                        );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _textController.text = task.sampleTemplate;
                        context.read<IbWritingBloc>().add(
                              AnalyzeTextEvent(taskId: task.id, text: task.sampleTemplate),
                            );
                      },
                      icon: const Icon(Icons.lightbulb_outline, size: 18),
                      label: const Text('Вставить шаблон'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final score = analysis?.cohesionScoreOutOf8 ?? 4.0;
                        context.read<IbWritingBloc>().add(
                              SaveWritingDraftEvent(
                                taskId: task.id,
                                text: _textController.text,
                                score: score,
                              ),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Черновик сохранен! Оценка связности: ${score.toStringAsFixed(1)}/8. +50 XP! 🎉',
                            ),
                          ),
                        );
                      },
                      child: const Text('Сохранить и оценить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Live Cohesive Devices Tracker
        if (analysis != null) ...[
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
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppTheme.accentColor),
                          SizedBox(width: 8),
                          Text(
                            'Анализатор связности текста:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Text(
                        '${analysis.cohesionScoreOutOf8.toStringAsFixed(1)} / 8 баллов',
                        style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Найдено связующих слов: ${analysis.foundDevices.length} (${analysis.uniqueCategoriesCount} категорий)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (analysis.foundDevices.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: analysis.foundDevices.map((d) {
                        return Chip(
                          backgroundColor: _getCategoryColor(d.category).withAlpha(40),
                          label: Text('${d.phrase} (${d.category.name})'),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      'Пока нет связующих слов. Попробуй добавить: however, furthermore, because, therefore.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  if (analysis.suggestions.isNotEmpty) ...[
                    const Divider(height: 20),
                    const Text(
                      '💡 Советы по улучшению (IB MYP):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    ...analysis.suggestions.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('• $s', style: const TextStyle(fontSize: 12)),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getCategoryColor(DeviceCategory cat) {
    return switch (cat) {
      DeviceCategory.addition => AppTheme.primaryColor,
      DeviceCategory.contrast => AppTheme.errorColor,
      DeviceCategory.causeEffect => AppTheme.secondaryColor,
      DeviceCategory.sequencing => AppTheme.accentColor,
      DeviceCategory.conclusion => AppTheme.successColor,
    };
  }
}
