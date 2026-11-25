import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/services/audio_recorder_service.dart';

class AudioWaveformVisualizer extends StatefulWidget {
  final Stream<double> amplitudeStream;
  final RecordingState state;
  final double height;

  const AudioWaveformVisualizer({
    super.key,
    required this.amplitudeStream,
    required this.state,
    this.height = 64,
  });

  @override
  State<AudioWaveformVisualizer> createState() => _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<AudioWaveformVisualizer> {
  static const int _barCount = 28;
  final List<double> _barHeights = List.filled(_barCount, 0.15);
  StreamSubscription<double>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.amplitudeStream.listen((amp) {
      if (!mounted) return;
      setState(() {
        _barHeights.removeAt(0);
        _barHeights.add(amp.clamp(0.12, 1.0));
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color activeColor;
    switch (widget.state) {
      case RecordingState.recording:
        activeColor = Colors.redAccent;
        break;
      case RecordingState.playing:
        activeColor = AppTheme.secondaryColor;
        break;
      case RecordingState.recorded:
        activeColor = Colors.green;
        break;
      case RecordingState.idle:
        activeColor = Colors.grey.shade400;
        break;
    }

    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          final barValue = _barHeights[index];
          final h = (widget.height - 16) * barValue;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            width: 4,
            height: h.clamp(6.0, widget.height - 16),
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
