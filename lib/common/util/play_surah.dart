import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

Future<void> playSurah(List<Surah> surahs, String playlist, Surah surah,
    BuildContext context) async {
  final currentPlayingCubit = context.read<CurrentPlayingCubit>();
  final currentPlaying = currentPlayingCubit.state;

//If Clicked on the playing surah
  if (currentPlayingCubit.state?.surah.id == surah.id &&
      currentPlayingCubit.state!.playlist == playlist) {
    return;
  }

  //if no Surah in queue: upload Surahs to queue and play Surah
  if (currentPlaying == null || currentPlaying.playlist.isEmpty) {
    await currentPlayingCubit.addSurahsData(surahs, playlist, context).then(
      (value) async {
        await currentPlayingCubit.playSurah(surah, playlist);
      },
    );
  }
  //if a Surah from current playlist is being played
  else if (playlist == currentPlaying.playlist) {
    await currentPlayingCubit.playSurah(surah, playlist);
  }
  //empty current playing queue and upload new Surahs in queue, and play the Surah from updated queue
  else {
    await currentPlayingCubit.removeSurahsData().then(
      (value) async {
        await currentPlayingCubit.addSurahsData(surahs, playlist, context).then(
          (value) async {
            await currentPlayingCubit.playSurah(surah, playlist);
          },
        );
      },
    );
  }
}
