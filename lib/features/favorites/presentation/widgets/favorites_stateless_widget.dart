import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/util/play_surah.dart';
import 'package:quran_app/common/widgets/language_change_button.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/favorites/presentation/widgets/favorite_list_tile.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class FavoritesStateLessWidget extends StatelessWidget {
  const FavoritesStateLessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Surah> favoriteSurahs =
        context.watch<FavoriteSurahsCubit>().state;
    final currentPlaying = context.watch<CurrentPlayingCubit>().state;
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    final Map<LabelKeys, Label> labels = context.read<LabelsCubit>().state;
    double height = MediaQuery.of(context).size.height;

    double divideBy = 0;
    if (height >= 1000) {
      divideBy = 15;
    }
    if (height <= 720) {
      divideBy = 600;
    }
    if (height > 720 && height < 1000) {
      divideBy = 25;
    }
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        AppBar(
          title: Text(
            currentAppLanguage.currentAppLanguageType == AppLanguageType.english
                ? labels[LabelKeys.bookmarks_list]!.englishLabel
                : labels[LabelKeys.bookmarks_list]!.arabicLabel,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: currentAppLanguage.currentAppLanguageType ==
                        AppLanguageType.english
                    ? Theme.of(context).textTheme.titleMedium!.fontSize
                    : Theme.of(context).textTheme.titleMedium!.fontSize! + 1),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: const [
            Padding(
                padding:
                    EdgeInsets.only(right: 0.0), // Adjust the value as needed
                child: LanguageChangeButton()),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => FavoriteSurahListTile(
              surah: favoriteSurahs[index],
              onPressed: () async {
                log(currentPlaying?.surah.audioPath ?? "NULL");
                playSurah(favoriteSurahs, 'favorites', favoriteSurahs[index],
                    context);
                // if (currentPlaying != null &&
                //     currentPlaying.playlist == "favorites" &&
                //     currentPlaying.surah.id == favoriteSurahs[index].id) {
                //   return;
                // }
                // if (currentPlaying != null &&
                //     currentPlaying.playlist != "favorites") {
                //   await context
                //       .read<CurrentPlayingCubit>()
                //       .removeSurahsData()
                //       .then((value) async => await context
                //           .read<CurrentPlayingCubit>()
                //           .addSurahsData(favoriteSurahs)
                //           .then((value) => Future.delayed(
                //                 const Duration(
                //                   milliseconds: 100,
                //                 ),
                //                 () async {
                //                   await context
                //                       .read<CurrentPlayingCubit>()
                //                       .playSurah(
                //                           favoriteSurahs[index], "favorites");
                //                 },
                //               )));
                // }

                // if (currentPlaying != null &&
                //     currentPlaying.playlist == "favorites") {
                //   return Future.delayed(
                //     const Duration(
                //       milliseconds: 100,
                //     ),
                //     () async {
                //       await context
                //           .read<CurrentPlayingCubit>()
                //           .playSurah(favoriteSurahs[index], "favorites");
                //     },
                //   );
                // }

                // context
                //     .read<CurrentPlayingCubit>()
                //     .playSurah(favoriteSurahs[index]);
              },
            ),
            itemCount: favoriteSurahs.length,
          ),
        ),
        SizedBox(
          height: 100 + (height / divideBy),
        ),
      ],
    );
  }
}
