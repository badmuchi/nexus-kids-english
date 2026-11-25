import 'dart:async';
import 'package:flutter/foundation.dart';
import 'hybrid_audio_playback_service.dart';

enum VoiceRecorderStatus {
  idle,
  recording,
  recorded,
  playing,
}

abstract class VoiceRecorderService {
  VoiceRecorderStatus get status;
  Stream<VoiceRecorderStatus> get statusStream;
  Duration get recordedDuration;

  Future<bool> startRecording();
  Future<String?> stopRecording();
  Future<void> playRecording();
  Future<void> stopPlayback();
  Future<void> reset();
}

class KidVoiceRecorderService implements VoiceRecorderService {
  final HybridAudioPlaybackService _audioService;
  final _statusController = StreamController<VoiceRecorderStatus>.broadcast();
  VoiceRecorderStatus _status = VoiceRecorderStatus.idle;
  Timer? _recordTimer;
  int _secondsRecorded = 0;
  String? _lastRecordedPath;

  KidVoiceRecorderService({
    required HybridAudioPlaybackService audioService,
  }) : _audioService = audioService;

  @override
  VoiceRecorderStatus get status => _status;

  @override
  Stream<VoiceRecorderStatus> get statusStream => _statusController.stream;

  @override
  Duration get recordedDuration => Duration(seconds: _secondsRecorded);

  void _setStatus(VoiceRecorderStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  @override
  Future<bool> startRecording() async {
    _recordTimer?.cancel();
    _secondsRecorded = 0;
    _setStatus(VoiceRecorderStatus.recording);

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRecorded++;
      _statusController.add(_status);
      if (_secondsRecorded >= 120) {
        stopRecording();
      }
    });

    return true;
  }

  @override
  Future<String?> stopRecording() async {
    _recordTimer?.cancel();
    _lastRecordedPath = 'simulated_voice_record_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _setStatus(VoiceRecorderStatus.recorded);
    return _lastRecordedPath;
  }

  @override
  Future<void> playRecording() async {
    if (_status != VoiceRecorderStatus.recorded && _status != VoiceRecorderStatus.idle) return;

    _setStatus(VoiceRecorderStatus.playing);
    // Play voice prompt demonstration
    await _audioService.speakText(
      'Playing your recorded voice practice. Great job on your pronunciation!',
      language: 'en-US',
    );
    _setStatus(VoiceRecorderStatus.recorded);
  }

  @override
  Future<void> stopPlayback() async {
    await _audioService.stop();
    _setStatus(VoiceRecorderStatus.recorded);
  }

  @override
  Future<void> reset() async {
    _recordTimer?.cancel();
    _secondsRecorded = 0;
    _lastRecordedPath = null;
    await _audioService.stop();
    _setStatus(VoiceRecorderStatus.idle);
  }

  void dispose() {
    _recordTimer?.cancel();
    _statusController.close();
  }
}
