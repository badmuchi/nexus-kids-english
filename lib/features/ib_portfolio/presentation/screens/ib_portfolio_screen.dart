import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/ib_portfolio_entity.dart';
import '../ib_portfolio_bloc.dart';
import '../ib_portfolio_event.dart';
import '../ib_portfolio_state.dart';

class IbPortfolioScreen extends StatefulWidget {
  const IbPortfolioScreen({super.key});

  @override
  State<IbPortfolioScreen> createState() => _IbPortfolioScreenState();
}

class _IbPortfolioScreenState extends State<IbPortfolioScreen> {
  @override
  void initState() {
    super.initState();
    context.read<IbPortfolioBloc>().add(const LoadIbPortfolio());
  }

  void _openAddSubmissionDialog() {
    final formKey = GlobalKey<FormState>();
    String unitTitle = 'Digital Footprint: Who Are We Online?';
    String criterion = 'Criterion D';
    String taskTitle = '';
    String content = '';
    int score = 7;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Добавить работу в портфолио'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: criterion,
                        decoration: const InputDecoration(labelText: 'Критерий IB'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Criterion A', child: Text('Criterion A: Listening / Audio')),
                          DropdownMenuItem(
                              value: 'Criterion B', child: Text('Criterion B: Reading / Analysis')),
                          DropdownMenuItem(
                              value: 'Criterion C', child: Text('Criterion C: Speaking / Interactive')),
                          DropdownMenuItem(
                              value: 'Criterion D', child: Text('Criterion D: Writing / Language')),
                        ],
                        onChanged: (v) => setDialogState(() => criterion = v!),
                      ),
                      TextFormField(
                        initialValue: unitTitle,
                        decoration: const InputDecoration(labelText: 'Название юнита'),
                        onSaved: (v) => unitTitle = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Тема работы / эссе'),
                        onSaved: (v) => taskTitle = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Текст эссе или монолога',
                          hintText: 'Paste written response or transcription...',
                        ),
                        onSaved: (v) => content = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? 'Заполните поле' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Оценка (из 8): '),
                          DropdownButton<int>(
                            value: score,
                            items: List.generate(8, (i) => i + 1)
                                .map((s) => DropdownMenuItem(value: s, child: Text('$s / 8')))
                                .toList(),
                            onChanged: (v) => setDialogState(() => score = v ?? 7),
                          ),
                        ],
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
                      context.read<IbPortfolioBloc>().add(
                            AddIbPortfolioSubmission(
                              unitId: 'unit_${DateTime.now().millisecondsSinceEpoch}',
                              unitTitle: unitTitle,
                              criterion: criterion,
                              taskTitle: taskTitle,
                              content: content,
                              scoreOutOf8: score,
                            ),
                          );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Сохранить в портфолио'),
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
        title: const Text('IB MYP Portfolio Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Добавить работу',
            onPressed: _openAddSubmissionDialog,
          ),
        ],
      ),
      body: BlocBuilder<IbPortfolioBloc, IbPortfolioState>(
        builder: (context, state) {
          if (state is IbPortfolioLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is IbPortfolioError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          if (state is IbPortfolioLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(state.summary),
                  const SizedBox(height: 16),
                  _buildCriteriaGrid(state.summary),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.folder_shared, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Работы в портфолио (${state.items.length})',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Добавить'),
                        onPressed: _openAddSubmissionDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (state.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'Портфолио пока пусто. Выполняй задания критериев A–D!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...state.items.map((item) => _buildPortfolioItemCard(item)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryCard(IbScoreSummary summary) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IB MYP Language Acquisition',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${summary.totalOutOf32} / 32 баллов',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary.ibGradeDescriptor,
                        style: const TextStyle(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${summary.ibFinalGrade}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaGrid(IbScoreSummary summary) {
    return Row(
      children: [
        _buildCriteriaBox('Criterion A', 'Слушание', summary.criterionA),
        const SizedBox(width: 8),
        _buildCriteriaBox('Criterion B', 'Чтение', summary.criterionB),
        const SizedBox(width: 8),
        _buildCriteriaBox('Criterion C', 'Говорение', summary.criterionC),
        const SizedBox(width: 8),
        _buildCriteriaBox('Criterion D', 'Письмо', summary.criterionD),
      ],
    );
  }

  Widget _buildCriteriaBox(String title, String subtitle, int score) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '$score/8',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItemCard(IbPortfolioEntity item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                    color: AppTheme.secondaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.criterion,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.unitTitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.scoreOutOf8} / 8',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.taskTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              item.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${item.createdAt.day.toString().padLeft(2, '0')}.${item.createdAt.month.toString().padLeft(2, '0')}.${item.createdAt.year}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
