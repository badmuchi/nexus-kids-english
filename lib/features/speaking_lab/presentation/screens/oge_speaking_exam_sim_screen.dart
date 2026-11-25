import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/services/audio_recorder_service.dart';
import '../../domain/services/speaking_cliches_evaluator.dart';
import '../../domain/services/tone_sound_service.dart';
import '../../domain/services/wpm_calculator.dart';
import '../widgets/audio_waveform_visualizer.dart';

enum ExamPhase {
  intro,
  task1Prep, // 90s
  task1Record, // 120s
  task2Dialogue, // 6 x 40s
  task3Prep, // 90s
  task3Record, // 120s
  finished,
}

class OgeSpeakingExamSimScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const OgeSpeakingExamSimScreen({super.key, required this.audioService});

  @override
  State<OgeSpeakingExamSimScreen> createState() => _OgeSpeakingExamSimScreenState();
}

class _OgeSpeakingExamSimScreenState extends State<OgeSpeakingExamSimScreen> {
  final ToneSoundService _toneService = ToneSoundService();
  late final AudioRecorderService _recorderService;
  final WpmCalculator _wpmCalculator = const WpmCalculator();
  final SpeakingClichesEvaluator _clichesEvaluator = const SpeakingClichesEvaluator();

  ExamPhase _phase = ExamPhase.intro;
  Timer? _countdownTimer;
  int _secondsRemaining = 0;

  // Task 1 State
  static const String _task1Text =
      'The Baikal seal, also known as the nerpa, is one of the world\'s smallest true seals and the only pinniped species that lives exclusively in freshwater. These remarkable animals inhabit Lake Baikal in Siberia, the deepest and oldest lake on Earth. During the freezing winter months, nerpas keep breathing holes open in the ice using their powerful claws. Female seals give birth to snow-white pups in snow dens built on the frozen surface. Today, researchers monitor the nerpa population closely to protect their pristine freshwater ecosystem from industrial pollution.';
  int _task1Duration = 0;
  WpmResult? _task1Wpm;

  // Task 2 State
  final List<String> _dialogueQuestions = [
    'What sports or outdoor games are most popular among teenagers in your region?',
    'How many hours a week do you personally spend doing physical exercise or walking?',
    'What new sport or athletic activity would you like to take up in the future, and why?',
    'Why is it essential for teenagers to limit their daily screen time and exercise?',
    'What sporting event or competition held at your school was the most memorable for you?',
    'What practical advice would you give to a friend who wants to improve their stamina?',
  ];
  int _currentDialogueIndex = 0;
  final List<String> _dialogueAnswers = [];
  final TextEditingController _dialogueInputController = TextEditingController();

  // Task 3 State
  static const String _task3Topic = 'You are going to give a talk about healthy lifestyle.';
  static const List<String> _task3Bullets = [
    'why doing sports is crucial for modern teenagers;',
    'what healthy eating habits you personally follow;',
    'how quality sleep affects academic performance and mood;',
    'what attitude to physical health should be promoted in schools.',
  ];
  final TextEditingController _monologueController = TextEditingController();
  MonologueEvaluationResult? _monologueResult;

  // Scores
  int _task1Score = 2; // 0..2
  int _task2Score = 6; // 0..6
  int _task3Score = 7; // 0..7

  @override
  void initState() {
    super.initState();
    _toneService.init();
    _recorderService = AudioRecorderService(toneService: _toneService);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _toneService.dispose();
    _recorderService.dispose();
    _dialogueInputController.dispose();
    _monologueController.dispose();
    widget.audioService.stop();
    super.dispose();
  }

