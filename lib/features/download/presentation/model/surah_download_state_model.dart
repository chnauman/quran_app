// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quran_app/common/features/quran/data/models/surah_model.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';

class SurahDownloadStateModel {
  final Surah surah;
  final bool isDownloading;
  final int progress;
  final bool isDownloaded;
  final bool isDownloadUpdated;

  SurahDownloadStateModel(
      {required this.surah,
      this.isDownloading = false,
      this.progress = 0,
      this.isDownloaded = false,
      this.isDownloadUpdated = true});

  SurahDownloadStateModel copyWith({
    bool? isDownloading,
    int? progress,
    bool? isDownloaded,
    Surah? surah,
    bool? isDownloadUpdated,
  }) {
    return SurahDownloadStateModel(
      surah: surah ?? this.surah,
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isDownloadUpdated: isDownloadUpdated ?? this.isDownloadUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'surah': SurahModel.fromSurah(surah).toJson(),
      'isDownloading': isDownloading,
      'progress': progress,
      'isDownloaded': isDownloaded,
      // 'isDownloadUpdated': isDownloadUpdated
    };
  }

  factory SurahDownloadStateModel.fromMap(Map<String, dynamic> map) {
    return SurahDownloadStateModel(
      surah: SurahModel.fromJson(map['surah'] as Map<String, dynamic>, false),
      isDownloading: map['isDownloading'] as bool,
      progress: map['progress'] as int,
      isDownloaded: map['isDownloaded'] as bool,
      // isDownloadUpdated: map["isDownloadUpdated"] as bool
    );
  }

  String toJson() => json.encode(toMap());

  factory SurahDownloadStateModel.fromJson(String source) =>
      SurahDownloadStateModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SurahDownloadState(surah: $surah, isDownloading: $isDownloading, progress: $progress, isDownloaded: $isDownloaded ,  isDownloadUpdated: $isDownloadUpdated)';
  }
}
