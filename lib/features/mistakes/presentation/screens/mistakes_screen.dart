import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mistake_entity.dart';
import '../mistakes_bloc.dart';
import '../mistakes_event.dart';
import '../mistakes_state.dart';
import 'mistakes_blitz_screen.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key});

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  int _selectedFilter = 0; // 0: Активные, 1: Все, 2: Закрепленные

  @override
  void initState() {
    super.initState();
    context.read<MistakesBloc>().add(const LoadMistakes());
  }

  void _openAddMistakeDialog() {
    final formKey = GlobalKey<FormState>();
    String taskType = 'GRAMMAR';
    String prompt = '';
    String wrong = '';
    String correct = '';
    String explanation = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Зафиксировать ошибку'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: taskType,
                        decoration: const InputDecoration(labelText: 'Раздел'),
                        items: const [
                          DropdownMenuItem(value: 'GRAMMAR', child: Text('Грамматика 20–28')),
                          DropdownMenuItem(value: 'WORD_FORMATION', child: Text('Словообразование 29–34')),
                          DropdownMenuItem(value: 'LISTENING', child: Text('Аудирование')),
                          DropdownMenuItem(value: 'READING', child: Text('Чтение')),
                        ],
                        onChanged: (v) => setDialogState(() => taskType = v!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Предложение / Задание'),
                        onSaved: (v) => prompt = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Ошибочный ответ'),
                        onSaved: (v) => wrong = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Правильный ответ'),
                        onSaved: (v) => correct = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Объяснение правила'),
                        onSaved: (v) => explanation = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<MistakesBloc>().add(
                            AddManualMistake(
                              id: 'mst_manual_${DateTime.now().millisecondsSinceEpoch}',
                              taskType: taskType,
                              prompt: prompt,
                              wrongAnswer: wrong,
                              correctAnswer: correct,
                              explanation: explanation,
                            ),
                          );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умная тетрадь ошибок'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Добавить ошибку вручную',
            onPressed: _openAddMistakeDialog,
          ),
        ],
      ),
      body: BlocBuilder<MistakesBloc, MistakesState>(
        builder: (context, state) {
          if (state is MistakesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MistakesError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          if (state is MistakesLoaded) {
            final displayList = _getFilteredList(state);
            return Column(
              children: [
                _buildSummaryHeader(state),
                _buildFilterChips(),
                Expanded(
                  child: displayList.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done_all, size: 64, color: Colors.green),
                              SizedBox(height: 12),
                              Text(
                                'Нет ошибок в этой категории!',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (ctx, index) {
                            return _buildMistakeCard(displayList[index]);
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<MistakesBloc, MistakesState>(
        builder: (context, state) {
          if (state is MistakesLoaded && state.unresolvedMistakes.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.flash_on, color: Colors.black87),
                label: Text(
                  '⚡ Запустить Блиц-исправление (${state.unresolvedMistakes.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MistakesBlitzScreen(
                        mistakesToPractice: state.unresolvedMistakes,
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<MistakeEntity> _getFilteredList(MistakesLoaded state) {
    switch (_selectedFilter) {
      case 0:
        return state.unresolvedMistakes;
      case 1:
        return state.allMistakes;
      case 2:
        return state.allMistakes.where((m) => m.isResolved).toList();
      default:
        return state.unresolvedMistakes;
    }
  }

  Widget _buildSummaryHeader(MistakesLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.primaryColor.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem('На контроле', '${state.activeCount}', Colors.deepOrange),
          _buildMetricItem('Закреплено', '${state.resolvedCount}', Colors.green),
          _buildMetricItem('Всего', '${state.allMistakes.length}', AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('На контроле'),
            selected: _selectedFilter == 0,
            onSelected: (s) => setState(() => _selectedFilter = 0),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Все ошибки'),
            selected: _selectedFilter == 1,
            onSelected: (s) => setState(() => _selectedFilter = 1),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Закрепленные'),
            selected: _selectedFilter == 2,
            onSelected: (s) => setState(() => _selectedFilter = 2),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeCard(MistakeEntity m) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    m.taskType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (m.isResolved)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Закреплено (3/3 🔥)',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                  )
                else
                  Row(
                    children: [
                      const Text('Стрик: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('${m.masteryStreak}/3 🔥',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orange)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              m.prompt,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.close, color: Colors.red, size: 18),
                const SizedBox(width: 4),
                Text('Было: ${m.wrongAnswer}',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.check, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Text('Верно: ${m.correctAnswer}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      m.explanation,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
