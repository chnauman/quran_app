import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/util/play_surah.dart';
import 'package:quran_app/common/util/text_formatter.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SliderContainer extends StatefulWidget {
  const SliderContainer({super.key, required this.surahs});

  final List<Surah> surahs;

  @override
  State<SliderContainer> createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  List<Surah> surahs = [];

  bool isManualScroll = false;
  int previousIndex = -1;

  Future<void> animateToPage(int currentIndex) async {
    if (currentIndex < 0 || currentIndex >= surahs.length) {
      return;
    }
    if (currentIndex != previousIndex) {
      isManualScroll = false; // Set flag to false to indicate automatic scroll
      await _carouselController.animateToPage(currentIndex,
          duration: const Duration(
            milliseconds: 500,
          ),
          curve: Curves.linear);
      previousIndex = currentIndex;
    }
  }

  void onPageChanged(int index, CarouselPageChangedReason reason,
      CurrentPlaying? state, List<Surah> currentQueuedSurahs) async {
    if (surahs.isEmpty || index < 0 || index >= surahs.length) {
      return;
    }
    if (isManualScroll) {
      // if (currentQueuedSurahs.isEmpty) {
      //   await context
      //       .read<CurrentPlayingCubit>()
      //       .addSurahsData(widget.surahs, context ,);
      //   onPageChanged(index, reason, state, widget.surahs);
      //   return;
      // }
      playSurah(surahs, state?.playlist ?? "", surahs[index], context);
      isManualScroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth * 0.55;
    double containerHeight = screenHeight * 0.25;

    final currentQueuedSurahs =
        context.watch<CurrentPlayingCubit>().getCurrentQueuedSurahs();
    surahs = currentQueuedSurahs;
    if (currentQueuedSurahs.isEmpty) {
      surahs = widget.surahs;
    }

    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;

    return BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
      builder: (context, state) {
        // log(state?.surah.name.toString() ?? "Null");

        int currentIndex =
            surahs.indexWhere((surah) => surah.id == state?.surah.id);
        if (!isManualScroll) {
          animateToPage(currentIndex);
        }
        return CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: surahs.length,
          itemBuilder: (context, index, realIndex) {
            bool isCenter = index == currentIndex;
            return surahs.isEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: ColorPallate.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isCenter ? 1.0 : 0.7,
                    child: GestureDetector(
                      onTap: () {
                        if (index < 0 || index >= surahs.length) {
                          return;
                        }
                        if (state?.surah.id == surahs[index].id) {
                          return;
                        }
                        setState(() {
                          isManualScroll = true;
                        });
                        onPageChanged(index, CarouselPageChangedReason.manual,
                            state, currentQueuedSurahs);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: containerWidth,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          color: ColorPallate.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentAppLanguage.currentAppLanguageType ==
                                        AppLanguageType.english
                                    ? surahs[index].surahLabelEn
                                    : surahs[index].surahLabelAr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: currentAppLanguage
                                                    .currentAppLanguageType ==
                                                AppLanguageType.english
                                            ? Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .fontSize
                                            : Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium!
                                                    .fontSize! +
                                                1),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TextFormatter.formatAyahCount(
                                    surahs[index].ayahCount, context),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: currentAppLanguage
                                                    .currentAppLanguageType ==
                                                AppLanguageType.english
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .fontSize
                                            : Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .fontSize! +
                                                1),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDuration(surahs[index].duration),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: currentAppLanguage
                                                    .currentAppLanguageType ==
                                                AppLanguageType.english
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .fontSize
                                            : Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .fontSize! +
                                                1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
          options: CarouselOptions(
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            height: containerHeight,
            aspectRatio: screenWidth / screenHeight,
            viewportFraction: 0.5,
            onPageChanged: (index, reason) {
              if (reason == CarouselPageChangedReason.manual) {
                setState(() {
                  isManualScroll = true;
                });
                onPageChanged(index, reason, state, currentQueuedSurahs);
              } else {
                isManualScroll = false;
              }
            },
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
