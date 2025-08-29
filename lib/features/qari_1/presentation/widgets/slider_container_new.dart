// import 'dart:developer';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_app/common/constants/color_pallate.dart';
// import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
// import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
// import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
// import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
// import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
// import 'package:quran_app/common/util/text_formatter.dart';
// import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';

// class SliderContainerNew extends StatefulWidget {
//   const SliderContainerNew({super.key});

//   @override
//   State<SliderContainerNew> createState() => _SliderContainerNewState();
// }

// class _SliderContainerNewState extends State<SliderContainerNew> {
//   List<Surah> surahs = [];

//   late CurrentAppLanguage currentAppLanguage;
//   @override
//   void initState() {
//     currentAppLanguage = context.read<CurrentAppLanguageCubit>().state;
//     surahs = context.read<CurrentPlayingCubit>().getCurrentQueuedSurahs();
//     if (surahs.isEmpty) {
//       surahs = context.read<SurahsQari1Cubit>().state;
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double size = MediaQuery.of(context).size.width * 0.55;
//     if (size > 400) {
//       size = 350;
//     }
//     return BlocBuilder<CurrentPlayingCubit, CurrentPlaying?>(
//       builder: (context, state) {
//         return CarouselSlider.builder(
//             itemCount: surahs.length,
//             itemBuilder: (context, index, realIndex) {
//               final surahindex = state?.surah.surahNumber.toString() ?? "Null";
//               final trueIndex = surahs.indexWhere(
//                   (surah) => surah.surahNumber == state?.surah.surahNumber);
//               // log("true inddex" + truesurahNumber.toString());
//               // log("surahNumber: " + surahNumber.toString());
//               final isCenter =
//                   state?.surah.surahNumber.toString() == surahindex;
//               return AnimatedOpacity(
//                 duration: const Duration(milliseconds: 300),
//                 opacity: isCenter ? 1.0 : 0.7,
//                 child: Container(
//                   margin: const EdgeInsets.all(0),
//                   width: size,
//                   decoration: BoxDecoration(
//                     color: ColorPallate.primaryColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           currentAppLanguage.currentAppLanguageType ==
//                                   AppLanguageType.english
//                               ? surahs[index].surahLabelEn
//                               : surahs[index].surahLabelAr,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineMedium!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: currentAppLanguage
//                                               .currentAppLanguageType ==
//                                           AppLanguageType.english
//                                       ? Theme.of(context)
//                                           .textTheme
//                                           .headlineMedium!
//                                           .fontSize
//                                       : Theme.of(context)
//                                               .textTheme
//                                               .headlineMedium!
//                                               .fontSize! +
//                                           1),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           TextFormatter.formatAyahCount(surahs[index].ayahCount) ,
//                           style: Theme.of(context)
//                               .textTheme
//                               .labelMedium!
//                               .copyWith(
//                                   fontSize: currentAppLanguage
//                                               .currentAppLanguageType ==
//                                           AppLanguageType.english
//                                       ? Theme.of(context)
//                                           .textTheme
//                                           .labelMedium!
//                                           .fontSize
//                                       : Theme.of(context)
//                                               .textTheme
//                                               .labelMedium!
//                                               .fontSize! +
//                                           1),
//                         ),
//                         const SizedBox(height: 8),
//                         // Text(
//                         //   _formatDuration(surahs[index].duration),
//                         //   style: Theme.of(context)
//                         //       .textTheme
//                         //       .labelMedium!
//                         //       .copyWith(
//                         //           fontSize: currentAppLanguage
//                         //                       .currentAppLanguageType ==
//                         //                   AppLanguageType.english
//                         //               ? Theme.of(context)
//                         //                   .textTheme
//                         //                   .labelMedium!
//                         //                   .fontSize
//                         //               : Theme.of(context)
//                         //                       .textTheme
//                         //                       .labelMedium!
//                         //                       .fontSize! +
//                         //                   1),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               enlargeCenterPage: true,
//               // aspectRatio: 1 / 1,
//               height: size,
//               viewportFraction: size == 350 ? 0.4 : 0.5,
//               // scrollPhysics: const NeverScrollableScrollPhysics(),
//             ));
//       },
//     );
//   }

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes % 60;
//     int seconds = duration.inSeconds % 60;
//     return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }
// }
