import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../core/settings/app_settings_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../goals/presentation/goals_bloc.dart';
import '../../goals/presentation/goals_event.dart';
import '../../goals/presentation/goals_state.dart';
import '../../goals/presentation/screens/goals_screen.dart';
import '../../ib_myp/presentation/ib_bloc.dart';
import '../../ib_myp/presentation/ib_event.dart';
import '../../ib_myp/presentation/screens/ib_units_screen.dart';
import '../../oge_trainer/presentation/oge_bloc.dart';
import '../../oge_trainer/presentation/oge_event.dart';
import '../../oge_trainer/presentation/screens/oge_email_screen.dart';
import '../../oge_trainer/presentation/screens/oge_grammar_screen.dart';
import '../../oge_trainer/presentation/screens/oge_speaking_screen.dart';
import '../../oge_trainer/presentation/screens/oge_word_formation_screen.dart';
import '../../srs/presentation/srs_bloc.dart';
import '../../srs/presentation/srs_event.dart';
import '../../srs/presentation/srs_screen.dart';
import '../../vpr/presentation/screens/vpr_simulator_screen.dart';
import '../../vpr/presentation/vpr_bloc.dart';
import '../../vpr/presentation/vpr_event.dart';

class DashboardScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;

  const DashboardScreen({
    super.key,
    required this.audioService,
    required this.settingsStorage,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentAccent = 'en-US';

  @override
  void initState() {
    super.initState();
    _loadAccent();
  }

  Future<void> _loadAccent() async {
    final accent = await widget.settingsStorage.readVoiceAccent();
    setState(() => _currentAccent = accent);
  }

  Future<void> _toggleAccent() async {
    final newAccent = _currentAccent == 'en-US' ? 'en-GB' : 'en-US';
    await widget.settingsStorage.writeVoiceAccent(newAccent);
    await widget.audioService.setVoiceAccent(newAccent);
    setState(() => _currentAccent = newAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'English Master • 13',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            icon: Icon(
              _currentAccent == 'en-US' ? Icons.flag : Icons.flag_outlined,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            label: Text(
              _currentAccent == 'en-US' ? 'US Accent' : 'UK Accent',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            onPressed: _toggleAccent,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMascotCard(),
            const SizedBox(height: 16),
            _buildHeroBanner(),
            const SizedBox(height: 20),
            _buildReadinessCard(),
            const SizedBox(height: 24),
            const Text(
              'Учебные модули (ВПР 5–7 + ОГЭ + IB MYP):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildGridTiles(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              widget.audioService.speakText('Awesome job! Keep practicing and you will master English like a champion!');
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFE52E71)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8A00).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(child: Text('🦊', style: TextStyle(fontSize: 28))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Лисёнок Спарки',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Наставник',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Привет! Жми на меня для бодрой озвучки или выбирай задания ВПР (5-7 класс) ниже!',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Привет! Готовимся к максимуму 🚀',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ОГЭ 7–9 класс + Международный бакалавриат (IB MYP).',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPill('🔥 5 дней ударно', Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(width: 8),
                    _buildPill('🎯 15 мин/день', Colors.white.withValues(alpha: 0.2)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, size: 40, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildReadinessCard() {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        int percent = 62;
        if (state is GoalsLoaded && state.primaryGoal != null) {
          percent = state.primaryGoal!.progressPercent;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: percent / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Готовность к ОГЭ: 68/68 баллов',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Грамматика и лексика закрыты на 70%, активна фаза IB 3/4.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridTiles(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(
          context,
          title: '🎒 Симулятор ВПР (5–7 классы)',
          subtitle: 'Чтение текста вслух, аудирование (True/False/Not Stated), matching и грамматика',
          icon: Icons.school,
          color: const Color(0xFF4F46E5),
          onTap: () {
            context.read<VprBloc>().add(const LoadVprTasksEvent(grade: 5));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VprSimulatorScreen(audioService: widget.audioService),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Грамматика\nОГЭ (20–28)',
                subtitle: 'Времена, пассив, условные',
                icon: Icons.edit_note,
                color: AppTheme.primaryColor,
                onTap: () {
                  context.read<OgeBloc>().add(const LoadOgeGrammarTasksEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OgeGrammarScreen(audioService: widget.audioService),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Словообразование\nОГЭ (29–34)',
                subtitle: 'Суффиксы и приставки',
                icon: Icons.build_outlined,
                color: AppTheme.secondaryColor,
                onTap: () {
                  context.read<OgeBloc>().add(const LoadOgeWordFormationTasksEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OgeWordFormationScreen(audioService: widget.audioService),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Email Другу\nЗадание 35',
                subtitle: 'Счетчик 100-120 слов',
                icon: Icons.mark_email_read_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OgeEmailScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Устная часть\nГоворение 1–3',
                subtitle: 'Чтение, диалог, монолог',
                icon: Icons.record_voice_over_outlined,
                color: AppTheme.accentColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OgeSpeakingScreen(audioService: widget.audioService),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'IB MYP Units\nPhase 3/4',
                subtitle: 'Критерии A, B, C, D',
                icon: Icons.public,
                color: const Color(0xFF059669),
                onTap: () {
                  context.read<IbBloc>().add(const LoadIbUnitsEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const IbUnitsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'SRS Карточки\nЛексика & Аудио',
                subtitle: 'Умные интервалы FSRS',
                icon: Icons.view_carousel_outlined,
                color: const Color(0xFFEC4899),
                onTap: () {
                  context.read<SrsBloc>().add(const LoadDueCardsEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SrsScreen(audioService: widget.audioService),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildActionTile(
          context,
          title: 'Мои цели и трекер подготовки',
          subtitle: 'Управление целями, расписание экзаменов и ежедневная привычка',
          icon: Icons.track_changes,
          color: const Color(0xFF3B82F6),
          onTap: () {
            context.read<GoalsBloc>().add(const LoadGoalsEvent());
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GoalsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.25),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
