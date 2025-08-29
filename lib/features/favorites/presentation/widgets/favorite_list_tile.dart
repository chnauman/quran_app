import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class FavoriteSurahListTile extends StatelessWidget {
  const FavoriteSurahListTile(
      {super.key, required this.surah, required this.onPressed});

  final Surah surah;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    return BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
      builder: (context, state) {
        return ListTile(
          onTap: onPressed,
          title: Text(
            '${surah.surahNumber}. ${currentAppLanguage.currentAppLanguageType == AppLanguageType.english ? surah.surahLabelEn : surah.surahLabelAr}',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: state?.surah.id == surah.id
                    ? ColorPallate.primaryColor
                    : Colors.white,
                fontSize: currentAppLanguage.currentAppLanguageType ==
                        AppLanguageType.english
                    ? Theme.of(context).textTheme.labelLarge!.fontSize
                    : Theme.of(context).textTheme.labelLarge!.fontSize! + 1),
          ),
          subtitle: Text(
            currentAppLanguage.currentAppLanguageType == AppLanguageType.english
                ? surah.riwayah
                : surah.riwayah,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: state?.surah.id == surah.id
                    ? ColorPallate.primaryColor
                    : const Color.fromARGB(125, 250, 250, 250),
                fontSize: currentAppLanguage.currentAppLanguageType ==
                        AppLanguageType.english
                    ? Theme.of(context).textTheme.labelSmall!.fontSize
                    : Theme.of(context).textTheme.labelSmall!.fontSize! + 1),
          ),
          trailing: IconButton(
              onPressed: () {
                context.read<FavoriteSurahsCubit>().removeFromFavorite(surah);
              },
              icon: Icon(
                Icons.favorite,
                color: ColorPallate.primaryColor,
              )),
        );
      },
    );
  }
}
