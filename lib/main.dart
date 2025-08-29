import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/common/constants/color_pallate.dart';
import 'package:quran_app/common/features/labels/presentation/bloc/labels_bloc.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/bloc/surah_bloc.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari_2_cubit.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
import 'package:quran_app/features/splash/presentaion/splash_page.dart';
import 'package:quran_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();
  await serviceLocator.allReady();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => serviceLocator<SurahBloc>()),
      BlocProvider(create: (context) => serviceLocator<CurrentPlayingCubit>()),
      BlocProvider(create: (context) => serviceLocator<SurahsQari1Cubit>()),
      BlocProvider(create: (context) => serviceLocator<SurahsQari2Cubit>()),
      BlocProvider(create: (context) => serviceLocator<FavoriteSurahsCubit>()),
      BlocProvider(create: (context) => serviceLocator<SurahDownloadCubit>()),
      BlocProvider(create: (context) => serviceLocator<LabelsCubit>()),
      BlocProvider(create: (context) => serviceLocator<LabelsBloc>()),
      BlocProvider(
          create: (context) => serviceLocator<CurrentAppLanguageCubit>()),
    ],
    child: DevicePreview(enabled: false, builder: (context) => const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;

    final ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: ColorPallate.primaryColor),
      useMaterial3: true,
      iconTheme: const IconThemeData().copyWith(color: Colors.white),
    );

    Locale currentLocale = context
        .read<CurrentAppLanguageCubit>()
        .locale(currentAppLanguage.currentAppLanguageType);

    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      title: 'حمد السنان',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      locale: currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const SplashScreen(),
    );
  }
}
