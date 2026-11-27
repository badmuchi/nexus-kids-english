import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/audio/voice_recorder_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/exam_bridge_seed.dart';
import '../../domain/models/exam_bridge_models.dart';

class GlobalExamBridgeScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;

  const GlobalExamBridgeScreen({
    super.key,
    required this.audioService,
  });

  @override
  State<GlobalExamBridgeScreen> createState() => _GlobalExamBridgeScreenState();
}

class _GlobalExamBridgeScreenState extends State<GlobalExamBridgeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final KidVoiceRecorderService _recorder;

  int _passageIndex = 0;
  final Map<String, int> _readingAnswers = {};

  int _listeningIndex = 0;
  final Map<String, int> _listeningAnswers = {};
  bool _showTranscript = false;
  bool _isSpeakingAudio = false;

  InternationalExamTrack _speakingTrack = InternationalExamTrack.toefl;
  Timer? _speakingTimer;
  String _timerPhase = 'IDLE';
  int _secondsLeft = 0;

  InternationalExamTrack _writingTrack = InternationalExamTrack.toefl;
  final TextEditingController _writingController = TextEditingController();
  Timer? _writingTimer;
  int _writingSecondsLeft = 600;
  bool _writingTimerRunning = false;

  static const List<String> _academicConnectors = [
    'furthermore',
    'moreover',
    'however',
    'nevertheless',
    'consequently',
    'therefore',
    'on the one hand',
    'on the other hand',
    'for instance',
    'in conclusion',
    'whereas',
    'although',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _recorder = KidVoiceRecorderService(audioService: widget.audioService);
    _writingController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _speakingTimer?.cancel();
    _writingTimer?.cancel();
    _writingController.dispose();
    _recorder.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startSpeakingCycle(BridgeSpeakingPrompt prompt) {
    _speakingTimer?.cancel();
    _recorder.reset();
    setState(() {
      _timerPhase = 'PREP';
      _secondsLeft = prompt.prepSeconds;
    });

    _speakingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else if (_timerPhase == 'PREP') {
        _recorder.startRecording();
        setState(() {
          _timerPhase = 'SPEAK';
          _secondsLeft = prompt.speakSeconds;
        });
      } else {
        timer.cancel();
        _recorder.stopRecording();
        setState(() {
          _timerPhase = 'DONE';
          _secondsLeft = 0;
        });
      }
    });
  }

  void _stopSpeakingEarly() {
    _speakingTimer?.cancel();
    if (_recorder.status == VoiceRecorderStatus.recording) {
      _recorder.stopRecording();
    }
    setState(() {
      _timerPhase = 'DONE';
      _secondsLeft = 0;
    });
  }

  void _toggleWritingTimer(int defaultMinutes) {
    if (_writingTimerRunning) {
      _writingTimer?.cancel();
      setState(() => _writingTimerRunning = false);
      return;
    }
    if (_writingSecondsLeft <= 0) {
      _writingSecondsLeft = defaultMinutes * 60;
    }
    setState(() => _writingTimerRunning = true);
    _writingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_writingSecondsLeft > 0) {
        setState(() => _writingSecondsLeft--);
      } else {
        timer.cancel();
        setState(() => _writingTimerRunning = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOEFL & IELTS Bridge',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded), text: 'Reading'),
            Tab(icon: Icon(Icons.headphones_rounded), text: 'Listening'),
            Tab(icon: Icon(Icons.mic_rounded), text: 'Speaking'),
            Tab(icon: Icon(Icons.edit_note_rounded), text: 'Writing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReadingTab(),
          _buildListeningTab(),
          _buildSpeakingTab(),
          _buildWritingTab(),
        ],
      ),
    );
  }

  Widget _buildReadingTab() {
    final passage = ExamBridgeSeed.passages[_passageIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(ExamBridgeSeed.passages.length, (idx) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('Text ${idx + 1}'),
                  selected: idx == _passageIndex,
                  onSelected: (_) => setState(() => _passageIndex = idx),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      passage.topicTag,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    passage.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    passage.text,
                    style: const TextStyle(fontSize: 15, height: 1.55),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Academic Vocabulary:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: passage.keyVocabulary
                        .map(
                          (vocab) => Chip(
                            label: Text(vocab, style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(passage.questions.length, (qIdx) {
            final q = passage.questions[qIdx];
            final key = '${passage.id}_$qIdx';
            final chosen = _readingAnswers[key];
            final isToefl = q.format == InternationalExamTrack.toefl;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isToefl ? const Color(0xFF2563EB) : const Color(0xFFDC2626))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isToefl ? 'TOEFL Format' : 'IELTS T/F/NG',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isToefl ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.prompt,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(q.options.length, (optIdx) {
                      final isSelected = chosen == optIdx;
                      final isCorrect = optIdx == q.correctIndex;
                      Color? tileColor;
                      if (chosen != null) {
                        if (isCorrect) {
                          tileColor = Colors.green.withValues(alpha: 0.15);
                        } else if (isSelected) {
                          tileColor = Colors.red.withValues(alpha: 0.15);
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(q.options[optIdx]),
                          onTap: () => setState(() => _readingAnswers[key] = optIdx),
                        ),
                      );
                    }),
                    if (chosen != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          q.explanation,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildListeningTab() {
    final task = ExamBridgeSeed.listeningTasks[_listeningIndex];
    final chosen = _listeningAnswers[task.id];
    final isToefl = task.examType == InternationalExamTrack.toefl;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: List.generate(ExamBridgeSeed.listeningTasks.length, (idx) {
              final item = ExamBridgeSeed.listeningTasks[idx];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    item.examType == InternationalExamTrack.toefl
                        ? 'TOEFL (US Audio)'
                        : 'IELTS (UK Audio)',
                  ),
                  selected: idx == _listeningIndex,
                  onSelected: (_) {
                    widget.audioService.stop();
                    setState(() {
                      _listeningIndex = idx;
                      _showTranscript = false;
                      _isSpeakingAudio = false;
                    });
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.record_voice_over,
                        color: isToefl ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: Icon(_isSpeakingAudio ? Icons.stop : Icons.play_arrow_rounded),
                          label: Text(
                            _isSpeakingAudio
                                ? 'Остановить аудио'
                                : 'Слушать (${task.accentCode})',
                          ),
                          onPressed: () async {
                            if (_isSpeakingAudio) {
                              await widget.audioService.stop();
                              if (mounted) setState(() => _isSpeakingAudio = false);
                            } else {
                              setState(() => _isSpeakingAudio = true);
                              await widget.audioService.speakText(
                                task.transcript,
                                language: task.accentCode,
                              );
                              if (mounted) setState(() => _isSpeakingAudio = false);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () => setState(() => _showTranscript = !_showTranscript),
                        child: Text(_showTranscript ? 'Скрыть текст' : 'Транскрипт'),
                      ),
                    ],
                  ),
                  if (_showTranscript) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        task.transcript,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.question,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(task.options.length, (optIdx) {
                    final isSelected = chosen == optIdx;
                    final isCorrect = optIdx == task.correctIndex;
                    Color? bg;
                    if (chosen != null) {
                      if (isCorrect) bg = Colors.green.withValues(alpha: 0.15);
                      if (isSelected && !isCorrect) bg = Colors.red.withValues(alpha: 0.15);
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(task.options[optIdx]),
                        onTap: () => setState(() => _listeningAnswers[task.id] = optIdx),
                      ),
                    );
                  }),
                  if (chosen != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      task.rationale,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingTab() {
    final prompt = ExamBridgeSeed.speakingPrompts
        .firstWhere((e) => e.examType == _speakingTrack);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<InternationalExamTrack>(
            segments: const [
              ButtonSegment(
                value: InternationalExamTrack.toefl,
                label: Text('TOEFL (15s / 45s)'),
                icon: Icon(Icons.timer),
              ),
              ButtonSegment(
                value: InternationalExamTrack.ielts,
                label: Text('IELTS Cue Card (60s / 120s)'),
                icon: Icon(Icons.style),
              ),
            ],
            selected: {_speakingTrack},
            onSelectionChanged: (set) {
              _speakingTimer?.cancel();
              _recorder.reset();
              setState(() {
                _speakingTrack = set.first;
                _timerPhase = 'IDLE';
                _secondsLeft = 0;
              });
            },
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.topic,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prompt.prompt,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  ...prompt.bulletPoints.map(
                    (bp) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(bp, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            color: _timerPhase == 'SPEAK'
                ? Colors.red.withValues(alpha: 0.08)
                : _timerPhase == 'PREP'
                    ? Colors.amber.withValues(alpha: 0.12)
                    : null,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    _timerPhase == 'PREP'
                        ? 'ПОДГОТОВКА (ЗАМЕТКИ)'
                        : _timerPhase == 'SPEAK'
                            ? 'ЗАПИСЬ ОТВЕТА В МИКРОФОН'
                            : _timerPhase == 'DONE'
                                ? 'ОТВЕТ ЗАПИСАН'
                                : 'ГОТОВ К СТАРТУ',
                    style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _timerPhase == 'IDLE'
                        ? '${prompt.prepSeconds}s prep → ${prompt.speakSeconds}s speak'
                        : '$_secondsLeft сек',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.play_circle_fill),
                        label: Text(
                          _timerPhase == 'IDLE' ? 'Запустить таймер экзамена' : 'Перезапустить',
                        ),
                        onPressed: () => _startSpeakingCycle(prompt),
                      ),
                      if (_timerPhase == 'PREP' || _timerPhase == 'SPEAK')
                        OutlinedButton.icon(
                          icon: const Icon(Icons.stop),
                          label: const Text('Стоп'),
                          onPressed: _stopSpeakingEarly,
                        ),
                      if (_timerPhase == 'DONE')
                        OutlinedButton.icon(
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Прослушать'),
                          onPressed: () => _recorder.playRecording(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Клише высокого балла (Band 7+ / TOEFL 24+):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...prompt.usefulPhrases.map(
                    (phrase) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => widget.audioService.speakText(
                          phrase,
                          language: _speakingTrack == InternationalExamTrack.toefl
                              ? 'en-US'
                              : 'en-GB',
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volume_up_outlined, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                phrase,
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWritingTab() {
    final prompt = ExamBridgeSeed.writingPrompts
        .firstWhere((e) => e.examType == _writingTrack);

    final rawText = _writingController.text.trim();
    final words = rawText.isEmpty ? 0 : rawText.split(RegExp(r'\s+')).length;
    final lowerText = rawText.toLowerCase();
    final usedConnectors =
        _academicConnectors.where((c) => lowerText.contains(c)).toList();

    final minutes = (_writingSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_writingSecondsLeft % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<InternationalExamTrack>(
            segments: const [
              ButtonSegment(
                value: InternationalExamTrack.toefl,
                label: Text('TOEFL Discussion (100+ w)'),
              ),
              ButtonSegment(
                value: InternationalExamTrack.ielts,
                label: Text('IELTS Essay (150+ w)'),
              ),
            ],
            selected: {_writingTrack},
            onSelectionChanged: (set) {
              _writingTimer?.cancel();
              final next = set.first;
              final nextPrompt = ExamBridgeSeed.writingPrompts
                  .firstWhere((e) => e.examType == next);
              setState(() {
                _writingTrack = next;
                _writingTimerRunning = false;
                _writingSecondsLeft = nextPrompt.timerMinutes * 60;
              });
            },
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          prompt.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                      ActionChip(
                        avatar: Icon(
                          _writingTimerRunning ? Icons.pause : Icons.timer_outlined,
                          size: 18,
                        ),
                        label: Text('$minutes:$seconds'),
                        onPressed: () => _toggleWritingTimer(prompt.timerMinutes),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    prompt.scenario,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _writingController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write your structured response here...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Chip(
                avatar: Icon(
                  words >= prompt.targetWords ? Icons.check_circle : Icons.edit,
                  color: words >= prompt.targetWords ? Colors.green : null,
                  size: 18,
                ),
                label: Text('Слов: $words / ${prompt.targetWords}'),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('Связок: ${usedConnectors.length}'),
              ),
            ],
          ),
          if (usedConnectors.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: usedConnectors
                  .map(
                    (c) => Chip(
                      label: Text(c, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.green.withValues(alpha: 0.12),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Опорные фразы (нажми, чтобы вставить в текст):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  ...prompt.starterFrames.map(
                    (frame) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () {
                          final prefix = _writingController.text.isEmpty ||
                                  _writingController.text.endsWith(' ')
                              ? ''
                              : ' ';
                          _writingController.text =
                              '${_writingController.text}$prefix$frame ';
                        },
                        child: Text(
                          '+ $frame',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
