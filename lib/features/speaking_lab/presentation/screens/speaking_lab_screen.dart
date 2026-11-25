import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/services/audio_recorder_service.dart';
import '../../domain/services/speaking_cliches_evaluator.dart';
import '../../domain/services/wpm_calculator.dart';
import '../widgets/audio_waveform_visualizer.dart';
import 'oge_speaking_exam_sim_screen.dart';

class SpeakingLabScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const SpeakingLabScreen({super.key, required this.audioService});

  @override
  State<SpeakingLabScreen> createState() => _SpeakingLabScreenState();
}

class _SpeakingLabScreenState extends State<SpeakingLabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final WpmCalculator _wpmCalculator = const WpmCalculator();
  final SpeakingClichesEvaluator _clichesEvaluator = const SpeakingClichesEvaluator();
  late final AudioRecorderService _recorderService;

  // Task 1: Reading Aloud
  static const String _task1Text =
      'The Arctic is one of the most mysterious and fragile ecosystems on our planet. Although the climate there is extremely cold and unforgiving, many animals have adapted to survive on thick ice and in freezing water. Polar bears, Arctic foxes, and seals hunt and live across this frozen desert. In recent decades, rising global temperatures have accelerated the melting of polar glaciers. Scientists from all continents study the Arctic to understand environmental changes and protect endangered species before the sea ice permanently disappears.';

  Timer? _readingTimer;
  int _readingElapsedSeconds = 0;
  bool _isReadingActive = false;
  WpmResult? _wpmResult;
  bool _isPlayingReference = false;
  bool _isPlayingUserRecording = false;

  // Task 2: Dialogue Questions (40s timer per question)
  final List<Map<String, String>> _dialogueQuestions = [
    {
      'q': 'What sport facilities do you have in your school, and how often do you use them?',
      'model':
          'We have a large modern gym and an outdoor football field at our school. I attend volleyball training twice a week and often play basketball with my classmates after lessons.',
    },
    {
      'q': 'Why do you think regular physical exercise is essential for teenagers?',
      'model':
          'Regular physical exercise helps teenagers relieve stress from academic exams, improves posture after long sitting hours, and builds stamina and team spirit.',
    },
    {
      'q': 'What kinds of sports are the most popular among teenagers in your hometown?',
      'model':
          'In my hometown, football and swimming are the most popular among teenagers. Many students also enjoy skateboarding and cycling in public parks during warm months.',
    },
    {
      'q': 'How much time do you personally spend outdoors on weekends?',
      'model':
          'On weekends, I usually spend around three or four hours outdoors. I enjoy walking in the local park with my dog or riding my bicycle with friends.',
    },
    {
      'q': 'What new hobby or sport would you like to try in the future, and why?',
      'model':
          'I would really love to take up rock climbing because it challenges both physical strength and analytical problem-solving skills.',
    },
    {
      'q': 'What advice would you give to a classmate who wants to stay fit and healthy?',
      'model':
          'I would advise them to walk at least ten thousand steps a day, drink enough water, and find a physical activity they genuinely enjoy doing.',
    },
  ];

  int _currentQuestionIndex = 0;
  Timer? _dialogueTimer;
  int _dialogueSecondsLeft = 40;
  bool _isDialogueRunning = false;
  final TextEditingController _dialogueAnswerController = TextEditingController();
  bool? _dialogueAnswerPass;
  String? _dialogueFeedback;

  // Task 3: Monologue
  final TextEditingController _monologueController = TextEditingController();
  MonologueEvaluationResult? _monologueResult;
  Timer? _prepTimer;
  int _prepSecondsLeft = 90; // 1.5 min prep
  bool _isPrepRunning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _recorderService = AudioRecorderService();
    _recorderService.stateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlayingUserRecording = state == RecordingState.playing;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _readingTimer?.cancel();
    _dialogueTimer?.cancel();
    _prepTimer?.cancel();
    _recorderService.dispose();
    _dialogueAnswerController.dispose();
    _monologueController.dispose();
    widget.audioService.stop();
    super.dispose();
  }

  // --- Task 1 Methods ---
  Future<void> _toggleReadingRecording() async {
    if (_isReadingActive) {
      _readingTimer?.cancel();
      await _recorderService.stopRecording();
      final wordCount = _task1Text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      setState(() {
        _isReadingActive = false;
        _wpmResult = _wpmCalculator.calculate(
          wordsCount: wordCount,
          durationSeconds: _readingElapsedSeconds,
        );
      });
    } else {
      await _recorderService.startRecording();
      setState(() {
        _isReadingActive = true;
        _readingElapsedSeconds = 0;
        _wpmResult = null;
      });
      _readingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          _readingElapsedSeconds++;
        });
      });
    }
  }

  Future<void> _playUserRecording() async {
    if (_isPlayingUserRecording) {
      await _recorderService.stopPlayback();
    } else {
      await widget.audioService.stop();
      setState(() => _isPlayingReference = false);
      await _recorderService.playRecording();
    }
  }

  Future<void> _playReferenceAudio() async {
    if (_isPlayingReference) {
      await widget.audioService.stop();
      if (!mounted) return;
      setState(() => _isPlayingReference = false);
    } else {
      await _recorderService.stopPlayback();
      setState(() => _isPlayingReference = true);
      await widget.audioService.speakText(_task1Text, language: 'en-US', rate: 0.95);
      if (!mounted) return;
      setState(() => _isPlayingReference = false);
    }
  }

  // --- Task 2 Methods ---
  void _startDialogueQuestionTimer() {
    _dialogueTimer?.cancel();
    setState(() {
      _dialogueSecondsLeft = 40;
      _isDialogueRunning = true;
      _dialogueAnswerPass = null;
      _dialogueFeedback = null;
      _dialogueAnswerController.clear();
    });

    final questionText = _dialogueQuestions[_currentQuestionIndex]['q']!;
    widget.audioService.speakText(questionText, language: 'en-US', rate: 0.95);

    _dialogueTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_dialogueSecondsLeft > 1) {
        setState(() => _dialogueSecondsLeft--);
      } else {
        timer.cancel();
        setState(() {
          _dialogueSecondsLeft = 0;
          _isDialogueRunning = false;
        });
        _evaluateDialogueAnswer();
      }
    });
  }

  void _evaluateDialogueAnswer() {
    final ans = _dialogueAnswerController.text;
    final isComplete = _clichesEvaluator.isDialogueAnswerComplete(ans);
    setState(() {
      _dialogueAnswerPass = isComplete;
      _dialogueFeedback = isComplete
          ? 'Ответ полный и развернутый (содержит 2+ предложения или 12+ слов). Зачтено (1 балл)!'
          : 'Ответ слишком короткий или неполный. На ОГЭ требуется дать полный ответ из минимум двух связных предложений.';
    });
  }

  // --- Task 3 Methods ---
  void _togglePrepTimer() {
    if (_isPrepRunning) {
      _prepTimer?.cancel();
      setState(() => _isPrepRunning = false);
    } else {
      setState(() {
        _isPrepRunning = true;
        _prepSecondsLeft = 90;
      });
      _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_prepSecondsLeft > 1) {
          setState(() => _prepSecondsLeft--);
        } else {
          timer.cancel();
          setState(() => _isPrepRunning = false);
        }
      });
    }
  }

  void _evaluateMonologue() {
    final result = _clichesEvaluator.evaluateMonologue(_monologueController.text);
    setState(() {
      _monologueResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Speaking Lab • Устная часть ОГЭ'),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppTheme.accentColor),
            icon: const Icon(Icons.flash_on, size: 18),
            label: const Text('Экзамен 15м', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OgeSpeakingExamSimScreen(audioService: widget.audioService),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          labelColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.record_voice_over), text: 'Задание 1: Чтение вслух'),
            Tab(icon: Icon(Icons.question_answer), text: 'Задание 2: Диалог (40с)'),
            Tab(icon: Icon(Icons.mic), text: 'Задание 3: Монолог & Клише'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTask1ReadingView(),
          _buildTask2DialogueView(),
          _buildTask3MonologueView(),
        ],
      ),
    );
  }

  // ---------------- UI: TASK 1 ----------------
  Widget _buildTask1ReadingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSimBanner(),
          const SizedBox(height: 14),
          Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Task 1 • Reading Aloud',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('Лимит: 2:00 мин', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Прочитай текст вслух в нормальном темпе. Стандарт ОГЭ ФИПИ: 100–120 слов/минуту. Доступно прямое сравнение своего голоса с диктором.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Text(
                      _task1Text,
                      style: TextStyle(fontSize: 16, height: 1.55, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AudioWaveformVisualizer(
                    amplitudeStream: _recorderService.amplitudeStream,
                    state: _recorderService.state,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isReadingActive ? Colors.redAccent : AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _toggleReadingRecording,
                        icon: Icon(_isReadingActive ? Icons.stop : Icons.mic),
                        label: Text(_isReadingActive
                            ? 'Стоп ($_readingElapsedSeconds с)'
                            : 'Записать свое чтение'),
                      ),
                      if (_recorderService.state == RecordingState.recorded ||
                          _recorderService.state == RecordingState.playing)
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green.shade800,
                            side: BorderSide(color: Colors.green.shade600),
                          ),
                          onPressed: _playUserRecording,
                          icon: Icon(_isPlayingUserRecording ? Icons.pause : Icons.play_arrow),
                          label: Text(_isPlayingUserRecording ? 'Пауза записи' : 'Слушать себя ($_readingElapsedSeconds с)'),
                        ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.secondaryColor,
                          side: const BorderSide(color: AppTheme.secondaryColor),
                        ),
                        onPressed: _playReferenceAudio,
                        icon: Icon(_isPlayingReference ? Icons.pause : Icons.volume_up),
                        label: Text(_isPlayingReference ? 'Остановить эталон' : 'Слушать диктора (US)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_wpmResult != null) _buildWpmResultCard(_wpmResult!),
        ],
      ),
    );
  }

  Widget _buildSimBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: AppTheme.accentColor, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Полный симулятор устного ОГЭ (non-stop)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Все 3 задания с реальными таймингами и звуковыми сигналами ФИПИ.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OgeSpeakingExamSimScreen(audioService: widget.audioService),
                ),
              );
            },
            child: const Text('Старт', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildWpmResultCard(WpmResult res) {
    Color badgeColor;
    String badgeText;
    switch (res.status) {
      case WpmPaceStatus.ideal:
        badgeColor = Colors.green;
        badgeText = 'Идеальный темп ОГЭ (90–130 WPM)';
        break;
      case WpmPaceStatus.tooSlow:
        badgeColor = Colors.amber.shade800;
        badgeText = 'Темп ниже нормы (<90 WPM)';
        break;
      case WpmPaceStatus.tooFast:
        badgeColor = Colors.deepOrange;
        badgeText = 'Темп выше нормы (>130 WPM)';
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: badgeColor.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: badgeColor, size: 28),
                const SizedBox(width: 8),
                Text(
                  '${res.wordsPerMinute} WPM (слов/мин)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: badgeColor),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Время чтения: ${res.durationSeconds} сек • Слов в тексте: ${res.wordsCount}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              res.recommendation,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI: TASK 2 ----------------
  Widget _buildTask2DialogueView() {
    final currentQ = _dialogueQuestions[_currentQuestionIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Вопрос ${_currentQuestionIndex + 1} из ${_dialogueQuestions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: _dialogueSecondsLeft <= 10 ? Colors.red : AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_dialogueSecondsLeft сек',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _dialogueSecondsLeft <= 10 ? Colors.red : AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _dialogueSecondsLeft / 40.0,
                    backgroundColor: Colors.grey.shade200,
                    color: _dialogueSecondsLeft <= 10 ? Colors.redAccent : AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Электронный ассистент спрашивает:',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"${currentQ['q']}"',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                        onPressed: _startDialogueQuestionTimer,
                        icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                        label: Text(_isDialogueRunning ? 'Перезапустить таймер' : 'Начать ответ (40с)',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Повторить аудио вопроса',
                        icon: const Icon(Icons.volume_up, color: AppTheme.secondaryColor),
                        onPressed: () {
                          widget.audioService.speakText(currentQ['q']!, language: 'en-US');
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Твой ответ (минимум 2 полных предложения):',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dialogueAnswerController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type or dictate your answer here in English...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: _evaluateDialogueAnswer,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('Проверить полноту', style: TextStyle(color: Colors.white)),
                      ),
                      const Spacer(),
                      if (_currentQuestionIndex < _dialogueQuestions.length - 1)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex++;
                              _dialogueAnswerController.clear();
                              _dialogueAnswerPass = null;
                              _dialogueFeedback = null;
                              _dialogueSecondsLeft = 40;
                              _dialogueTimer?.cancel();
                              _isDialogueRunning = false;
                            });
                          },
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Следующий вопрос'),
                        ),
                    ],
                  ),
                  if (_dialogueFeedback != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _dialogueAnswerPass == true
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _dialogueAnswerPass == true ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Text(
                        _dialogueFeedback!,
                        style: TextStyle(
                          color: _dialogueAnswerPass == true ? Colors.green.shade800 : Colors.brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text('Эталонный ответ (Model Answer)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(
                          currentQ['model']!,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.volume_up, size: 18),
                        label: const Text('Слушать эталон ответа'),
                        onPressed: () =>
                            widget.audioService.speakText(currentQ['model']!, language: 'en-US'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI: TASK 3 ----------------
  Widget _buildTask3MonologueView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Task 3 • Monologue (7 баллов)',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.alarm, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Подготовка: $_prepSecondsLeft с',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isPrepRunning ? Colors.deepOrange : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You are going to give a talk about your school. Remember to say:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• what your typical school weekday is like;'),
                  const Text('• what subjects you find most useful for your future, and why;'),
                  const Text('• what school traditions or events you enjoy participating in;'),
                  const Text('• what you would like to change or improve in your school.'),
                  const SizedBox(height: 8),
                  const Text(
                    'You have to talk continuously for 1.5–2 minutes (10–12 sentences).',
                    style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _togglePrepTimer,
                    icon: Icon(_isPrepRunning ? Icons.pause : Icons.timer),
                    label: Text(_isPrepRunning ? 'Пауза подготовки' : 'Таймер подготовки (1.5 мин)'),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Текст монолога (для проверки клише и связок):',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _monologueController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                          'I am going to give a talk about my school. Firstly, my typical school weekday begins at 8 AM...\n\nThat is all I wanted to say. Thank you for listening.',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _evaluateMonologue,
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('Проверить клише, связки и фразы'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_monologueResult != null) _buildMonologueResultCard(_monologueResult!),
        ],
      ),
    );
  }

  Widget _buildMonologueResultCard(MonologueEvaluationResult res) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: res.isPass ? Colors.green.withValues(alpha: 0.06) : Colors.orange.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  res.isPass ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: res.isPass ? Colors.green : Colors.orange,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Text(
                  res.isPass ? 'Критерии ОГЭ выполнены!' : 'Требуются исправления',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: res.isPass ? Colors.green.shade800 : Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildChecklistRow('Вступительное клише ("I am going to give a talk...")', res.hasIntro),
            _buildChecklistRow(
                'Заключительное клише ("That is all I wanted to say...")', res.hasConclusion),
            _buildChecklistRow('Слова-связки (минимум 2): ${res.detectedLinkers.join(', ')}',
                res.detectedLinkers.length >= 2),
            _buildChecklistRow('Объем речи: ${res.sentenceCount} фраз (норма 10–12)',
                res.sentenceCount >= 8),
            const SizedBox(height: 12),
            Text(
              res.feedback,
              style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistRow(String title, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.cancel,
            color: isChecked ? Colors.green : Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isChecked ? Colors.black87 : Colors.red.shade700,
                fontWeight: isChecked ? FontWeight.w500 : FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
