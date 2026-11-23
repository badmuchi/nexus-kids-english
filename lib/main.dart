import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/audio/hybrid_audio_playback_service.dart';
import 'core/audio/just_audio_playback_service.dart';
import 'core/audio/tts_speech_service.dart';
import 'core/database/app_database.dart';
import 'core/logging/app_logger.dart';
import 'core/settings/app_settings_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/badges/data/repositories/drift_badges_repository.dart';
import 'features/badges/domain/repositories/badges_repository.dart';
import 'features/badges/presentation/badges_bloc.dart';
import 'features/badges/presentation/badges_event.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/goals/data/repositories/drift_goals_repository.dart';
import 'features/goals/domain/repositories/goals_repository.dart';
import 'features/goals/presentation/goals_bloc.dart';
import 'features/goals/presentation/goals_event.dart';
import 'features/ib_myp/data/repositories/drift_ib_repository.dart';
import 'features/ib_myp/domain/repositories/ib_repository.dart';
import 'features/ib_myp/presentation/ib_bloc.dart';
import 'features/ib_myp/presentation/ib_event.dart';
import 'features/listening_lab/data/repositories/local_listening_lab_repository.dart';
import 'features/listening_lab/domain/repositories/listening_lab_repository.dart';
import 'features/listening_lab/presentation/listening_lab_bloc.dart';
import 'features/mascot_wardrobe/data/repositories/local_mascot_wardrobe_repository.dart';
import 'features/mascot_wardrobe/domain/repositories/mascot_wardrobe_repository.dart';
import 'features/mascot_wardrobe/presentation/mascot_wardrobe_bloc.dart';
import 'features/mascot_wardrobe/presentation/mascot_wardrobe_event.dart';
import 'features/oge_exam/data/repositories/drift_oge_exam_repository.dart';
import 'features/oge_exam/domain/repositories/oge_exam_repository.dart';
import 'features/oge_exam/presentation/oge_exam_bloc.dart';
import 'features/oge_trainer/data/repositories/drift_oge_repository.dart';
import 'features/oge_trainer/domain/repositories/oge_repository.dart';
import 'features/oge_trainer/presentation/oge_bloc.dart';
import 'features/sentence_builder/data/repositories/local_sentence_builder_repository.dart';
import 'features/sentence_builder/domain/repositories/sentence_builder_repository.dart';
import 'features/sentence_builder/presentation/sentence_builder_bloc.dart';
import 'features/srs/data/repositories/drift_srs_repository.dart';
import 'features/srs/domain/repositories/srs_repository.dart';
import 'features/srs/presentation/srs_bloc.dart';
import 'features/verbs_arena/data/repositories/local_verbs_repository.dart';
import 'features/verbs_arena/domain/repositories/verbs_repository.dart';
import 'features/verbs_arena/presentation/verbs_bloc.dart';
import 'features/vpr/data/repositories/local_vpr_repository.dart';
import 'features/vpr/domain/repositories/vpr_repository.dart';
import 'features/vpr/presentation/vpr_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = DeveloperAppLogger();
  final settingsStorage = SecureAppSettingsStorage(logger: logger);
  final database = AppDatabase();

  // Populate initial seeds if empty
  await database.seedDatabaseIfEmpty();

  final justAudio = JustAudioPlaybackService(logger: logger);
  final tts = FlutterTtsSpeechService(logger: logger);
  final audioService = HybridAudioPlaybackService(
    primaryAudioService: justAudio,
    ttsService: tts,
    logger: logger,
  );

  final initialAccent = await settingsStorage.readVoiceAccent();
  await audioService.setVoiceAccent(initialAccent);

  final ogeRepository = DriftOgeRepository(database);
  final ibRepository = DriftIbRepository(database);
  final srsRepository = DriftSrsRepository(database);
  final goalsRepository = DriftGoalsRepository(database);
  final badgesRepository = DriftBadgesRepository(database);
  final examRepository = DriftOgeExamRepository(database);
  final vprRepository = LocalVprRepository();
  final verbsRepository = LocalVerbsRepository();
  final sentenceRepository = LocalSentenceBuilderRepository();
  final listeningLabRepository = LocalListeningLabRepository();
  final wardrobeRepository = LocalMascotWardrobeRepository();

  runApp(
    MyApp(
      database: database,
      settingsStorage: settingsStorage,
      audioService: audioService,
      ogeRepository: ogeRepository,
      ibRepository: ibRepository,
      srsRepository: srsRepository,
      goalsRepository: goalsRepository,
      badgesRepository: badgesRepository,
      examRepository: examRepository,
      vprRepository: vprRepository,
      verbsRepository: verbsRepository,
      sentenceRepository: sentenceRepository,
      listeningLabRepository: listeningLabRepository,
      wardrobeRepository: wardrobeRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final AppSettingsStorage settingsStorage;
  final HybridAudioPlaybackService audioService;
  final OgeRepository ogeRepository;
  final IbRepository ibRepository;
  final SrsRepository srsRepository;
  final GoalsRepository goalsRepository;
  final BadgesRepository badgesRepository;
  final OgeExamRepository examRepository;
  final VprRepository vprRepository;
  final VerbsRepository verbsRepository;
  final SentenceBuilderRepository sentenceRepository;
  final ListeningLabRepository listeningLabRepository;
  final MascotWardrobeRepository wardrobeRepository;

  const MyApp({
    super.key,
    required this.database,
    required this.settingsStorage,
    required this.audioService,
    required this.ogeRepository,
    required this.ibRepository,
    required this.srsRepository,
    required this.goalsRepository,
    required this.badgesRepository,
    required this.examRepository,
    required this.vprRepository,
    required this.verbsRepository,
    required this.sentenceRepository,
    required this.listeningLabRepository,
    required this.wardrobeRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: database),
        RepositoryProvider<AppSettingsStorage>.value(value: settingsStorage),
        RepositoryProvider<HybridAudioPlaybackService>.value(value: audioService),
        RepositoryProvider<OgeRepository>.value(value: ogeRepository),
        RepositoryProvider<IbRepository>.value(value: ibRepository),
        RepositoryProvider<SrsRepository>.value(value: srsRepository),
        RepositoryProvider<GoalsRepository>.value(value: goalsRepository),
        RepositoryProvider<BadgesRepository>.value(value: badgesRepository),
        RepositoryProvider<OgeExamRepository>.value(value: examRepository),
        RepositoryProvider<VprRepository>.value(value: vprRepository),
        RepositoryProvider<VerbsRepository>.value(value: verbsRepository),
        RepositoryProvider<SentenceBuilderRepository>.value(value: sentenceRepository),
        RepositoryProvider<ListeningLabRepository>.value(value: listeningLabRepository),
        RepositoryProvider<MascotWardrobeRepository>.value(value: wardrobeRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GoalsBloc>(
            create: (_) => GoalsBloc(repository: goalsRepository)..add(const LoadGoalsEvent()),
          ),
          BlocProvider<BadgesBloc>(
            create: (_) => BadgesBloc(repository: badgesRepository)..add(const LoadBadgesEvent()),
          ),
          BlocProvider<OgeBloc>(
            create: (_) => OgeBloc(repository: ogeRepository),
          ),
          BlocProvider<IbBloc>(
            create: (_) => IbBloc(repository: ibRepository)..add(const LoadIbUnitsEvent()),
          ),
          BlocProvider<SrsBloc>(
            create: (_) => SrsBloc(repository: srsRepository),
          ),
          BlocProvider<OgeExamBloc>(
            create: (_) => OgeExamBloc(repository: examRepository),
          ),
          BlocProvider<VprBloc>(
            create: (_) => VprBloc(repository: vprRepository),
          ),
          BlocProvider<VerbsBloc>(
            create: (_) => VerbsBloc(repository: verbsRepository),
          ),
          BlocProvider<SentenceBuilderBloc>(
            create: (_) => SentenceBuilderBloc(repository: sentenceRepository),
          ),
          BlocProvider<ListeningLabBloc>(
            create: (_) => ListeningLabBloc(repository: listeningLabRepository),
          ),
          BlocProvider<MascotWardrobeBloc>(
            create: (_) => MascotWardrobeBloc(repository: wardrobeRepository)..add(const LoadWardrobeEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'English for Kids (5-7 Grade & IB)',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: DashboardScreen(
            audioService: audioService,
            settingsStorage: settingsStorage,
            examRepository: examRepository,
          ),
        ),
      ),
    );
  }
}
