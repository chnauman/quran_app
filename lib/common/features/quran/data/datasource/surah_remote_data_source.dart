import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_app/common/constants/const_strings.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model.dart';
import 'package:http/http.dart' as http;

abstract interface class SurahRemoteDataSource {
  Future<List<SurahModel>> fetchQari1Surahs();
  Future<List<SurahModel>> fetchQari2Surahs();
  Future<String> downloadSurah(SurahModel surah);
}

class SurahRemoteDataSourceImpl implements SurahRemoteDataSource {
  final Dio dio;
  final Directory appDirectory;

  SurahRemoteDataSourceImpl(this.dio, this.appDirectory);

  @override
  Future<List<SurahModel>> fetchQari1Surahs() async {
    try {
      Uri url = Uri.parse('${ConstStrings.audioBaseURL}/hafs_an_asim');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);

        final List<SurahModel> surahs = data
            .map(
              (e) => SurahModel.fromJson(e),
            )
            .toList();

        return surahs;
      }
      // log(res.statusCode.toString());
      // log(res.body);
      throw ServerException("Error Occured");
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SurahModel>> fetchQari2Surahs() async {
    try {
      Uri url = Uri.parse('${ConstStrings.audioBaseURL}/hafs_an_nafi');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        final List<SurahModel> surahs = data
            .map(
              (e) => SurahModel.fromJson(e),
            )
            .toList();
        return surahs;
      }
      throw ServerException("Error Occured");
    } catch (e, stackTrace) {
      log("fetchQari2Surahs error: $e");
      log("fetchQari2Surahs stackTrace: $stackTrace");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> downloadSurah(SurahModel surah) async {
    try {
      final String path =
          "${appDirectory.path}/${surah.surahNumber}_${surah.surahLabelEn}_${surah.riwayah}.mp3";
      await dio.download(
        surah.audioPath,
        path,
      );
      return path;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
