import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class AudioWavePainter extends CustomPainter {
  final double progress;
  final bool isRtl;
  final List<double> volumeLevels; // Volume levels for each bar

  AudioWavePainter(this.progress, this.isRtl, this.volumeLevels);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const barWidth = 4.0;
    const spacing = 2.0;
    final barsCount = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < barsCount; i++) {
      double x = i * (barWidth + spacing);
      double barHeight = size.height *
          0.5 *
          (0.5 +
              0.5 *
                  (volumeLevels.isNotEmpty
                      ? volumeLevels[i % volumeLevels.length]
                      : 0.5));

      // Determine if the current bar should be filled based on the progress and direction
      double fillCondition = progress;
      if (x / size.width <= fillCondition) {
        paint.color = Colors.blue;
      } else {
        paint.color = Colors.white54;
      }

      if (isRtl) {
        // Draw bars from right to left
        x = size.width - x - barWidth;
      }

      canvas.drawLine(
        Offset(x, size.height / 2 - barHeight / 2),
        Offset(x, size.height / 2 + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AudioWaveSlider extends StatefulWidget {
  const AudioWaveSlider({super.key});

  @override
  State<AudioWaveSlider> createState() => _AudioWaveSliderState();
}

class _AudioWaveSliderState extends State<AudioWaveSlider> {
  // Example volume levels, in a real scenario you would get these from the audio data
  final List<double> volumeLevels =
      List<double>.generate(100, (index) => math.Random().nextDouble());

  @override
  Widget build(BuildContext context) {
    Duration totalDuration =
        context.watch<CurrentPlayingCubit>().state!.surah.duration;
    Duration currentDuration =
        context.watch<CurrentPlayingCubit>().state!.currentDuration;

    double sliderValue = currentDuration.inSeconds / totalDuration.inSeconds;

    // Determine if the current layout direction is RTL
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 80),
          painter: AudioWavePainter(sliderValue, isRtl, volumeLevels),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 0,
            thumbColor: Colors.blue,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            value: sliderValue,
            onChanged: (value) {
              final Duration duration = Duration(
                  seconds: ((value) * totalDuration.inSeconds).toInt());
              context.read<CurrentPlayingCubit>().seekAudio(duration);
            },
          ),
        ),
      ],
    );
  }
}
