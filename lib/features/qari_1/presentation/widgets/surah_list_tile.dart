import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/util/show_snackbar.dart';
import 'package:quran_app/common/util/text_formatter.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/download/presentation/model/surah_download_state_model.dart';
import 'package:quran_app/features/download/presentation/widgets/download_button.dart';
import 'package:quran_app/features/download/presentation/widgets/update_button.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class SurahListTile extends StatelessWidget {
  const SurahListTile(
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
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
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
            TextFormatter.formatAyahCount(surah.ayahCount, context),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: state?.surah.id == surah.id
                    ? ColorPallate.primaryColor
                    : const Color.fromARGB(125, 250, 250, 250),
                fontSize: currentAppLanguage.currentAppLanguageType ==
                        AppLanguageType.english
                    ? Theme.of(context).textTheme.labelSmall!.fontSize
                    : Theme.of(context).textTheme.labelSmall!.fontSize! + 1),
          ),
          trailing:
              BlocBuilder<SurahDownloadCubit, List<SurahDownloadStateModel>>(
            builder: (context, downloadState) {
              final surahDownloadState = downloadState.firstWhere(
                (element) => element.surah.id == surah.id,
              );
              // Surah is downloaded
              return (surahDownloadState.isDownloaded)
                  ? (surahDownloadState.isDownloadUpdated)
                      // Download is updated
                      ? _durationText(state, currentAppLanguage, context)
                      // Download is not updated
                      : SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Update Availabe"),
                              const SizedBox(
                                width: 10,
                              ),
                              _durationText(state, currentAppLanguage, context),
                              const SizedBox(
                                width: 10,
                              ),
                              UpdateButton(
                                surah: surah,
                                onDownload: (surah) {
                                  context
                                      .read<CurrentPlayingCubit>()
                                      .replaceWithDownloadedSurah(
                                          surah, surah.riwayah);
                                },
                                onError: (error) {
                                  showSnackBar(context, error);
                                  log("error Shown");
                                },
                              ),
                            ],
                          ),
                        )
                  // Surah is not downloaded
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _durationText(state, currentAppLanguage, context),
                          const SizedBox(
                            width: 10,
                          ),
                          if (surahDownloadState.isDownloading)
                            SizedBox(
                              height: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .fontSize! +
                                  5,
                              width: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .fontSize! +
                                  5,
                              child: CircularProgressIndicator(
                                value: surahDownloadState.progress.toDouble(),
                                color: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorPallate.primaryColor),
                              ),
                            )
                          else
                            DownloadButton(
                              surah: surah,
                              onDownload: (surah) {
                                context
                                    .read<CurrentPlayingCubit>()
                                    .replaceWithDownloadedSurah(
                                        surah, surah.riwayah);
                              },
                              onError: (error) {
                                showSnackBar(context, error);
                                log("error Shown");
                              },
                            ),
                        ],
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  Widget _durationText(CurrentPlaying? state,
      CurrentAppLanguage currentAppLanguage, BuildContext context) {
    return Text(
      TextFormatter.formatDuration(surah.duration),
      style: const TextStyle().copyWith(
          color: state?.surah.id == surah.id
              ? ColorPallate.primaryColor
              : const Color.fromARGB(125, 250, 250, 250),
          fontSize: currentAppLanguage.currentAppLanguageType ==
                  AppLanguageType.english
              ? Theme.of(context).textTheme.labelLarge!.fontSize
              : Theme.of(context).textTheme.labelLarge!.fontSize! + 1),
    );
  }
}
