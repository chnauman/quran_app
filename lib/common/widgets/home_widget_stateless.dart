import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/presentation/bloc/surah_bloc.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari_2_cubit.dart';
import 'package:quran_app/common/util/play_surah.dart';
import 'package:quran_app/common/util/show_snackbar.dart';
import 'package:quran_app/common/widgets/language_change_button.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
import 'package:quran_app/features/qari_1/presentation/pages/qari_1_page.dart';
import 'package:quran_app/features/qari_1/presentation/widgets/current_surah_player_popup.dart';
import 'package:quran_app/features/qari_1/presentation/widgets/slider_container.dart';
import 'package:quran_app/features/qari_1/presentation/widgets/surah_list_tile.dart';
import 'package:quran_app/features/qari_2/presentation/pages/qari_2_page.dart';

class HomeWidgetStateless extends StatefulWidget {
  const HomeWidgetStateless(
      {super.key,
      required this.surahs,
      required this.qariName,
      required this.qariIndex});

  final List<Surah> surahs;
  final String qariName;
  final int qariIndex;

  @override
  State<HomeWidgetStateless> createState() => _HomeWidgetStatelessState();
}

class _HomeWidgetStatelessState extends State<HomeWidgetStateless> {
  double findDividedBy(double height) {
    if (height >= 0 && height < 1000) {
      return 11000.0;
    } else if (height < 1200 && height > 1000) {
      return 12000;
    } else if (height < 1400 && height > 1200) {
      return 14000;
    } else if (height < 1600 && height > 1400) {
      return 16000;
    } else if (height < 1800 && height > 1600) {
      return 18000;
    } else {
      return 20000;
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    // final labels = context.watch<LabelsCubit>().state;
    // log(labels[LabelKeys.now_playing]!.arabicLabel);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double dividedBy = findDividedBy(height);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            if (!isLoading && widget.surahs.isEmpty) {
              if (widget.qariIndex == 1) {
                showSnackBar(context, "Error fetching data", () {
                  context.read<SurahBloc>().add(FetchAllQari1Surahs());
                });
              }
              if (widget.qariIndex == 2) {
                showSnackBar(context, "Error fetching data", () {
                  context.read<SurahBloc>().add(FetchAllQari2Surahs());
                });
              }
            }
          },
        );
      },
    );

    return BlocListener<SurahBloc, SurahState>(
      listener: (context, state) {
        if (state is Qari1AllSurahsFetchedSuccess) {
          context.read<SurahsQari1Cubit>().initializeCubit(state.surahs);
          context.read<SurahDownloadCubit>().addSurahsData(state.surahs);
          if (widget.qariIndex == 1) {
            setState(() {
              isLoading = false;
            });
          }
        }
        if (state is Qari1AllSurahsFetchedLoading) {
          if (widget.qariIndex == 1) {
            setState(() {
              isLoading = true;
            });
          }
        }
        if (state is Qari1AllSurahsFetchedFailure) {
          showSnackBar(context, state.message, () {
            context.read<SurahBloc>().add(FetchAllQari1Surahs());
          });
          if (widget.qariIndex == 1) {
            setState(() {
              isLoading = false;
            });
          }
          log("Failure");
          log(state.message);
        }
        if (state is Qari2AllSurahsFetchedSuccess) {
          context.read<SurahsQari2Cubit>().initializeCubit(state.surahs);
          context.read<SurahDownloadCubit>().addSurahsData(state.surahs);
          if (widget.qariIndex == 2) {
            setState(() {
              isLoading = false;
            });
          }
        }
        if (state is Qari2AllSurahsFetchedLoading) {
          if (widget.qariIndex == 2) {
            setState(() {
              isLoading = true;
            });
          }
        }
        if (state is Qari2AllSurahsFetchedFailure) {
          showSnackBar(context, state.message, () {
            context.read<SurahBloc>().add(FetchAllQari2Surahs());
          });
          if (widget.qariIndex == 2) {
            setState(() {
              isLoading = false;
            });
          }
          log(state.message);
        }
        if (state is FavoriteSurahsFetchedSuccess) {
          context.read<FavoriteSurahsCubit>().initalizeCubit(state.surahs);
        }
      },
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                PreferredSize(
                  preferredSize:
                      Size.fromHeight(kToolbarHeight + (height / 11)),
                  child: Container(
                    height: kToolbarHeight + (height / 11),
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 0.0),
                              child: LanguageChangeButton()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SliderContainer(surahs: widget.surahs),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.qariName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: currentAppLanguage
                                                .currentAppLanguageType ==
                                            AppLanguageType.english
                                        ? Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .fontSize
                                        : Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .fontSize! +
                                            1),
                          ),
                          TextButton.icon(
                            onPressed: () => _onPressedSwitchQari(
                                context, currentAppLanguage),
                            icon: const Icon(Icons.edit),
                            style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                            ),
                            label: Text(
                              AppLocalizations.of(context)!.switch_button,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: currentAppLanguage
                                                  .currentAppLanguageType ==
                                              AppLanguageType.english
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize
                                          : Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .fontSize! +
                                              1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
                  builder: (context, state) {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 10.0 : 0),
                          child: SurahListTile(
                            surah: widget.surahs[index],
                            onPressed: () async {
                              List<Surah> surahs = [];
                              if (widget.qariIndex == 1) {
                                final qari1Surahs =
                                    context.read<SurahsQari1Cubit>().state;
                                surahs = qari1Surahs;
                              }
                              if (widget.qariIndex == 2) {
                                final qari2Surahs =
                                    context.read<SurahsQari2Cubit>().state;
                                surahs = qari2Surahs;
                              }
                              await playSurah(surahs, widget.qariName,
                                  surahs[index], context);
                              log("path: ${state?.surah.audioPath}");
                              // if (state?.surah.id ==
                              //     surahs[index].id) {
                              //   return;
                              // }

                              // if (state == null ||
                              //     state.playlist != surahs[index].riwayah) {
                              //   await context
                              //       .read<CurrentPlayingCubit>()
                              //       .removeSurahsData()
                              //       .then((value) async => await context
                              //           .read<CurrentPlayingCubit>()
                              //           .addSurahsData(surahs)
                              //           .then((value) async => await context
                              //               .read<CurrentPlayingCubit>()
                              //               .playSurah(surahs[index], qariName)))
                              //       .then((value) => Future.delayed(
                              //             const Duration(milliseconds: 100),
                              //             () async {
                              //               await context
                              //                   .read<CurrentPlayingCubit>()
                              //                   .playSurah(surahs[index], qariName);
                              //             },
                              //           ));
                              // } else {
                              //   await context
                              //       .read<CurrentPlayingCubit>()
                              //       .playSurah(surahs[index], qariName);
                              // }
                            },
                          ),
                        ),
                        itemCount: widget.surahs.length,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
                  builder: (context, state) {
                    if (state != null) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: width * 0.1, left: width * 0.1 + 5),
                        child: const CurrentSurahPlayerPopUp(),
                      );
                    } else {
                      return const SizedBox(
                        height: 60,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: height *
                      (height / dividedBy), // Adjust this value as needed
                ),
              ],
            ),
    );
  }

  void _onPressedSwitchQari(
    BuildContext context,
    CurrentAppLanguage currentAppLanguage,
  ) {
    // log('qari index' + qariIndex.toString());

    final Map<LabelKeys, Label> labels = context.read<LabelsCubit>().state;
    final CurrentAppLanguage appLanguage =
        context.read<CurrentAppLanguageCubit>().state;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            appLanguage.currentAppLanguageType == AppLanguageType.english
                ? labels[LabelKeys.choose_riwayah]!.englishLabel
                : labels[LabelKeys.choose_riwayah]!.arabicLabel,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: currentAppLanguage.currentAppLanguageType ==
                        AppLanguageType.english
                    ? Theme.of(context).textTheme.headlineMedium!.fontSize
                    : Theme.of(context).textTheme.headlineMedium!.fontSize! +
                        2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: Text(
                  appLanguage.currentAppLanguageType == AppLanguageType.english
                      ? labels[LabelKeys.hafs_an_asim]!.englishLabel
                      : labels[LabelKeys.hafs_an_asim]!.arabicLabel,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: currentAppLanguage.currentAppLanguageType ==
                              AppLanguageType.english
                          ? Theme.of(context).textTheme.titleSmall!.fontSize
                          : Theme.of(context).textTheme.titleSmall!.fontSize! +
                              2),
                ),
                selected: widget.qariIndex == 1,
                value: 1,
                groupValue: widget.qariIndex == 1 ? 1 : 2,
                onChanged: (value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const Qari1Page(),
                      ),
                      (route) => false);
                },
              ),
              RadioListTile(
                  title: Text(
                    appLanguage.currentAppLanguageType ==
                            AppLanguageType.english
                        ? labels[LabelKeys.hafs_an_nafi]!.englishLabel
                        : labels[LabelKeys.hafs_an_nafi]!.arabicLabel,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: currentAppLanguage.currentAppLanguageType ==
                                AppLanguageType.english
                            ? Theme.of(context).textTheme.titleSmall!.fontSize
                            : Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize! +
                                1),
                  ),
                  selected: widget.qariIndex == 2,
                  value: 2,
                  groupValue: widget.qariIndex == 1 ? 1 : 2,
                  onChanged: (value) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const Qari2Page(),
                        ),
                        (route) => false);
                  }),
            ],
          ),
        );
      },
    );
  }

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
