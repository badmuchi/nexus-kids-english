import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';

class OgeSpeakingScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const OgeSpeakingScreen({super.key, required this.audioService});

  @override
  State<OgeSpeakingScreen> createState() => _OgeSpeakingScreenState();
}

class _OgeSpeakingScreenState extends State<OgeSpeakingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Task 1 timer
  Timer? _timer;
  int _secondsLeft = 90; // 1.5 minutes preparation
  bool _isTimerRunning = false;
  bool _isReadingPhase = false;

  final String _readingText =
      "The Arctic is one of the most mysterious and fragile ecosystems on our planet. Although the climate there is extremely cold and unforgiving, many animals have adapted to survive on thick ice and in freezing water. Polar bears, Arctic foxes, and seals hunt and live across this frozen desert. In recent decades, rising global temperatures have accelerated the melting of polar glaciers. Scientists from all continents study the Arctic to understand environmental changes and protect endangered species before the sea ice permanently disappears.";

  final List<Map<String, String>> _assistantQuestions = [
    {
      "q": "What is your favourite subject at school and why do you like it?",
      "a": "My favourite subject is Computer Science because I enjoy learning how to write algorithms and create mobile apps."
    },
    {
      "q": "How many hours a week do you usually spend on your homework?",
      "a": "I usually spend around ten to twelve hours a week doing my homework, which is about two hours every evening."
    },
    {
      "q": "What foreign languages can you speak, or which one would you like to learn?",
      "a": "I speak Russian fluently and study English at school. In the future, I would also like to learn Spanish or German."
    },
    {
      "q": "What school event or celebration was the most memorable for you this year?",
      "a": "The most memorable event was our annual Science Fair, where our team built a working model of a solar-powered car."
    },
    {
      "q": "Why is it important for teenagers to spend time outdoors every day?",
      "a": "Spending time outdoors helps teenagers reduce digital eye strain, get fresh air, and stay physically fit and energized."
    },
    {
      "q": "What advice would you give to a friend who wants to improve their English speaking skills?",
      "a": "I would advise them to watch films in original English with subtitles and practice speaking with friends or apps every day."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() => _isTimerRunning = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          timer.cancel();
          setState(() {
            _isTimerRunning = false;
            if (!_isReadingPhase) {
              _isReadingPhase = true;
              _secondsLeft = 120; // 2 minutes reading
            }
          });
        }
      });
      setState(() => _isTimerRunning = true);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isReadingPhase = false;
      _secondsLeft = 90;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ОГЭ • Устная часть (Говорение)'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: '1. Чтение вслух'),
            Tab(text: '2. Диалог-ассистент'),
            Tab(text: '3. Монолог'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTask1ReadingAloud(),
          _buildTask2DialogueAssistant(),
          _buildTask3Monologue(),
        ],
      ),
    );
  }

  Widget _buildTask1ReadingAloud() {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: _isReadingPhase ? AppTheme.successColor.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isReadingPhase ? 'ФАЗА ЧТЕНИЯ (2:00)' : 'ПОДГОТОВКА (1:30)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isReadingPhase ? AppTheme.successColor : AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeStr,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton.filled(
                        icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                        onPressed: _toggleTimer,
                      ),
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        icon: const Icon(Icons.refresh),
                        onPressed: _resetTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Текст для чтения:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor),
                        tooltip: 'Послушать эталонное чтение',
                        onPressed: () => widget.audioService.speakText(_readingText),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  SelectableText(
                    _readingText,
                    style: const TextStyle(fontSize: 16, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Фонетические подсказки:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          const Text('• Звуки [θ] и [ð] в словах "although", "there", "thick".'),
          const Text('• Не оглушать окончания звонких звуков: "ecosystems", "glaciers".'),
          const Text('• Паузы на знаках препинания и интонация перечисления.'),
        ],
      ),
    );
  }

  Widget _buildTask2DialogueAssistant() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _assistantQuestions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _assistantQuestions[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Вопрос ${index + 1} из 6 (40 сек)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.record_voice_over, color: AppTheme.primaryColor),
                      onPressed: () => widget.audioService.speakText(item['q']!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['q']!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Divider(height: 24),
                const Text(
                  'Пример идеального ответа (1-2 фразы):',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item['a']!,
                  style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTask3Monologue() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Тема: "School and Future Career"',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Требование: 10–12 связных фраз, 1.5 мин подготовка, до 2 мин ответ.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('План ответа (4 пункта):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPlanItem('1. Why getting a good education is important for modern teenagers;'),
                  _buildPlanItem('2. What school subjects you find most useful for your future job;'),
                  _buildPlanItem('3. Whether teenagers should have part-time jobs during holidays and why;'),
                  _buildPlanItem('4. What career or profession you are planning to choose in the future.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            color: Color(0xFFF8FAFC),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Структура и фразы-клише (для высшего балла):', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• Вступление: "I am going to give a talk about school and my future career."'),
                  Text('• Связки: "Firstly, ...", "Besides, ...", "As for me, ...", "To tell the truth, ..."'),
                  Text('• Заключение: "That is all I wanted to say. Thank you for listening."'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
