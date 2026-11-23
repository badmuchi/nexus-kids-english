import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../ib_portfolio/presentation/ib_portfolio_bloc.dart';
import '../../../ib_portfolio/presentation/ib_portfolio_state.dart';


class ParentTutorReportScreen extends StatelessWidget {
  const ParentTutorReportScreen({super.key});

  void _copyReportToClipboard(BuildContext context, {
    required int activeMistakesCount,
    required int resolvedMistakesCount,
    required int ibTotal,
    required int ibGrade,
  }) {
    final report = StringBuffer();
    report.writeln('📋 ОТЧЕТ ОБ УСПЕВАЕМОСТИ УЧЕНИКА (13 ЛЕТ • ENGLISH FOR CHILDREN)');
    report.writeln('Дата формирования: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}');
    report.writeln('');
    report.writeln('1. ПОДГОТОВКА К ОГЭ (7–9 КЛАССЫ):');
    report.writeln('   • Прогноз готовности: ~58/68 баллов (уверенная оценка «4», порог «5»)');
    report.writeln('   • Тетрадь ошибок: $activeMistakesCount на контроле, $resolvedMistakesCount успешно закреплено');
    report.writeln('   • Устная часть: темп чтения 110 WPM (норма 100–120), клише вступительные и финальные освоены');
    report.writeln('');
    report.writeln('2. ПРОГРАММА INTERNATIONAL BACCALAUREATE (IB MYP):');
    report.writeln('   • Итоговый балл: $ibTotal / 32');
    report.writeln('   • Текущая оценка IB: Grade $ibGrade (Very Good)');
    report.writeln('');
    report.writeln('3. РЕКОМЕНДАЦИИ К СЛЕДУЮЩЕМУ ЗАНЯТИЮ С РЕПЕТИТОРОМ:');
    report.writeln('   • Грамматика: закрепить Conditionals Type 2 и видо-временные формы Past Simple.');
    report.writeln('   • Устная часть: диалог-расспрос (Задание 2) — тренировка формулирования развернутых ответов за 40 сек.');
    report.writeln('   • IB эссе: расширить использование академических связок (consequently, furthermore).');

    Clipboard.setData(ClipboardData(text: report.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Отчет скопирован в буфер обмена! Готов для отправки в Telegram/WhatsApp.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчет для родителей и репетитора'),
      ),
      body: BlocBuilder<IbPortfolioBloc, IbPortfolioState>(
        builder: (context, ibState) {
          const int activeMistakes = 3;
          const int resolvedMistakes = 2;

          int ibTotal = 26;
          int ibGrade = 6;
          if (ibState is IbPortfolioLoaded) {
            ibTotal = ibState.summary.totalOutOf32;
            ibGrade = ibState.summary.ibFinalGrade;
          }

          return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroHeader(ibTotal: ibTotal, ibGrade: ibGrade),
                    const SizedBox(height: 16),
                    _buildKpiMetrics(
                      activeMistakes: activeMistakes,
                      resolvedMistakes: resolvedMistakes,
                      ibTotal: ibTotal,
                    ),
                    const SizedBox(height: 16),
                    _buildStrengthsCard(),
                    const SizedBox(height: 16),
                    _buildFocusAreasCard(),
                    const SizedBox(height: 16),
                    _buildTutorRecommendationsCard(),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.copy_all),
                      label: const Text(
                        'Скопировать табель для репетитора',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _copyReportToClipboard(
                        context,
                        activeMistakesCount: activeMistakes,
                        resolvedMistakesCount: resolvedMistakes,
                        ibTotal: ibTotal,
                        ibGrade: ibGrade,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget _buildHeroHeader({required int ibTotal, required int ibGrade}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.12),
                  child: const Icon(Icons.school, color: AppTheme.primaryColor, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сводный табель прогресса',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '13 лет • Программа 7–9 классов + IB MYP',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreBadge('Прогноз ОГЭ', '58 / 68 (Оценка 4/5)', Colors.indigo),
                _buildScoreBadge('IB MYP Phase 3/4', '$ibTotal/32 (Grade $ibGrade)', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildKpiMetrics({
    required int activeMistakes,
    required int resolvedMistakes,
    required int ibTotal,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            title: 'Темп речи',
            value: '110 WPM',
            subtitle: 'Идеал ФИПИ',
            color: Colors.green,
            icon: Icons.speed,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: 'Ошибок в работе',
            value: '$activeMistakes',
            subtitle: 'На контроле',
            color: Colors.deepOrange,
            icon: Icons.assignment_late,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricTile(
            title: 'Закреплено',
            value: '$resolvedMistakes',
            subtitle: '3/3 стрики 🔥',
            color: Colors.amber.shade800,
            icon: Icons.local_fire_department,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStrengthsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Сильные стороны (Strengths)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Text('• Задание 35 (Email): безошибочное соблюдение структуры и подсчета 100–120 слов.'),
            SizedBox(height: 4),
            Text('• Устная часть: быстрое включение с обязательными клише ОГЭ без запинок.'),
            SizedBox(height: 4),
            Text('• Словарный запас: высокая плотность связок (furthermore, in addition).'),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusAreasCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: Colors.deepOrange, size: 20),
                SizedBox(width: 8),
                Text('Зоны роста (Focus Areas)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Text('• Грамматика 20–28: различия Past Simple и Past Participle в неправильных глаголах.'),
            SizedBox(height: 4),
            Text('• Словообразование 29–34: выбор отрицательных приставок (im- vs un-).'),
            SizedBox(height: 4),
            Text('• Диалог 40 сек: раскрытие второго предложения без пауз раздумий.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorRecommendationsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      color: AppTheme.accentColor.withOpacity(0.08),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.brown, size: 20),
                SizedBox(width: 8),
                Text('План к следующему уроку с репетитором', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
              ],
            ),
            SizedBox(height: 10),
            Text('1. Блиц-разминка на 10 минут по Тетради ошибок (активные 3 карточки).'),
            SizedBox(height: 4),
            Text('2. Устный диалог: 6 вопросов ассистента с таймером 40 секунд на каждый.'),
            SizedBox(height: 4),
            Text('3. Обсуждение IB Global Context: этика искусственного интеллекта и авторские права.'),
          ],
        ),
      ),
    );
  }
}
