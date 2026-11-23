import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../core/settings/app_settings_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../../badges/presentation/badges_bloc.dart';
import '../../badges/presentation/badges_event.dart';
import '../../badges/presentation/screens/badges_screen.dart';
import '../../goals/presentation/goals_bloc.dart';
import '../../goals/presentation/goals_event.dart';
import '../../goals/presentation/goals_state.dart';
import '../../goals/presentation/screens/goals_screen.dart';
import '../../ib_myp/presentation/ib_bloc.dart';
import '../../ib_myp/presentation/ib_event.dart';
import '../../ib_myp/presentation/screens/ib_criterion_assessor_screen.dart';
import '../../ib_myp/presentation/screens/ib_units_screen.dart';
import '../../oge_exam/domain/repositories/oge_exam_repository.dart';
import '../../oge_exam/presentation/oge_exam_bloc.dart';
import '../../oge_exam/presentation/oge_exam_event.dart';
import '../../oge_exam/presentation/screens/oge_exam_simulator_screen.dart';
import '../../oge_exam/presentation/screens/oge_listening_screen.dart';
import '../../oge_exam/presentation/screens/oge_reading_screen.dart';
import '../../oge_trainer/presentation/oge_bloc.dart';
import '../../oge_trainer/presentation/oge_event.dart';
import '../../oge_trainer/presentation/screens/oge_email_screen.dart';
import '../../oge_trainer/presentation/screens/oge_grammar_screen.dart';
import '../../oge_trainer/presentation/screens/oge_speaking_screen.dart';
import '../../oge_trainer/presentation/screens/oge_word_formation_screen.dart';
import '../../srs/presentation/srs_bloc.dart';
import '../../srs/presentation/srs_event.dart';
import '../../srs/presentation/srs_screen.dart';
import '../../listening_lab/presentation/screens/minimal_pairs_screen.dart';
import '../../mascot_wardrobe/presentation/mascot_wardrobe_bloc.dart';
import '../../mascot_wardrobe/presentation/mascot_wardrobe_state.dart';
import '../../mascot_wardrobe/presentation/screens/achievements_screen.dart';
import '../../mascot_wardrobe/presentation/screens/mascot_wardrobe_screen.dart';
import '../../sentence_builder/presentation/screens/sentence_builder_screen.dart';
import '../../verbs_arena/presentation/screens/verbs_atlas_screen.dart';
import '../../verbs_arena/presentation/verbs_bloc.dart';
import '../../verbs_arena/presentation/verbs_event.dart';
import '../../vpr/presentation/screens/vpr_simulator_screen.dart';
import '../../vpr/presentation/vpr_bloc.dart';
import '../../vpr/presentation/vpr_event.dart';
import 'screens/exam_readiness_report_screen.dart';

class DashboardScreen extends StatefulWidget {
  final HybridAudioPlaybackService audioService;
  final AppSettingsStorage settingsStorage;
  final OgeExamRepository examRepository;

  const DashboardScreen({
    super.key,
    required this.audioService,
    required this.settingsStorage,
    required this.examRepository,
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
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined, color: AppTheme.accentColor),
            tooltip: 'Мои ачивки',
            onPressed: () {
              context.read<BadgesBloc>().add(const LoadBadgesEvent());
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BadgesScreen()),
              );
            },
          ),
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
            _buildHeroBanner(),
            const SizedBox(height: 16),
            _buildFullExamBanner(context),
            const SizedBox(height: 16),
            _buildReadinessCard(context),
            const SizedBox(height: 24),
            const Text(
              'Тренировочные разделы ОГЭ (7–9 класс):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOgeGrid(context),
            const SizedBox(height: 24),
            const Text(
              'Международный бакалавриат (IB MYP Phase 3/4):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildIbGrid(context),
            const SizedBox(height: 24),
            const Text(
              'Словарь и системные цели:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSystemGrid(context),
            const SizedBox(height: 20),
          ],
        ),
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
                    _buildPill('🔥 5 дней подряд', Colors.white.withValues(alpha: 0.2)),
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

  Widget _buildFullExamBanner(BuildContext context) {
    return Card(
      color: const Color(0xFF0F172A),
      child: InkWell(
        onTap: () {
          context.read<OgeExamBloc>().add(const StartFullExamEvent());
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OgeExamSimulatorScreen()),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_outlined, color: AppTheme.accentColor, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Полный симулятор экзамена ОГЭ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '120 минут • 68 баллов • Перевод в оценку 2–5',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill, color: AppTheme.accentColor, size: 36),
            ],
          ),
        ),
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

  Widget _buildReadinessCard(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        int percent = 62;
        if (state is GoalsLoaded && state.primaryGoal != null) {
          percent = state.primaryGoal!.progressPercent;
        }

        return Card(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExamReadinessReportScreen()),
              );
            },
            borderRadius: BorderRadius.circular(18),
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
                          'Нажми, чтобы открыть детальный аналитический отчет.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOgeGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Аудирование\nОГЭ (1–11)',
                subtitle: 'Диалоги и таблица фактов',
                icon: Icons.headphones,
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OgeListeningScreen(
                        audioService: widget.audioService,
                        examRepository: widget.examRepository,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionTile(
                context,
                title: 'Чтение текстов\nОГЭ (12–19)',
                subtitle: 'Заголовки и True/False',
                icon: Icons.menu_book,
                color: const Color(0xFF0D9488),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OgeReadingScreen(
                        examRepository: widget.examRepository,
                      ),
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
      ],
    );
  }

  Widget _buildIbGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionTile(
            context,
            title: 'IB MYP Units\nPhase 3/4',
            subtitle: 'Исследовательские темы',
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
            title: 'Критериальный\nАсессор (1–8)',
            subtitle: 'Рубрики & Анализ связок',
            icon: Icons.rule,
            color: const Color(0xFFD97706),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const IbCriterionAssessorScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSystemGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionTile(
            context,
            title: 'SRS Карточки\nЛексика & Аудио',
            subtitle: 'Интервалы FSRS',
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
        const SizedBox(width: 14),
        Expanded(
          child: _buildActionTile(
            context,
            title: 'Мои цели\nи привычки',
            subtitle: 'Рубеж 68/68 баллов',
            icon: Icons.track_changes,
            color: const Color(0xFF3B82F6),
            onTap: () {
              context.read<GoalsBloc>().add(const LoadGoalsEvent());
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GoalsScreen()),
              );
            },
          ),
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.25),
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
