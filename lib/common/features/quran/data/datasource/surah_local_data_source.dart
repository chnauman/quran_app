import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model.dart';

abstract interface class SurahLocalDataSource {
  Future<List<SurahModel>> fetchQari1Surahs();
  Future<List<SurahModel>> fetchQari2Surahs();

  Future<Unit> saveQari1Surahs(List<SurahModel> surahs);
  Future<Unit> saveQari2Surahs(List<SurahModel> surahs);

  Future<Unit> saveDownloadedSurah(SurahModel surah);
  Future<List<SurahModel>> fetchDownloadedSurahs();
  Future<Unit> updateDownloadedSurah(SurahModel surah);

  Future<Unit> addSurahToFavorites(SurahModel surah);
  Future<List<SurahModel>> fetchAllFavoritesSurahs();
  Future<Unit> removeASurahFromFavorites(SurahModel surah);
}

class SurahLocalDataSourceImpl implements SurahLocalDataSource {
  final Box<SurahModel> favoritesBox;
  final Box<SurahModel> qari1SurahsBox;
  final Box<SurahModel> qari2SurahsBox;
  final Box<SurahModel> downloadedSurahsBox;

  SurahLocalDataSourceImpl(
      {required this.favoritesBox,
      required this.downloadedSurahsBox,
      required this.qari1SurahsBox,
      required this.qari2SurahsBox});
  @override
  Future<Unit> addSurahToFavorites(SurahModel surah) async {
    try {
      final surahs = await fetchAllFavoritesSurahs();
      if (surahs.any(
        (element) => element.id == surah.id,
      )) {
        throw ServerException('Surah is Already Favorite');
      }
      await favoritesBox.put(surah.id, surah);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SurahModel>> fetchAllFavoritesSurahs() async {
    try {
      List<SurahModel> surahs = [];
      // for (var i = 1; i <= 114; i++) {
      //   if (box.containsKey(i)) {
      //     surahs.add(box.get(i)!);
      //   }
      // }

      final keys = favoritesBox.keys.toList();
      for (var element in keys) {
        if (favoritesBox.containsKey(element)) {
          surahs.add(favoritesBox.get(element)!);
        }
      }

      // log('local db' + surahs.toString());
      return surahs;
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> removeASurahFromFavorites(SurahModel surah) async {
    try {
      final surahs = await fetchAllFavoritesSurahs();
      if (!surahs.any(
        (element) => element.id == surah.id,
      )) {
        throw ServerException('Surah is Already Not Favorite');
      }
      await favoritesBox.delete(surah.id);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SurahModel>> fetchDownloadedSurahs() async {
    try {
      List<SurahModel> surahs = [];
      final keys = downloadedSurahsBox.keys.toList();
      for (var element in keys) {
        if (downloadedSurahsBox.containsKey(element)) {
          surahs.add(downloadedSurahsBox.get(element)!);
        }
      }
      return surahs;
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SurahModel>> fetchQari1Surahs()async {
    try {
      List<SurahModel> surahs = [];
      final keys = qari1SurahsBox.keys.toList();
      for (var element in keys) {
        if (qari1SurahsBox.containsKey(element)) {
          surahs.add(qari1SurahsBox.get(element)!);
        }
      }
      return surahs;
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SurahModel>> fetchQari2Surahs()async {
    try {
      List<SurahModel> surahs = [];
      final keys = qari2SurahsBox.keys.toList();
      for (var element in keys) {
        if (qari2SurahsBox.containsKey(element)) {
          surahs.add(qari2SurahsBox.get(element)!);
        }
      }
      return surahs;
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> saveDownloadedSurah(SurahModel surah) async {
    try {
      final surahs = await fetchDownloadedSurahs();
      if (surahs.any(
        (element) => element.id == surah.id,
      )) {
        throw ServerException('Surah is Already saved');
      }
      await downloadedSurahsBox.put(surah.id, surah);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> saveQari1Surahs(List<SurahModel> surahs) async {
    try {
      await qari1SurahsBox.clear();
      for (var surah in surahs) {
        await qari1SurahsBox.put(surah.id, surah);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> saveQari2Surahs(List<SurahModel> surahs) async {
    try {
      await qari2SurahsBox.clear();
      for (var surah in surahs) {
        await qari2SurahsBox.put(surah.id, surah);
      }
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateDownloadedSurah(SurahModel surah) {
    // TODO: implement updateDownloadedSurah
    throw UnimplementedError();
  }
}
