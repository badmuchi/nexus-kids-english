import 'package:flutter/material.dart';
import '../audio/hybrid_audio_playback_service.dart';
import '../audio/voice_recorder_service.dart';
import '../theme/app_theme.dart';

class InteractiveVoiceRecorder extends StatefulWidget {
  final HybridAudioPlaybackService audioService;
  final String label;
  final ValueChanged<String?>? onRecordCompleted;

  const InteractiveVoiceRecorder({
    super.key,
    required this.audioService,
    this.label = 'Запиши свой ответ на микрофон:',
    this.onRecordCompleted,
  });

  @override
  State<InteractiveVoiceRecorder> createState() => _InteractiveVoiceRecorderState();
}

class _InteractiveVoiceRecorderState extends State<InteractiveVoiceRecorder> {
  late final KidVoiceRecorderService _recorder;

  @override
  void initState() {
    super.initState();
    _recorder = KidVoiceRecorderService(audioService: widget.audioService);
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VoiceRecorderStatus>(
      stream: _recorder.statusStream,
      initialData: _recorder.status,
      builder: (context, snapshot) {
        final status = snapshot.data ?? VoiceRecorderStatus.idle;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: status == VoiceRecorderStatus.recording
                ? const Color(0xFFFEF2F2)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: status == VoiceRecorderStatus.recording
                  ? AppTheme.errorColor
                  : const Color(0xFFE2E8F0),
              width: status == VoiceRecorderStatus.recording ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: status == VoiceRecorderStatus.recording
                            ? AppTheme.errorColor
                            : AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  if (status == VoiceRecorderStatus.recording)
                    Row(
                      children: [
                        const CircleAvatar(radius: 4, backgroundColor: AppTheme.errorColor),
                        const SizedBox(width: 6),
                        Text(
                          'REC ${_formatDuration(_recorder.recordedDuration)}',
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else if (status == VoiceRecorderStatus.recorded || status == VoiceRecorderStatus.playing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Запись: ${_formatDuration(_recorder.recordedDuration)} ✅',
                        style: const TextStyle(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (status == VoiceRecorderStatus.idle) ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await _recorder.startRecording();
                  },
                  icon: const Icon(Icons.fiber_manual_record, size: 18),
                  label: const Text('Начать запись ответа'),
                ),
              ] else if (status == VoiceRecorderStatus.recording) ...[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final path = await _recorder.stopRecording();
                    widget.onRecordCompleted?.call(path);
                  },
                  icon: const Icon(Icons.stop, size: 18),
                  label: const Text('Остановить запись'),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: status == VoiceRecorderStatus.playing
                              ? Colors.grey
                              : AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (status == VoiceRecorderStatus.playing) {
                            _recorder.stopPlayback();
                          } else {
                            _recorder.playRecording();
                          }
                        },
                        icon: Icon(status == VoiceRecorderStatus.playing ? Icons.pause : Icons.play_arrow),
                        label: Text(status == VoiceRecorderStatus.playing ? 'Пауза' : 'Слушать себя'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        _recorder.reset();
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Перезаписать'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
