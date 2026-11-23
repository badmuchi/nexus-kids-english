import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/services/cohesive_devices_analyzer.dart';

class IbCriterionAssessorScreen extends StatefulWidget {
  const IbCriterionAssessorScreen({super.key});

  @override
  State<IbCriterionAssessorScreen> createState() => _IbCriterionAssessorScreenState();
}

class _IbCriterionAssessorScreenState extends State<IbCriterionAssessorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _essayController = TextEditingController();
  final _analyzer = const CohesiveDevicesAnalyzer();
  WritingAnalysisResult? _analysis;

  List<dynamic> _rubrics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRubrics();
  }

  Future<void> _loadRubrics() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/ib_rubrics_seed.json');
      final list = jsonDecode(raw) as List;
      if (mounted) {
        setState(() {
          _rubrics = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _analyzeWriting() {
    final res = _analyzer.analyze(_essayController.text);
    setState(() => _analysis = res);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _essayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IB MYP • Критериальный асессор (1–8)'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Дескрипторы Criteria A–D'),
            Tab(text: 'Анализатор связок (Criterion D)'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRubricsTab(),
                _buildAnalyzerTab(),
              ],
            ),
    );
  }

  Widget _buildRubricsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _rubrics.length,
      itemBuilder: (context, index) {
        final item = _rubrics[index];
        final list = item['rubrics'] as List;

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['criterion'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Макс: 8 баллов', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
                const Divider(height: 20),
                ...list.map((r) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            r['levels'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            r['descriptor'],
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyzerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Анализ письменной речи (Criterion D)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Введи свой текст или эссе, чтобы проверить связующие конструкции (Cohesive Devices) и получить прогнозируемый балл IB.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _essayController,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'In our modern society, digital devices play a crucial role. Furthermore, they allow teenagers to connect globally. However, excessive screen time can cause fatigue. Consequently, we need mindful balance...',
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Запустить лингвистический анализ'),
            onPressed: _analyzeWriting,
          ),
          if (_analysis != null) ...[
            const SizedBox(height: 24),
            Card(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${_analysis!.cohesionScoreOutOf8.toInt()}/8',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Прогноз балла по Criterion D',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Слов: ${_analysis!.wordCount} • Абзацев: ${_analysis!.paragraphCount} • Категорий связок: ${_analysis!.uniqueCategoriesCount}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Найденные связующие конструкции:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_analysis!.foundDevices.isEmpty)
              const Text('Связки не обнаружены. Попробуй добавить however, furthermore, therefore.', style: TextStyle(color: Colors.grey))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _analysis!.foundDevices.map((d) {
                  return Chip(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    label: Text(d.phrase, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
              ),
            if (_analysis!.suggestions.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Рекомендации для повышения до 7–8 баллов:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._analysis!.suggestions.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, size: 16, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s, style: const TextStyle(fontSize: 13, height: 1.35))),
                      ],
                    ),
                  )),
            ],
          ],
        ],
      ),
    );
  }
}
