import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

class ToneSoundService {
  final AudioPlayer _player = AudioPlayer();
  String? _beepFilePath;
  String? _chimeFilePath;

  ToneSoundService();

  Future<void> init() async {
    try {
      _beepFilePath = await _createWavFile(
        frequency: 880.0,
        durationSeconds: 0.35,
        fileName: 'exam_beep.wav',
      );
      _chimeFilePath = await _createWavFile(
        frequency: 523.25, // C5
        durationSeconds: 0.8,
        fileName: 'exam_chime.wav',
        isDecaying: true,
      );
    } catch (_) {
      // Fallback: silent if filesystem write fails
    }
  }

  Future<void> playExamBeep() async {
    if (_beepFilePath != null && File(_beepFilePath!).existsSync()) {
      try {
        await _player.setFilePath(_beepFilePath!);
        await _player.seek(Duration.zero);
        await _player.play();
      } catch (_) {}
    }
  }

  Future<void> playExamChime() async {
    if (_chimeFilePath != null && File(_chimeFilePath!).existsSync()) {
      try {
        await _player.setFilePath(_chimeFilePath!);
        await _player.seek(Duration.zero);
        await _player.play();
      } catch (_) {}
    }
  }

  Future<String> _createWavFile({
    required double frequency,
    required double durationSeconds,
    required String fileName,
    bool isDecaying = false,
  }) async {
    const sampleRate = 44100;
    final numSamples = (durationSeconds * sampleRate).toInt();
    final bytes = BytesBuilder();

    // RIFF header
    bytes.add('RIFF'.codeUnits);
    final fileSize = 36 + numSamples * 2;
    bytes.add(_int32ToBytes(fileSize));
    bytes.add('WAVE'.codeUnits);

    // fmt chunk
    bytes.add('fmt '.codeUnits);
    bytes.add(_int32ToBytes(16)); // Chunk size
    bytes.add(_int16ToBytes(1)); // Audio format (1 = PCM)
    bytes.add(_int16ToBytes(1)); // Channels (1 = Mono)
    bytes.add(_int32ToBytes(sampleRate)); // Sample rate
    bytes.add(_int32ToBytes(sampleRate * 2)); // Byte rate
    bytes.add(_int16ToBytes(2)); // Block align
    bytes.add(_int16ToBytes(16)); // Bits per sample

    // data chunk
    bytes.add('data'.codeUnits);
    bytes.add(_int32ToBytes(numSamples * 2));

    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      final decay = isDecaying ? exp(-4.0 * t) : 1.0;
      final sample = (sin(2 * pi * frequency * t) * 32767 * decay * 0.5).toInt().clamp(-32768, 32767);
      bytes.add(_int16ToBytes(sample));
    }

    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes.toBytes());
    return file.path;
  }

  Uint8List _int16ToBytes(int value) {
    return Uint8List(2)..buffer.asByteData().setInt16(0, value, Endian.little);
  }

  Uint8List _int32ToBytes(int value) {
    return Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