  void _startTimer({required int seconds, required VoidCallback onDone}) {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = seconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        onDone();
      }
    });
  }

  // --- Phase Transitions ---
  Future<void> _startExam() async {
    setState(() => _phase = ExamPhase.task1Prep);
    await _toneService.playExamChime();
    _startTimer(seconds: 90, onDone: _startTask1Recording);
  }

  Future<void> _startTask1Recording() async {
    await _toneService.playExamBeep();
    await _recorderService.startRecording();
    setState(() => _phase = ExamPhase.task1Record);
    _startTimer(
      seconds: 120,
      onDone: () => _finishTask1Recording(),
    );
  }

  Future<void> _finishTask1Recording() async {
    await _recorderService.stopRecording();
    await _toneService.playExamChime();

    _task1Duration = 120 - _secondsRemaining;
    if (_task1Duration <= 0) _task1Duration = 85;

    final wordCount = _task1Text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    _task1Wpm = _wpmCalculator.calculate(wordsCount: wordCount, durationSeconds: _task1Duration);
    _task1Score = _task1Wpm?.status == WpmPaceStatus.ideal ? 2 : 1;

    // Transition to Task 2
    setState(() {
      _phase = ExamPhase.task2Dialogue;
      _currentDialogueIndex = 0;
    });
    _startDialogueQuestion();
  }

  Future<void> _startDialogueQuestion() async {
    final q = _dialogueQuestions[_currentDialogueIndex];
    await widget.audioService.speakText(q, language: 'en-US');

    _startTimer(
      seconds: 40,
      onDone: () async {
        _dialogueAnswers.add(_dialogueInputController.text);
        _dialogueInputController.clear();

        if (_currentDialogueIndex < _dialogueQuestions.length - 1) {
          await _toneService.playExamBeep();
          setState(() => _currentDialogueIndex++);
          _startDialogueQuestion();
        } else {
          // Finished Task 2 -> Transition to Task 3 Prep
          await _toneService.playExamChime();
          _evaluateDialogueScore();
          setState(() => _phase = ExamPhase.task3Prep);
          _startTimer(seconds: 90, onDone: _startTask3Recording);
        }
      },
    );
  }

  void _evaluateDialogueScore() {
    int score = 0;
    for (final ans in _dialogueAnswers) {
      if (_clichesEvaluator.isDialogueAnswerComplete(ans)) {
        score++;
      }
    }
    _task2Score = score.clamp(0, 6);
  }

  Future<void> _startTask3Recording() async {
    await _toneService.playExamBeep();
    await _recorderService.startRecording();
    setState(() => _phase = ExamPhase.task3Record);
    _startTimer(seconds: 120, onDone: _finishExam);
  }

  Future<void> _finishExam() async {
    await _recorderService.stopRecording();
    await _toneService.playExamChime();

    final monoRes = _clichesEvaluator.evaluateMonologue(_monologueController.text);
    _monologueResult = monoRes;
    _task3Score = monoRes.isPass ? 7 : (monoRes.sentenceCount >= 6 ? 5 : 3);

    setState(() => _phase = ExamPhase.finished);
  }

  int get _totalScore => _task1Score + _task2Score + _task3Score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Полный симулятор устного ОГЭ'),
        actions: [
          if (_phase != ExamPhase.intro && _phase != ExamPhase.finished)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: switch (_phase) {
        ExamPhase.intro => _buildIntroView(),
        ExamPhase.task1Prep => _buildTask1PrepView(),
        ExamPhase.task1Record => _buildTask1RecordView(),
        ExamPhase.task2Dialogue => _buildTask2DialogueView(),
        ExamPhase.task3Prep => _buildTask3PrepView(),
        ExamPhase.task3Record => _buildTask3RecordView(),
        ExamPhase.finished => _buildFinishedView(),
      },
    );
  }

  Widget _buildIntroView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            color: AppTheme.primaryColor,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Экзаменационный тренажер ОГЭ (Регламент ФИПИ)',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Устная часть сдается на компьютере без экзаменатора-собеседника. Все задания идут строго друг за другом с официальными звуковыми сигналами.',
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildExamRuleItem('Задание 1: Чтение вслух', '1.5 мин подготовка → 2 мин чтение (2 балла)'),
          _buildExamRuleItem('Задание 2: Диалог-расспрос', '6 вопросов ассистента по 40 сек на каждый (6 баллов)'),
          _buildExamRuleItem('Задание 3: Монолог', '1.5 мин подготовка → 2 мин речь по плану (7 баллов)'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentColor),
            ),
            child: const Row(
              children: [
                Icon(Icons.volume_up, color: Colors.brown),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Включи звук! Симулятор использует звуковые гонги и бипы для смены этапов.',
                    style: TextStyle(fontSize: 13, color: Colors.brown, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.play_circle_fill),
            label: const Text('Начать симуляцию экзамена (15 минут)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            onPressed: _startExam,
          ),
        ],
      ),
    );
  }

  Widget _buildExamRuleItem(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEEF2FF),
          child: Icon(Icons.check, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ),
    );
  }

  Widget _buildTask1PrepView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner('Задание 1 • Подготовка к чтению', 'Осталось: $_secondsRemaining с (до звукового сигнала)'),
          const SizedBox(height: 16),
          _buildTextContainer(_task1Text),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _startTask1Recording,
            child: const Text('Готов читать раньше (пропустить таймер)'),
          ),
        ],
      ),
    );
  }

  Widget _buildTask1RecordView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner('Идет чтение текста вслух!', 'Запись активна • Лимит: $_secondsRemaining с', isAlert: true),
          const SizedBox(height: 16),
          AudioWaveformVisualizer(
            amplitudeStream: _recorderService.amplitudeStream,
            state: _recorderService.state,
          ),
          const SizedBox(height: 16),
          _buildTextContainer(_task1Text),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Закончил чтение текста', style: TextStyle(color: Colors.white)),
            onPressed: _finishTask1Recording,
          ),
        ],
      ),
    );
  }

  Widget _buildTask2DialogueView() {
    final currentQ = _dialogueQuestions[_currentDialogueIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner(
            'Задание 2 • Вопрос ${_currentDialogueIndex + 1} из 6',
            'Таймер ответа: $_secondsRemaining с',
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Электронный ассистент задает вопрос:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text('"$currentQ"', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: AppTheme.primaryColor),
                    tooltip: 'Повторить вопрос',
                    onPressed: () => widget.audioService.speakText(currentQ, language: 'en-US'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dialogueInputController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Твой устный ответ (проговори и введи конспект):',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTask3PrepView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner('Задание 3 • Подготовка монолога', 'Подготовка: $_secondsRemaining с'),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(_task3Topic, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('План обязательных пунктов:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ..._task3Bullets.map((b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $b', style: const TextStyle(fontSize: 14)),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _startTask3Recording,
            child: const Text('Готов говорить раньше (пропустить таймер)'),
          ),
        ],
      ),
    );
  }

  Widget _buildTask3RecordView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner('Идет запись монолога!', 'Говори в микрофон • Осталось: $_secondsRemaining с', isAlert: true),
          const SizedBox(height: 16),
          AudioWaveformVisualizer(
            amplitudeStream: _recorderService.amplitudeStream,
            state: _recorderService.state,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _monologueController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'I am going to give a talk about healthy lifestyle...\nThat is all I wanted to say. Thank you for listening.',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Завершить экзамен', style: TextStyle(color: Colors.white)),
            onPressed: _finishExam,
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedView() {
    final gradeMark = _totalScore >= 13 ? 5 : (_totalScore >= 10 ? 4 : (_totalScore >= 7 ? 3 : 2));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            color: AppTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.military_tech, size: 64, color: AppTheme.accentColor),
                  const SizedBox(height: 12),
                  const Text('Экзамен завершен!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Итоговый балл: $_totalScore / 15', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Прогнозируемая оценка: «$gradeMark»', style: const TextStyle(color: AppTheme.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildScoreRow('Задание 1: Чтение вслух', '$_task1Score / 2 балла', _task1Wpm?.recommendation ?? 'Норматив соблюден.'),
          _buildScoreRow('Задание 2: Диалог-расспрос', '$_task2Score / 6 баллов', 'Полных связных ответов: $_task2Score из 6.'),
          _buildScoreRow('Задание 3: Монолог', '$_task3Score / 7 баллов', _monologueResult?.feedback ?? 'Клише и объем проверены.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Вернуться в меню'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(String title, String subtitle, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isAlert ? Colors.redAccent.withValues(alpha: 0.12) : AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAlert ? Colors.redAccent : AppTheme.primaryColor),
      ),
      child: Row(
        children: [
          Icon(isAlert ? Icons.mic : Icons.timer, color: isAlert ? Colors.redAccent : AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isAlert ? Colors.red.shade900 : AppTheme.primaryColor)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }

  Widget _buildScoreRow(String title, String score, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(score, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
