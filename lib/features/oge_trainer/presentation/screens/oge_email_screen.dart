import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OgeEmailScreen extends StatefulWidget {
  const OgeEmailScreen({super.key});

  @override
  State<OgeEmailScreen> createState() => _OgeEmailScreenState();
}

class _OgeEmailScreenState extends State<OgeEmailScreen> {
  final _emailController = TextEditingController();
  int _wordCount = 0;
  bool _showSampleAnswer = false;

  final String _letterPrompt =
      "...In our school, they are launching new after-school clubs this semester, and I've decided to join the AI and robotics club. How do you usually spend your free time after classes? What sports or clubs are popular among your classmates, and why? What new hobby would you like to try in the future?...\n\nWrite an email to Ben. In your email:\n• Answer his 3 questions;\n• Ask 0 questions (in OGE you only answer questions);\n• Write 100–120 words (acceptable 90–132 words).";

  final String _sampleAnswer =
      "Dear Ben,\n\nThanks a lot for your email! It was great to hear from you again.\n\nIn your message you asked me about my free time. Usually after classes, I do my homework and then ride my bicycle or read sci-fi books in the park.\n\nAt our school, basketball and the chess club are very popular. My classmates love basketball because it keeps them energetic, while chess helps them improve logic and concentration.\n\nAs for a new hobby, in the future I would really love to try 3D graphic design, because I want to create my own indie video games one day.\n\nI need to do my project now. Write back soon!\n\nBest wishes,\nAlex";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = _emailController.text.trim();
    if (text.isEmpty) {
      setState(() => _wordCount = 0);
      return;
    }
    final words = text.split(RegExp(r'\s+'));
    setState(() => _wordCount = words.length);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCountValid = _wordCount >= 90 && _wordCount <= 132;
    final isTooShort = _wordCount > 0 && _wordCount < 90;
    final isTooLong = _wordCount > 132;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ОГЭ • Задание 35: Электронное письмо'),
        actions: [
          TextButton.icon(
            icon: Icon(
              _showSampleAnswer ? Icons.edit_note : Icons.visibility_outlined,
              color: AppTheme.primaryColor,
            ),
            label: Text(_showSampleAnswer ? 'Мой текст' : 'Эталон (10/10)'),
            onPressed: () => setState(() => _showSampleAnswer = !_showSampleAnswer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFFF1F5F9),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.mail_outline, color: AppTheme.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Письмо-стимул от друга Ben (UK):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _letterPrompt,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_showSampleAnswer) ...[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.successColor, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.successColor),
                          SizedBox(width: 8),
                          Text(
                            'Идеальный эталон ответа на максимум баллов:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _sampleAnswer,
                        style: const TextStyle(fontSize: 15, height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Объем эталона: 108 слов (идеально попадает в норматив 100-120 слов).',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Твой ответ:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCountValid
                          ? AppTheme.successColor.withValues(alpha: 0.1)
                          : (isTooShort || isTooLong
                              ? AppTheme.errorColor.withValues(alpha: 0.1)
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCountValid
                            ? AppTheme.successColor
                            : (isTooShort || isTooLong ? AppTheme.errorColor : Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      '$_wordCount / 100–120 слов',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCountValid
                            ? AppTheme.successColor
                            : (isTooShort || isTooLong ? AppTheme.errorColor : Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isTooShort)
                const Text(
                  '⚠️ Внимание: менее 90 слов на ОГЭ не проверяются (0 баллов)! Добавь подробностей.',
                  style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
                ),
              if (isTooLong)
                const Text(
                  '⚠️ Внимание: более 132 слов! Эксперт отсчитает ровно 120 слов, а концовка будет отрезана.',
                  style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                maxLines: 12,
                decoration: const InputDecoration(
                  hintText: 'Dear Ben,\n\nThanks for your email!...\n\nBest wishes,\nAlex',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Чек-лист критериев ОГЭ:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              _buildChecklistItem('1. Неформальное обращение (Dear Ben, / Hello Ben,) на отдельной строке.'),
              _buildChecklistItem('2. Благодарность за полученное письмо в начале.'),
              _buildChecklistItem('3. Полные развернутые ответы на ВСЕ 3 вопроса Бена.'),
              _buildChecklistItem('4. Ссылка на будущие контакты (Write back soon!).'),
              _buildChecklistItem('5. Прощальная фраза (Best wishes,) и только имя на новой строке БЕЗ точки.'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_box_outline_blank, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}
