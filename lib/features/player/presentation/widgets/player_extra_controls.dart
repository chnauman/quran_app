import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/widgets/small_icon_button.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class PlayersExtraControls extends StatelessWidget {
  const PlayersExtraControls({super.key});

  @override
  Widget build(BuildContext context) {
    CurrentPlaying currentPlaying = context.watch<CurrentPlayingCubit>().state!;
    final favorites = context.watch<FavoriteSurahsCubit>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmallIconButton(
          onPressed: () {
            context.read<CurrentPlayingCubit>().setShuffleMode();
          },
          isSelected: currentPlaying.shuffleMode == AudioServiceShuffleMode.all,
          icon: Icons.shuffle,
        ),
        const SizedBox(
          width: 15,
        ),
        SmallIconButton(
            onPressed: () {
              context.read<CurrentPlayingCubit>().setRepeatMode();
            },
            isSelected: currentPlaying.repeatMode == AudioServiceRepeatMode.one,
            icon: Icons.repeat),
        const SizedBox(
          width: 15,
        ),
        SmallIconButton(
          onPressed: () {
            favorites.any((element) => element.id == currentPlaying.surah.id)
                ? context
                    .read<FavoriteSurahsCubit>()
                    .removeFromFavorite(currentPlaying.surah)
                : context
                    .read<FavoriteSurahsCubit>()
                    .addToFavorite(currentPlaying.surah);
          },
          icon: Icons.favorite,
          isSelected:
              favorites.any((element) => element.id == currentPlaying.surah.id),
        ),
        const SizedBox(
          width: 15,
        ),
        SmallIconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FavoritesPage(),
            ));
          },
          icon: Icons.list,
          isSelected: false,
        ),
      ],
    );
  }
}
