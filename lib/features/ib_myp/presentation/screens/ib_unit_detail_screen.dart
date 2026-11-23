import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/ib_unit_entity.dart';
import '../ib_bloc.dart';
import '../ib_event.dart';

class IbUnitDetailScreen extends StatelessWidget {
  final IbInquiryUnitEntity unit;

  const IbUnitDetailScreen({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unit.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Statement of Inquiry Banner
            Card(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Statement of Inquiry:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      unit.statementOfInquiry,
                      style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text('Key: ${unit.keyConcept}'),
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                        ),
                        ...unit.relatedConcepts.map((c) => Chip(
                              label: Text(c),
                              backgroundColor: Colors.white,
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Inquiry Questions Section
            const Text(
              'Исследовательские вопросы (Inquiry Questions):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildQuestionCard('Factual (Фактологический):', unit.inquiryQuestions.factual, AppTheme.secondaryColor),
            const SizedBox(height: 8),
            _buildQuestionCard('Conceptual (Концептуальный):', unit.inquiryQuestions.conceptual, AppTheme.primaryColor),
            const SizedBox(height: 8),
            _buildQuestionCard('Debatable (Дискуссионный):', unit.inquiryQuestions.debatable, AppTheme.accentColor),
            const SizedBox(height: 24),
            // Criteria Tasks
            const Text(
              'Задания по 4 критериям оценки (Criteria A–D):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...unit.criteriaTasks.map((t) => _buildCriterionTaskCard(context, t)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String type, String question, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(question, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriterionTaskCard(BuildContext context, IbCriterionTaskEntity task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${task.criterion}: ${task.skill}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'макс. ${task.maxScore} баллов',
                    style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.taskTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(task.prompt, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Отметить как выполненное'),
                onPressed: () {
                  context.read<IbBloc>().add(CompleteIbTaskEvent(unit.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Критерий "${task.criterion}" зачтен!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
