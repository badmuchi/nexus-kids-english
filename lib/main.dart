import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/audio/hybrid_audio_playback_service.dart';
import 'core/audio/just_audio_playback_service.dart';
import 'core/audio/tts_speech_service.dart';
import 'core/database/app_database.dart';
import 'core/logging/app_logger.dart';
import 'core/settings/app_settings_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/goals/data/repositories/drift_goals_repository.dart';
import 'features/goals/domain/repositories/goals_repository.dart';
import 'features/goals/presentation/goals_bloc.dart';
import 'features/goals/presentation/goals_event.dart';
import 'features/ib_myp/data/repositories/drift_ib_repository.dart';
import 'features/ib_myp/domain/repositories/ib_repository.dart';
import 'features/ib_myp/presentation/ib_bloc.dart';
import 'features/ib_myp/presentation/ib_event.dart';
import 'features/oge_trainer/data/repositories/drift_oge_repository.dart';
import 'features/oge_trainer/domain/repositories/oge_repository.dart';
import 'features/oge_trainer/presentation/oge_bloc.dart';
import 'features/srs/data/repositories/drift_srs_repository.dart';
import 'features/srs/domain/repositories/srs_repository.dart';
import 'features/srs/presentation/srs_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = DeveloperAppLogger();
  final settingsStorage = SecureAppSettingsStorage(logger: logger);
  final database = AppDatabase();

  // Populate initial seeds if empty (OGE, IB, SRS, Goals)
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

  runApp(
    MyApp(
      database: database,
      settingsStorage: settingsStorage,
      audioService: audioService,
      ogeRepository: ogeRepository,
      ibRepository: ibRepository,
      srsRepository: srsRepository,
      goalsRepository: goalsRepository,
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

  const MyApp({
    super.key,
    required this.database,
    required this.settingsStorage,
    required this.audioService,
    required this.ogeRepository,
    required this.ibRepository,
    required this.srsRepository,
    required this.goalsRepository,
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GoalsBloc>(
            create: (_) => GoalsBloc(repository: goalsRepository)..add(const LoadGoalsEvent()),
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
        ],
        child: MaterialApp(
          title: 'English for Children • 13',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: DashboardScreen(
            audioService: audioService,
            settingsStorage: settingsStorage,
          ),
        ),
      ),
    );
  }
}
