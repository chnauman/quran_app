import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/util/text_formatter.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
import 'package:quran_app/common/widgets/player_controls.dart';
import 'package:quran_app/features/player/presentation/pages/player_page.dart';

class CurrentSurahPlayerPopUp extends StatelessWidget {
  const CurrentSurahPlayerPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    // CurrentPlaying currentPlaying = context.watch<CurrentPlayingCubit>().state!;
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
      builder: (context, state) => InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PlayerPage(),
            ));
          },
          child: Container(
              height: 60,
              width: width,
              decoration: BoxDecoration(
                  color: ColorPallate.backGroundColor,
                  border: Border.all(
                    color: const Color(0xffbf9e5a),
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state!.surah.surahNumber}. ${currentAppLanguage.currentAppLanguageType == AppLanguageType.english ? state.surah.surahLabelEn : state.surah.surahLabelAr}',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: ColorPallate.primaryColor),
                      ),
                      Text(
                        TextFormatter.formatAyahCount(
                            state.surah.ayahCount, context),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.grey[50]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const PlayerControls()
                ],
              ))),
    );
  }
}
