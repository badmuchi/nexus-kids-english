import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ExamReadinessReportScreen extends StatelessWidget {
  const ExamReadinessReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчет о готовности к ОГЭ и IB'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Студент: 13 лет (7–9 класс)',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Прогноз ОГЭ: 62 / 68 баллов (Оценка: 5)',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'IB MYP Language Acquisition: Phase 3/4 (Proficient)',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Разбивка по разделам ОГЭ (ФИПИ):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSectionProgress('1. Аудирование (Задания 1–11)', 13, 15, AppTheme.primaryColor),
            _buildSectionProgress('2. Чтение (Задания 12–19)', 12, 13, AppTheme.secondaryColor),
            _buildSectionProgress('3. Грамматика и лексика (20–34)', 14, 15, const Color(0xFF10B981)),
            _buildSectionProgress('4. Электронное письмо (35)', 10, 10, const Color(0xFF8B5CF6)),
            _buildSectionProgress('5. Устная часть (1–3)', 13, 15, AppTheme.accentColor),
            const SizedBox(height: 24),
            const Text(
              'Критерии IB MYP (Criteria A–D):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSectionProgress('Criterion A: Listening (Аудирование)', 6, 8, AppTheme.primaryColor),
            _buildSectionProgress('Criterion B: Reading (Чтение мультимодальных текстов)', 7, 8, AppTheme.secondaryColor),
            _buildSectionProgress('Criterion C: Speaking (Устная интеракция)', 6, 8, const Color(0xFF10B981)),
            _buildSectionProgress('Criterion D: Writing (Письменная речь и связки)', 7, 8, const Color(0xFF8B5CF6)),
            const SizedBox(height: 24),
            const Card(
              color: Color(0xFFF8FAFC),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: AppTheme.accentColor),
                        SizedBox(width: 8),
                        Text('Рекомендация репетитора / ИИ-куратора:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Подросток демонстрирует твердый уровень B1. Основное внимание перед экзаменом рекомендуется уделить точности соблюдения тайминга в устной части (диалог-расспрос без пауз дольше 5 сек) и закреплению отрицательных приставок un-/dis-/im- в блоке словообразования.',
                      style: TextStyle(fontSize: 13, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionProgress(String title, int current, int max, Color color) {
    final frac = current / max;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                Text('$current / $max', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: frac,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }
}
