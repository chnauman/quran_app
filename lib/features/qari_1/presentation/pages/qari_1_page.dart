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
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
import 'package:quran_app/common/widgets/home_widget_stateless.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

class Qari1Page extends StatefulWidget {
  const Qari1Page({super.key});

  @override
  State<Qari1Page> createState() => _Qari1PageState();
}

class _Qari1PageState extends State<Qari1Page> {
  late ScrollController scrollController;

  @override
  void initState() {
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

    // final CurrentPlaying? currentPlaying =
    //     context.watch<CurrentPlayingCubit>().state;
    final List<Surah> surahs = context.watch<SurahsQari1Cubit>().state;
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
                  ? labels[LabelKeys.hafs_an_asim]!.englishLabel
                  : labels[LabelKeys.hafs_an_asim]!.arabicLabel,
          surahs: surahs,
          qariIndex: 1,
        ),
      ),
    );
  }
}
