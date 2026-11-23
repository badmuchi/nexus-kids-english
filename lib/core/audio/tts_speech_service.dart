import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../logging/app_logger.dart';

abstract interface class TtsSpeechService {
  Future<void> speak(String text, {String? language, double? rate});
  Future<void> stop();
  Future<void> setLanguage(String languageCode);
  Future<void> setSpeechRate(double rate);
  Future<void> dispose();
}

class FlutterTtsSpeechService implements TtsSpeechService {
  final FlutterTts _flutterTts;
  final AppLogger _logger;
  final VoidCallback? _onComplete;
  final void Function(String message)? _onError;

  String _currentLanguage = 'en-US';
  double _userRate = 1.0;
  bool _voiceConfigured = false;

  static const _preferredUsVoices = [
    'Google US English',
    'Samantha (Enhanced)',
    'Samantha',
    'Ava (Enhanced)',
    'Ava',
    'Allison (Enhanced)',
    'Allison',
    'Alex',
    'Microsoft Jenny Online (Natural)',
    'Microsoft Aria Online (Natural)',
    'Microsoft Guy Online (Natural)',
    'Jenny',
    'Aria',
    'Guy',
    'en-US-JennyNeural',
  ];

  static const _preferredUkVoices = [
    'Google UK English Female',
    'Google UK English Male',
    'Daniel (Enhanced)',
    'Daniel',
    'Serena (Enhanced)',
    'Serena',
    'Oliver (Enhanced)',
    'Oliver',
    'Kate',
    'Microsoft Sonia Online (Natural)',
    'Microsoft Ryan Online (Natural)',
    'Sonia',
    'Ryan',
    'en-GB-SoniaNeural',
  ];

  static const _bannedRoboticVoices = {
    'albert',
    'bad news',
    'bahh',
    'bells',
    'boing',
    'bubbles',
    'cellos',
    'deranged',
    'fred',
    'good news',
    'hysterical',
    'jester',
    'junior',
    'organ',
    'pipe organ',
    'ralph',
    'trinoids',
    'whisper',
    'wobble',
    'zarvox',
    'agnes',
    'bruce',
    'kathy',
    'princess',
    'vicki',
    'victoria',
  };

  FlutterTtsSpeechService({
    FlutterTts? flutterTts,
    required AppLogger logger,
    VoidCallback? onComplete,
    void Function(String message)? onError,
  })  : _flutterTts = flutterTts ?? FlutterTts(),
        _logger = logger,
        _onComplete = onComplete,
        _onError = onError {
    unawaited(_initTts());
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _applySpeechRate(_userRate);
      await _configureBestVoice(_currentLanguage);

      _flutterTts.setCompletionHandler(() {
        _logger.debug('TTS', 'Speech completed');
        _onComplete?.call();
      });

      _flutterTts.setErrorHandler((dynamic message) {
        _logger.warning('TTS', 'Error during speech: $message');
        _onError?.call(message.toString());
      });
    } catch (e, st) {
      _logger.warning('TTS', 'Error initializing TTS voices', e, st);
    }
  }

  Future<void> _applySpeechRate(double rate) async {
    _userRate = rate;
    final calculated = kIsWeb ? rate : (rate * 0.5);
    await _flutterTts.setSpeechRate(calculated);
  }

  Future<void> _configureBestVoice(String languageCode) async {
    try {
      dynamic rawVoices = await _flutterTts.getVoices;
      int retries = 0;
      while (kIsWeb && (rawVoices is! List || rawVoices.isEmpty) && retries < 10) {
        retries++;
        await Future<void>.delayed(const Duration(milliseconds: 100));
        rawVoices = await _flutterTts.getVoices;
      }

      if (rawVoices is List && rawVoices.isNotEmpty) {
        final isUk = languageCode.toLowerCase().contains('gb') || languageCode.toLowerCase().contains('uk');
        final preferredList = isUk ? _preferredUkVoices : _preferredUsVoices;

        String? selectedVoiceName;
        String? selectedVoiceLocale;

        for (final pref in preferredList) {
          for (final voice in rawVoices) {
            final name = (voice is Map ? voice['name']?.toString() : voice.toString()) ?? '';
            final locale = (voice is Map ? voice['locale']?.toString() : null) ?? languageCode;
            if (name.toLowerCase() == pref.toLowerCase()) {
              selectedVoiceName = name;
              selectedVoiceLocale = locale;
              break;
            }
          }
          if (selectedVoiceName != null) break;
        }

        if (selectedVoiceName == null) {
          for (final voice in rawVoices) {
            final name = (voice is Map ? voice['name']?.toString() : voice.toString()) ?? '';
            final locale = (voice is Map ? voice['locale']?.toString() : '') ?? '';
            final lowerName = name.toLowerCase();

            final isBanned = _bannedRoboticVoices.any((b) => lowerName.contains(b));
            if (!isBanned && (locale.toLowerCase().startsWith('en') || lowerName.contains('english') || lowerName.contains('us') || lowerName.contains('uk'))) {
              selectedVoiceName = name;
              selectedVoiceLocale = locale.isNotEmpty ? locale : languageCode;
              break;
            }
          }
        }

        if (selectedVoiceName != null) {
          _voiceConfigured = true;
          _logger.info('TTS', 'Selected natural voice: $selectedVoiceName ($selectedVoiceLocale)');
          await _flutterTts.setLanguage(selectedVoiceLocale ?? languageCode);
          await _flutterTts.setVoice({
            'name': selectedVoiceName,
            'locale': selectedVoiceLocale ?? languageCode,
          });
        }
      } else {
        await _flutterTts.setLanguage(languageCode);
      }
    } catch (e, st) {
      _logger.warning('TTS', 'Voice selection fallback to standard language', e, st);
    }
  }

  @override
  Future<void> speak(String text, {String? language, double? rate}) async {
    try {
      final lang = language ?? _currentLanguage;
      if (kIsWeb) {
        await _flutterTts.stop();
      }
      if (!_voiceConfigured || lang != _currentLanguage) {
        _currentLanguage = lang;
        await _configureBestVoice(lang);
      }
      if (rate != null) {
        await _applySpeechRate(rate);
      } else {
        await _applySpeechRate(_userRate);
      }
      await _flutterTts.speak(text);
    } on Object catch (e, st) {
      _logger.error('TTS', 'Failed to speak text: $text', e, st);
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } on Object catch (e, st) {
      _logger.warning('TTS', 'Failed to stop TTS', e, st);
    }
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await _configureBestVoice(languageCode);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    await _applySpeechRate(rate);
  }

  @override
  Future<void> dispose() async {
    await stop();
  }
}
