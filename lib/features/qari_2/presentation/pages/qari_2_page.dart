import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari_2_cubit.dart';
import 'package:quran_app/common/widgets/home_widget_stateless.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class Qari2Page extends StatefulWidget {
  const Qari2Page({super.key});

  @override
  State<Qari2Page> createState() => _Qari2PageState();
}

class _Qari2PageState extends State<Qari2Page> {
  late ScrollController scrollController;

  // getDuration() async {
  //   final AudioPlayer _audioPlayer = AudioPlayer();
  //   final surah = context.read<SurahsQari2Cubit>().state;
  //   for (var element in surah) {
  //     await _audioPlayer
  //         .setSource(AssetSource(element.path.split('assets/')[1]))
  //         .then((value) async {
  //       await _audioPlayer.getDuration().then((value) {
  //         log(
  //           "index: ${element.index} , Duration: ${value!.inMilliseconds} , qari = ${element.qariName}",
  //         );
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    // getDuration();

    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (context.read<CurrentPlayingCubit>().state == null) {
      return;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (context.read<CurrentPlayingCubit>().state!.showPopUpPlayer) {
        context.read<CurrentPlayingCubit>().updateShowPopUpStatus(false);
      }
    } else {
      if (!context.read<CurrentPlayingCubit>().state!.showPopUpPlayer) {
        context.read<CurrentPlayingCubit>().updateShowPopUpStatus(true);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<LabelKeys, Label> labels = context.read<LabelsCubit>().state;
    final CurrentAppLanguage appLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    final List<Surah> surahs = context.watch<SurahsQari2Cubit>().state;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kIsWeb
                ? 'images/quran_main_screen_bg.jpg'
                : 'assets/images/quran_main_screen_bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: HomeWidgetStateless(
          qariName:
              appLanguage.currentAppLanguageType == AppLanguageType.english
                  ? labels[LabelKeys.hafs_an_nafi]!.englishLabel
                  : labels[LabelKeys.hafs_an_nafi]!.arabicLabel,
          surahs: surahs,
          qariIndex: 2,
        ),
        // child: Stack(
        //   children: [
        //     Column(
        //       children: [
        //         Expanded(
        //           child: SingleChildScrollView(
        //             controller: scrollController,
        //             child:
        //           ),
        //         ),
        //       ],
        //     ),
        //     if (currentPlaying != null) const CurrentSurahPlayerPopUp(),
        //     // const MyBottomNavigationAppBar(currentIndex: 0)
        //   ],
        // ),
      ),
    );
  }
}
