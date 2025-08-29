import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/labels/presentation/bloc/labels_bloc.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/bloc/surah_bloc.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari_2_cubit.dart';
import 'package:quran_app/common/util/show_snackbar.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/qari_1/presentation/pages/qari_1_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int count = 0;
  @override
  void initState() {
    context.read<SurahBloc>().add(FetchAllQari1Surahs());
    context.read<SurahBloc>().add(FetchAllQari2Surahs());
    context.read<SurahBloc>().add(FavoriteSurahsFetched());
    // context.read<SurahBloc>().add(DownloadSurahsFetched());
    context.read<LabelsBloc>().add(LabelsFetched());
    // Timer(const Duration(seconds: 1), () {
    //   setState(() {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) {
    //       return const Qari1Page();
    //     }));
    //   });
    // });
    super.initState();
  }

  // void pushAndRemovePage() {
  //   if (count >= 2) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
  //       return const Qari1Page();
  //     }));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SurahBloc, SurahState>(listener: (context, state) {
            if (state is Qari1AllSurahsFetchedSuccess) {
              context.read<SurahsQari1Cubit>().initializeCubit(state.surahs);
              context.read<SurahDownloadCubit>().addSurahsData(state.surahs);
              // context
              //     .read<CurrentPlayingCubit>()
              //     .addSurahsData(state.surahs, context);

              // count++;
              // pushAndRemovePage();
            }
            // if (state is Qari1AllSurahsFetchedFailure) {
            //   log("Failure");
            //   log(state.message);
            // }
            if (state is Qari2AllSurahsFetchedSuccess) {
              context.read<SurahsQari2Cubit>().initializeCubit(state.surahs);
              context.read<SurahDownloadCubit>().addSurahsData(state.surahs);
              // log(state.surahs.toString());
              // count++;
              // pushAndRemovePage();
            }
            // if (state is Qari2AllSurahsFetchedFailure) {
            //   log("Failure");
            //   log(state.message);
            // }
            if (state is FavoriteSurahsFetchedSuccess) {
              context.read<FavoriteSurahsCubit>().initalizeCubit(state.surahs);
            }
            // if (state is DownloadSurahsFetchedSuccess) {
            //   context.read<DownloadSurahsCubit>().initalizeCubit(state.surahs);
            // }
          }),
          BlocListener<LabelsBloc, LabelsState>(
            listener: (context, state) {
              if (state is LabelsFetchedSuccess) {
                context.read<LabelsCubit>().initializeCubit(state.labels);
                // count++;
                // pushAndRemovePage();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const Qari1Page();
                }));
              }
              if (state is LabelsFetchedFailure) {
                log(state.message);
                showSnackBar(
                  context,
                  "Error: No internet",
                  () {
                    context.read<LabelsBloc>().add(LabelsFetched());
                  },
                );
              }
            },
          )
        ],
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/splash_screen.jpg",
              fit: BoxFit.cover,
            )));
  }
}
