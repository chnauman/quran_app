import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key, this.insidePlayer = false});

  final bool insidePlayer;

  @override
  Widget build(BuildContext context) {
    final CurrentPlaying currentPlaying =
        context.watch<CurrentPlayingCubit>().state!;
    // log('currentPlaying Controls' + currentPlaying.playingStatus.name);
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    bool isArabic =
        currentAppLanguage.currentAppLanguageType == AppLanguageType.arabic;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              isArabic
                  ? context.read<CurrentPlayingCubit>().playNext()
                  : context.read<CurrentPlayingCubit>().playPrevious();
            },
            icon: Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: insidePlayer ? 40 : 30,
            ),
            style: insidePlayer
                ? IconButton.styleFrom(
                    fixedSize: const Size(70, 70),
                  )
                : null,
          ),
          IconButton(
            onPressed: () {
              if (!currentPlaying.isBuffering) {
                context.read<CurrentPlayingCubit>().changePlayingStatus();
              }
            },
            icon: !currentPlaying.isBuffering
                ? Icon(
                    currentPlaying.playingStatus == PlayingStatus.paused
                        ? Icons.play_arrow
                        : Icons.pause,
                    color: Colors.white,
                    size: insidePlayer ? 40 : 30,
                  )
                : SizedBox(
                    height: insidePlayer ? 40 : 30,
                    width: insidePlayer ? 40 : 30,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
            style: insidePlayer
                ? IconButton.styleFrom(
                    backgroundColor: ColorPallate.primaryColor,
                    fixedSize: const Size(70, 70),
                  )
                : null,
          ),
          IconButton(
            onPressed: () {
              isArabic
                  ? context.read<CurrentPlayingCubit>().playPrevious()
                  : context.read<CurrentPlayingCubit>().playNext();
            },
            icon: Icon(
              Icons.skip_next,
              color: Colors.white,
              size: insidePlayer ? 40 : 30,
            ),
            style: insidePlayer
                ? IconButton.styleFrom(
                    fixedSize: const Size(70, 70),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
