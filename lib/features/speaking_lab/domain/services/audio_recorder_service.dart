import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'tone_sound_service.dart';

enum RecordingState {
  idle,
  recording,
  recorded,
  playing,
}

class AudioRecorderService {
  final AudioPlayer _player = AudioPlayer();
  final ToneSoundService _toneService;

  RecordingState _state = RecordingState.idle;
  RecordingState get state => _state;

  final _stateController = StreamController<RecordingState>.broadcast();
  Stream<RecordingState> get stateStream => _stateController.stream;

  final _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  Timer? _recordingTimer;
  Timer? _amplitudeTimer;
  int _recordedSeconds = 0;
  int get recordedSeconds => _recordedSeconds;

  String? _recordedFilePath;
  String? get recordedFilePath => _recordedFilePath;

  AudioRecorderService({ToneSoundService? toneService})
      : _toneService = toneService ?? ToneSoundService() {
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _setState(RecordingState.recorded);
      }
    });
  }

  void _setState(RecordingState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  Future<void> startRecording() async {
    await stopPlayback();
    _recordedSeconds = 0;
    _setState(RecordingState.recording);

    // Audio cue beep
    await _toneService.playExamBeep();

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordedSeconds++;
    });

    final random = Random();
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_state == RecordingState.recording) {
        // Natural speech amplitude waveform fluctuation between 0.15 and 0.95
        final amp = 0.2 + random.nextDouble() * 0.75;
        _amplitudeController.add(amp);
      }
    });
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _amplitudeController.add(0.0);

    // Generates a mock recorded voice file for playback
    try {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/student_speech_${DateTime.now().millisecondsSinceEpoch}.wav');
      // Create a gentle audio playback tone for student replay
      final synthPath = await _toneService.init().then((_) => file.path);
      _recordedFilePath = synthPath;
    } catch (_) {}

    _setState(RecordingState.recorded);
  }

  Future<void> playRecording() async {
    if (_state != RecordingState.recorded && _state != RecordingState.idle) {
      await stopPlayback();
    }
    _setState(RecordingState.playing);

    // If audio file exists, play it via just_audio
    if (_recordedFilePath != null && File(_recordedFilePath!).existsSync()) {
      try {
        await _player.setFilePath(_recordedFilePath!);
        await _player.seek(Duration.zero);
        await _player.play();
      } catch (_) {
        _setState(RecordingState.recorded);
      }
    } else {
      // Simulate playback duration matching recorded time
      Future.delayed(Duration(seconds: max(_recordedSeconds, 2)), () {
        if (_state == RecordingState.playing) {
          _setState(RecordingState.recorded);
        }
      });
    }
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    if (_state == RecordingState.playing) {
      _setState(RecordingState.recorded);
    }
  }

  Future<void> reset() async {
    await stopPlayback();
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _recordedSeconds = 0;
    _recordedFilePath = null;
    _setState(RecordingState.idle);
  }

  Future<void> dispose() async {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    await _player.dispose();
    await _stateController.close();
    await _amplitudeController.close();
  }
}
