import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/common/features/labels/data/datasource/labels_local_datasource.dart';
import 'package:quran_app/common/features/labels/data/datasource/labels_remote_datasource.dart';
import 'package:quran_app/common/features/labels/data/repository/label_repository_impl.dart';
import 'package:quran_app/common/features/labels/domain/repository/label_repository.dart';
import 'package:quran_app/common/features/labels/domain/usecases/fetch_labels.dart';
import 'package:quran_app/common/features/labels/presentation/bloc/labels_bloc.dart';
import 'package:quran_app/common/features/labels/presentation/cubit/labels_cubit.dart';
import 'package:quran_app/common/features/language/data/datasources/app_langauge_local_datasource.dart';
import 'package:quran_app/common/features/language/data/repository/app_langauge_repository_impl.dart';
import 'package:quran_app/common/features/language/domain/repository/app_language_repository.dart';
import 'package:quran_app/common/features/language/domain/usecases/get_current_app_language.dart';
import 'package:quran_app/common/features/language/domain/usecases/set_current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:quran_app/common/features/quran/data/datasource/surah_local_data_source.dart';
import 'package:quran_app/common/features/quran/data/datasource/surah_remote_data_source.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model_adapter.dart';
import 'package:quran_app/common/features/quran/data/repository/surah_repository_impl.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/features/quran/domain/usecases/add_surah_to_favorite.dart';
import 'package:quran_app/common/features/quran/domain/usecases/download_a_surah.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_downloaded_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_favorite_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_qari1_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_qari2_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/remove_surah_from_favorite.dart';
import 'package:quran_app/common/features/quran/presentation/bloc/surah_bloc.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari1_cubit.dart';
import 'package:quran_app/common/features/quran/presentation/cubit/surahs_qari_2_cubit.dart';
import 'package:quran_app/common/util/audio_handler.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';
import 'package:quran_app/features/download/presentation/model/surah_download_state_adapter.dart';
import 'package:quran_app/features/download/presentation/model/surah_download_state_model.dart';
import 'package:quran_app/features/favorites/presentation/cubit/favorite_surahs_cubit.dart';
import 'package:quran_app/features/player/presentation/cubit/current_playing_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator
    ..registerSingleton<AudioHandler>(await initAudioService())
    ..registerSingleton<SharedPreferences>(
        await SharedPreferences.getInstance())
    ..registerSingleton<Dio>(Dio())
    ..registerSingleton<Directory>(await getApplicationDocumentsDirectory())
    ..registerSingleton<InternetConnection>(InternetConnection());

  await __initSurah();
  await _initLabels();
  await _initDownload();
  _player();
  _initAppLangauge();
}

Future<void> resetDependencies() async {
  await serviceLocator.reset(dispose: true);
}

Future<void> __initSurah() async {
  Hive.registerAdapter(SurahModelAdapter());
  final favoritesSurahBox = await Hive.openBox<SurahModel>('favoritesSurah');
  final downloadedSurahsBox =
      await Hive.openBox<SurahModel>('downloadedSurahs');
  final qari1SurahsBox = await Hive.openBox<SurahModel>('qari1Surahs');
  final qari2SurahsBox = await Hive.openBox<SurahModel>('qari2Surahs');

  await serviceLocator.allReady();

  serviceLocator
        ..registerFactory<SurahLocalDataSource>(() => SurahLocalDataSourceImpl(
              favoritesBox: favoritesSurahBox,
              downloadedSurahsBox: downloadedSurahsBox,
              qari1SurahsBox: qari1SurahsBox,
              qari2SurahsBox: qari2SurahsBox,
            ))
        ..registerFactory<SurahRemoteDataSource>(
            () => SurahRemoteDataSourceImpl(
                  serviceLocator(),
                  serviceLocator(),
                ))
        ..registerFactory<SurahRepository>(() => SurahRepositoryImpl(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ))
        ..registerFactory(() => AddSurahToFavorite(serviceLocator()))
        ..registerFactory(() => FetchQari1Surahs(serviceLocator()))
        ..registerFactory(() => FetchQari2Surahs(serviceLocator()))
        ..registerFactory(() => FetchFavoriteSurahs(serviceLocator()))
        ..registerFactory(() => RemoveSurahFromFavorite(serviceLocator()))
        ..registerFactory(() => DownloadASurah(serviceLocator()))
        ..registerFactory(() => FetchDownloadedSurahs(serviceLocator()))
        ..registerFactory(() => SurahBloc(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ))
        ..registerSingleton(SurahsQari1Cubit())
        ..registerSingleton(SurahsQari2Cubit())
        ..registerSingleton(FavoriteSurahsCubit(serviceLocator()))
      // ..registerSingleton(DownloadSurahsCubit())
      ;
}

void _player() async {
  await serviceLocator.allReady().then((value) {
    serviceLocator.registerSingleton(
        CurrentPlayingCubit(serviceLocator(), serviceLocator()));
  });
}

void _initAppLangauge() async {
  await serviceLocator.allReady();
  serviceLocator
    ..registerFactory<AppLanguagesLocalDataSource>(
        () => AppLanguagesLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<AppLanguageRepository>(
        () => AppLanguageRepositoryImpl(serviceLocator()))
    ..registerFactory(() => GetCurrentAppLanguage(serviceLocator()))
    ..registerFactory(() => SetCurrentAppLanguage(serviceLocator()))
    ..registerSingleton<CurrentAppLanguageCubit>(CurrentAppLanguageCubit(
      serviceLocator(),
      serviceLocator(),
    ));
}

Future<void> _initLabels() async {
  await serviceLocator.allReady();
  // Open the Hive box for labels
  final labelsBox = await Hive.openBox('labelsBox');
  serviceLocator
    ..registerFactory<LabelsLocalDatasource>(
        () => LabelsLocalDatasourceImpl(labelsBox))
    ..registerFactory<LabelsRemoteDatasource>(
        () => LabelsRemoteDatasourceImpl())
    ..registerFactory<LabelRepository>(() => LabelRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))
    ..registerFactory(() => FetchLabels(serviceLocator()))
    ..registerSingleton<LabelsBloc>(LabelsBloc(
      serviceLocator(),
    ))
    ..registerSingleton<LabelsCubit>(LabelsCubit());
}

Future<void> _initDownload() async {
  await serviceLocator.allReady();
  Hive.registerAdapter(SurahDownloadStateAdapter());
  // Open the Hive box for labels
  final downloadBox =
      await Hive.openBox<SurahDownloadStateModel>('downloadBox');
  serviceLocator.registerSingleton(
      SurahDownloadCubit(serviceLocator(), serviceLocator(), downloadBox));
}
