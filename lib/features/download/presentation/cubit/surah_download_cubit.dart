// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/features/download/presentation/model/surah_download_state_model.dart';

class SurahDownloadCubit extends Cubit<List<SurahDownloadStateModel>> {
  final Dio _dio;
  final Box<SurahDownloadStateModel> _surahBox;
  final Directory appDirectory;

  SurahDownloadCubit(this._dio, this.appDirectory, this._surahBox) : super([]);

  void addSurahsData(List<Surah> surahs) {
    // _surahBox.clear();
    final data = surahs.map((surah) {
      final storedSurah = _surahBox.values.firstWhere(
          (s) => s.surah.id == surah.id,
          orElse: () => SurahDownloadStateModel(surah: surah));

      return _checkUpdationOfSurah(
          storedSurah, SurahDownloadStateModel(surah: surah));
    }).toList();

    emit([...state, ...data]);
  }

  Future<Surah> downloadSurah(Surah surah, Function(Surah surah) onDownload,
      Function(String error) onError) async {
    try {
      final index = state.indexWhere((s) => s.surah.id == surah.id);
      if (index == -1) throw ServerException("Could not find surah in list");

      // Update state to indicate download has started
      emit(List.from(state)
        ..[index] = state[index]
            .copyWith(isDownloading: true, progress: 0, isDownloaded: false));

      // Get the path to save the downloaded file

      String savePath =
          "${appDirectory.path}/${surah.surahNumber}_${surah.surahLabelEn}_${surah.riwayah}.mp3";

      // Perform the download
      await _dio.download(
        surah.audioPath,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toInt();
            log(progress.toString());
            emit(List.from(state)
              ..[index] = state[index]
                  .copyWith(progress: progress, isDownloading: true));
          }
        },
      );

      // Update state to indicate download is complete
      final downloadedSurah = state[index].copyWith(
          isDownloaded: true,
          isDownloading: false,
          progress: 100,
          surah: surah.copyWith(
            audioPath: savePath,
          ),
          isDownloadUpdated: true);

      emit(List.from(state)..[index] = downloadedSurah);
      log("download completed");
      // Save The Completed Surah
      await _surahBox.put(downloadedSurah.surah.id, downloadedSurah);
      onDownload(downloadedSurah.surah);
      return downloadedSurah.surah;
    } catch (e) {
      log('Download error: $e');
      onError("Download Failed. Check your connection");

      //Download reset if failed
      final index = state.indexWhere((s) => s.surah.id == surah.id);
      final downloadedFailedSurah = state[index].copyWith(
        isDownloaded: false,
        isDownloading: false,
        progress: 0,
      );

      emit(List.from(state)..[index] = downloadedFailedSurah);
      throw ServerException(e.toString());
      // Handle error by updating state if needed
    }
  }

  updateSurahDownload(Surah surah, Function(Surah surah) onCompleteDownload,
      Function(String error) onError) async {
    try {
      await downloadSurah(surah, onCompleteDownload, onError);
    } catch (e) {
      onError("Download error");
    }
  }

  SurahDownloadStateModel _checkUpdationOfSurah(
      SurahDownloadStateModel storedSurahStateModel,
      SurahDownloadStateModel inputSurahStateModel) {
    // input Surah is not updated after first upload
    if (inputSurahStateModel.surah.updatedAt == null) {
      return storedSurahStateModel;
    }
    //Input surah is udated after first upload
    else {
      // Stored(Downloaded) surah has never been updated after first time download
      //OR
      //There is new update on server for this surah
      if (storedSurahStateModel.surah.updatedAt == null ||
          inputSurahStateModel.surah.updatedAt!
              .isAfter(storedSurahStateModel.surah.updatedAt!)) {
        log("storedSurahStateModel $storedSurahStateModel");
        log("inputSurahStateModel $inputSurahStateModel");
        log("Stored(Downloaded) surah has never been updated after first time download");
        return storedSurahStateModel.copyWith(isDownloadUpdated: false);
      }

      //Stored Surah is updated
      return storedSurahStateModel;
    }
  }
}
