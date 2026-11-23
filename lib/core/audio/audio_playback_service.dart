abstract interface class AudioPlaybackService {
  Future<void> playAudio(String source, {bool isAsset = false, String? fallbackText});
  Future<void> speakText(String text, {String? language, double? rate});
  Future<void> stop();
  Future<void> pause();
  Future<void> setPlaybackSpeed(double speed);
  Future<void> setVoiceAccent(String languageCode);
  Future<void> dispose();

  Stream<bool> get isPlayingStream;
}
