import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../logging/app_logger.dart';

class JustAudioPlaybackService {
  final AudioPlayer _player;
  final AppLogger _logger;

  JustAudioPlaybackService({
    AudioPlayer? player,
    required AppLogger logger,
  })  : _player = player ?? AudioPlayer(),
        _logger = logger;

  Stream<bool> get isPlayingStream => _player.playingStream;

  Future<bool> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
      return true;
    } on Object catch (e, st) {
      _logger.error('Audio', 'Error playing URL: $url', e, st);
      return false;
    }
  }

  Future<bool> playAsset(String assetPath) async {
    final clean = assetPath.trim();
    if (clean.isEmpty) return false;

    if (kIsWeb) {
      try {
        final byteData = await rootBundle.load(clean);
        final bytes = byteData.buffer.asUint8List();
        final base64Audio = base64Encode(bytes);
        final dataUri = 'data:audio/mpeg;base64,$base64Audio';
        await _player.setUrl(dataUri);
        await _player.play();
        return true;
      } on Object catch (e, st) {
        _logger.error('Audio', 'Web data URI audio playback failed for $clean', e, st);
        return false;
      }
    }

    try {
      await _player.setAsset(clean);
      await _player.play();
      return true;
    } on Object catch (e, st) {
      _logger.warning('Audio', 'Native setAsset failed for $clean, trying data URI fallback', e, st);
      try {
        final byteData = await rootBundle.load(clean);
        final bytes = byteData.buffer.asUint8List();
        final base64Audio = base64Encode(bytes);
        final dataUri = 'data:audio/mpeg;base64,$base64Audio';
        await _player.setUrl(dataUri);
        await _player.play();
        return true;
      } catch (_) {}
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } on Object catch (e, st) {
      _logger.warning('Audio', 'Error stopping audio', e, st);
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } on Object catch (e, st) {
      _logger.warning('Audio', 'Error pausing audio', e, st);
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
    } on Object catch (e, st) {
      _logger.warning('Audio', 'Error setting speed', e, st);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
