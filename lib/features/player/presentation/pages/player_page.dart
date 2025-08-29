import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/util/text_formatter.dart';
import 'package:quran_app/common/widgets/language_change_button.dart';
import 'package:quran_app/common/widgets/player_controls.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
import 'package:quran_app/features/player/presentation/widgets/audio_wave_slider.dart';
import 'package:quran_app/features/player/presentation/widgets/player_extra_controls.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    final Map<LabelKeys, Label> labels = context.read<LabelsCubit>().state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kIsWeb
                    ? 'images/quaran_app_bg.jpg'
                    : 'assets/images/quaran_app_bg.jpg'),
                fit: BoxFit.fill)),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                actions: const [
                  Padding(
                      padding: EdgeInsets.only(
                          right: 0.0), // Adjust the value as needed
                      child: LanguageChangeButton()),
                ],
                title: Text(
                    currentAppLanguage.currentAppLanguageType ==
                            AppLanguageType.english
                        ? labels[LabelKeys.now_playing]!.englishLabel
                        : labels[LabelKeys.now_playing]!.arabicLabel,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: currentAppLanguage.currentAppLanguageType ==
                                AppLanguageType.english
                            ? Theme.of(context).textTheme.titleMedium!.fontSize
                            : Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize! +
                                1)),
                centerTitle: true,
              ),
              const SizedBox(
                height: 20,
              ),
              const PlayersExtraControls(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              // Center(
              //   child:
              // )
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height / 3,
              child: const PlayerControls(
                insidePlayer: true,
              )),
          Positioned(
              // top: 0,
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          state != null
                              ? currentAppLanguage.currentAppLanguageType ==
                                      AppLanguageType.english
                                  ? state.surah.surahLabelEn
                                  : state.surah.surahLabelAr
                              : "",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontSize: currentAppLanguage
                                              .currentAppLanguageType ==
                                          AppLanguageType.english
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize
                                      : Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontSize! +
                                          1)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        state != null
                            ? TextFormatter.formatAyahCount(
                                state.surah.ayahCount, context)
                            : "",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize:
                                currentAppLanguage.currentAppLanguageType ==
                                        AppLanguageType.english
                                    ? Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .fontSize
                                    : Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .fontSize! +
                                        1),
                      )
                    ],
                  );
                },
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height / 6,
              child: BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        state != null
                            ? TextFormatter.formatDuration(
                                state.currentDuration)
                            : "",
                        style: const TextStyle().copyWith(
                            fontSize:
                                currentAppLanguage.currentAppLanguageType ==
                                        AppLanguageType.english
                                    ? Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .fontSize
                                    : Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .fontSize! +
                                        1),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: AudioWaveSlider(),
                      ),
                      if (currentAppLanguage.currentAppLanguageType ==
                          AppLanguageType.arabic)
                        const SizedBox(
                          width: 10,
                        ),
                      Text(
                          state != null
                              ? TextFormatter.formatDuration(state.totalDuraion)
                              : "",
                          style: const TextStyle().copyWith(
                              fontSize:
                                  currentAppLanguage.currentAppLanguageType ==
                                          AppLanguageType.english
                                      ? Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .fontSize
                                      : Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .fontSize! +
                                          1)),
                      const SizedBox(
                        width: 25,
                      ),
                    ],
                  );
                },
              ))
        ]),
      ),
    );
  }
}
