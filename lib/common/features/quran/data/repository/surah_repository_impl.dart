import 'dart:developer';

import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/data/datasource/surah_local_data_source.dart';
import 'package:quran_app/common/features/quran/data/datasource/surah_remote_data_source.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahLocalDataSource surahLocalDataSource;
  final SurahRemoteDataSource surahRemoteDataSource;
  final InternetConnection internetConnection;

  SurahRepositoryImpl(this.surahLocalDataSource, this.surahRemoteDataSource,
      this.internetConnection);

  @override
  Future<Either<Failure, Unit>> addSurahToFavorites(Surah surah) async {
    try {
      final res = await surahLocalDataSource
          .addSurahToFavorites(SurahModel.fromSurah(surah));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Surah>>> fetchAllFavoritesSurahs() async {
    try {
      final res = await surahLocalDataSource.fetchAllFavoritesSurahs();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Surah>>> fetchQari1Surahs() async {
    try {
      if (await internetConnection.hasInternetAccess) {
        log("fetchQari1Surahs Has Net");
        final res = await surahRemoteDataSource.fetchQari1Surahs();
        surahLocalDataSource.saveQari1Surahs(res);
        return right(res);
      } else {
        log("fetchQari1Surahs Has no Net");
        final res = await surahLocalDataSource.fetchQari1Surahs();
        if (res.isEmpty) {
          return left(Failure("Please fetch data from internet"));
        }
        return right(res);
      }
    } on ServerException catch (e) {
      final res = await surahLocalDataSource.fetchQari1Surahs();
      if (res.isNotEmpty) {
        return right(res);
      }
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeASurahFromFavorites(Surah surah) async {
    try {
      final res = await surahLocalDataSource
          .removeASurahFromFavorites(SurahModel.fromSurah(surah));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Surah>>> fetchQari2Surahs() async {
    try {
      if (await internetConnection.hasInternetAccess) {
        log("fetchQari2Surahs Has Net");
        final res = await surahRemoteDataSource.fetchQari2Surahs();
        // log(res.toString());
        surahLocalDataSource.saveQari2Surahs(res);
        return right(res);
      } else {
        log("fetchQari2Surahs Has No Net");
        final res = await surahLocalDataSource.fetchQari2Surahs();
        if (res.isEmpty) {
          return left(Failure("Please fetch data from internet"));
        }
        return right(res);
      }
    } on ServerException catch (e, stackTrace) {
      final res = await surahLocalDataSource.fetchQari2Surahs();
      if (res.isNotEmpty) {
        return right(res);
      }
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Surah>> downloadASurah(Surah surah) async {
    try {
      if (await internetConnection.hasInternetAccess) {
        final res = await surahRemoteDataSource
            .downloadSurah(SurahModel.fromSurah(surah));

        final downloadedSurah = surah.copyWith(audioPath: res);
        surahLocalDataSource
            .saveDownloadedSurah(SurahModel.fromSurah(downloadedSurah));
        return right(downloadedSurah);
      } else {
        throw ServerException("No Internet Connection");
      }
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Surah>>> fetchAllDownloadedSurahs() async {
    try {
      final res = await surahLocalDataSource.fetchDownloadedSurahs();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeASurahFromDownloads(Surah surah) {
    // TODO: implement removeASurahFromDownloads
    throw UnimplementedError();
  }
}
