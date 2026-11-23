import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/oge_exam_entity.dart';
import '../../domain/repositories/oge_exam_repository.dart';

class OgeReadingScreen extends StatefulWidget {
  final OgeExamRepository examRepository;

  const OgeReadingScreen({super.key, required this.examRepository});

  @override
  State<OgeReadingScreen> createState() => _OgeReadingScreenState();
}

class _OgeReadingScreenState extends State<OgeReadingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  List<ReadingHeadingParagraph> _paragraphs = [];
  List<Map<String, String>> _headings = [];
  List<ReadingTrueFalseItem> _trueFalseItems = [];

  final Map<String, String> _selectedHeadings = {};
  final Map<String, String> _selectedTfAnswers = {};
  bool _isSubmitted = false;
  String? _highlightedProof;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final pRes = await widget.examRepository.getReadingHeadingsParagraphs();
    final hRes = await widget.examRepository.getReadingHeadingsOptions();
    final tfRes = await widget.examRepository.getReadingTrueFalseItems();

    if (mounted) {
      setState(() {
        _paragraphs = pRes.getOrNull() ?? [];
        _headings = hRes.getOrNull() ?? [];
        _trueFalseItems = tfRes.getOrNull() ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('ОГЭ • Чтение (12–19)')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ОГЭ • Чтение (12–19)'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: '12. Заголовки (A–F)'),
            Tab(text: '13–19. True / False'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTask12Tab(),
          _buildTask13_19Tab(),
        ],
      ),
    );
  }

  Widget _buildTask12Tab() {
    return SingleChildScrollView(
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
                  const Text('Список заголовков (один лишний!):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._headings.map((h) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(h['text']!, style: const TextStyle(fontSize: 13)),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._paragraphs.map((p) => _buildParagraphCard(p)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => _isSubmitted = true),
            child: const Text('Проверить соответствие заголовков'),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraphCard(ReadingHeadingParagraph p) {
    final selected = _selectedHeadings[p.letter];
    final isCorrect = selected == p.correctHeadingId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Текст ${p.letter}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                DropdownButton<String>(
                  value: selected,
                  hint: const Text('Выбрать заголовок'),
                  items: _headings.map((h) {
                    return DropdownMenuItem(
                      value: h['id'],
                      child: Text(h['id']!.replaceAll('h', 'Заголовок ')),
                    );
                  }).toList(),
                  onChanged: _isSubmitted
                      ? null
                      : (val) {
                          setState(() => _selectedHeadings[p.letter] = val!);
                        },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(p.text, style: const TextStyle(fontSize: 14, height: 1.5)),
            if (_isSubmitted) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isCorrect
                        ? 'Верно!'
                        : 'Правильно: ${_headings.firstWhere((h) => h['id'] == p.correctHeadingId)['text']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTask13_19Tab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text block with proof highlighter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Текст: "Bioluminescence in Nature"', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(height: 16),
                  const Text(
                    "Bioluminescence is the production and emission of light by a living organism. It occurs widely in marine animals, ranging from tiny bacteria and jellyfish to deep-sea anglerfish. Unlike incandescent light bulbs that release over ninety percent of their energy as wasted heat, bioluminescence is 'cold light' with almost one hundred percent efficiency. In coastal waters of Puerto Rico, tourists kayak through bioluminescent bays where glowing plankton lights up the water like glowing stars whenever disturbed by oars. Some pharmaceutical labs study the luciferin enzyme from these organisms to design fluorescent markers for medical diagnostics. Marine conservationists actively work to restrict motorboat fuel leaks in these fragile lagoons to preserve the luminous plankton populations.",
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  if (_highlightedProof != null && _highlightedProof!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.accentColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppTheme.accentColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Доказательство в тексте: "$_highlightedProof"',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ..._trueFalseItems.map((q) => _buildTfItemCard(q)),
        ],
      ),
    );
  }

  Widget _buildTfItemCard(ReadingTrueFalseItem q) {
    final selected = _selectedTfAnswers[q.id];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.statement, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              children: ['TRUE', 'FALSE', 'NOT_STATED'].map((choice) {
                final isChosen = selected == choice;
                final isCorrect = q.correct == choice;

                Color color = Colors.grey.shade200;
                Color textColor = Colors.black87;
                if (_isSubmitted) {
                  if (isCorrect) {
                    color = AppTheme.successColor;
                    textColor = Colors.white;
                  } else if (isChosen) {
                    color = AppTheme.errorColor;
                    textColor = Colors.white;
                  }
                } else if (isChosen) {
                  color = AppTheme.primaryColor;
                  textColor = Colors.white;
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: textColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedTfAnswers[q.id] = choice;
                          _highlightedProof = q.proofSentence;
                        });
                      },
                      child: Text(choice, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_isSubmitted) ...[
              const SizedBox(height: 8),
              Text(q.explanation, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}
