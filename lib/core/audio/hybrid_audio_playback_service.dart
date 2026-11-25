import 'dart:async';
import '../logging/app_logger.dart';
import 'audio_playback_service.dart';
import 'just_audio_playback_service.dart';
import 'tts_speech_service.dart';

class HybridAudioPlaybackService implements AudioPlaybackService {
  final JustAudioPlaybackService _primaryAudioService;
  final TtsSpeechService _ttsService;
  final AppLogger _logger;

  final _playingController = StreamController<bool>.broadcast();
  bool _isPlaying = false;
  String _currentAccent = 'en-US';
  double _playbackSpeed = 1.0;

  HybridAudioPlaybackService({
    required JustAudioPlaybackService primaryAudioService,
    required TtsSpeechService ttsService,
    required AppLogger logger,
  })  : _primaryAudioService = primaryAudioService,
        _ttsService = ttsService,
        _logger = logger {
    _primaryAudioService.isPlayingStream.listen((playing) {
      _setPlaying(playing);
    });
  }

  void _setPlaying(bool val) {
    if (_isPlaying != val) {
      _isPlaying = val;
      _playingController.add(val);
    }
  }

  void handleTtsComplete() {
    _setPlaying(false);
  }

  void handleTtsError(String msg) {
    _setPlaying(false);
    _logger.warning('Audio', 'TTS playback error: $msg');
  }

  @override
  Stream<bool> get isPlayingStream => _playingController.stream;

  @override
  Future<void> playAudio(String source, {bool isAsset = false, String? fallbackText}) async {
    await stop();
    _setPlaying(true);
    bool success = false;
    try {
      if (isAsset) {
        success = await _primaryAudioService.playAsset(source);
      } else {
        success = await _primaryAudioService.playUrl(source);
      }
    } catch (e, st) {
      _logger.warning('Audio', 'Failed to play $source, will try fallback', e, st);
    }

    if (!success && fallbackText != null && fallbackText.isNotEmpty) {
      _logger.info('Audio', 'Asset playback fallback to natural TTS: $fallbackText');
      await speakText(fallbackText);
    }
  }

  @override
  Future<void> speakText(String text, {String? language, double? rate}) async {
    await stop();
    _setPlaying(true);
    final lang = language ?? _currentAccent;
    final speed = rate ?? _playbackSpeed;
    await _ttsService.speak(text, language: lang, rate: speed);
  }

  @override
  Future<void> stop() async {
    await _primaryAudioService.stop();
    await _ttsService.stop();
    _setPlaying(false);
  }

  @override
  Future<void> pause() async {
    await _primaryAudioService.pause();
    await _ttsService.stop();
    _setPlaying(false);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _primaryAudioService.setSpeed(speed);
    await _ttsService.setSpeechRate(speed);
  }

  @override
  Future<void> setVoiceAccent(String languageCode) async {
    _currentAccent = languageCode;
    await _ttsService.setLanguage(languageCode);
  }

  Future<void> playVictorySound() async {
    try {
      await speakText('Awesome! Victory! You are a champion!', rate: 1.05);
    } catch (_) {}
  }

  Future<void> playBadgeEarnedSound() async {
    try {
      await speakText('Badge unlocked! Incredible work!', rate: 1.05);
    } catch (_) {}
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _primaryAudioService.dispose();
    await _ttsService.dispose();
    await _playingController.close();
  }
}
