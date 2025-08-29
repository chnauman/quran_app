import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';

class TextFormatter {
  TextFormatter._();

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  static String formatAyahCount(int ayahCount, BuildContext context) {
    final currentLanguage = context.read<CurrentAppLanguageCubit>().state;
    if (currentLanguage.currentAppLanguageType == AppLanguageType.english) {
      return "Ayah 1-$ayahCount";
    } else {
      return "آية 1-$ayahCount";
    }
  }
}
