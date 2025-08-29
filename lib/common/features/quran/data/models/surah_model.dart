import 'package:quran_app/common/constants/const_strings.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';

class SurahModel extends Surah {
  SurahModel(
      {required super.id,
      required super.surahNumber,
      required super.surahLabelAr,
      required super.surahLabelEn,
      required super.riwayah,
      required super.audioPath,
      required super.isEnabled,
      required super.createdAt,
      required super.updatedAt,
      required super.duration,
      required super.ayahCount});

  // Factory constructor to create a Surah from a JSON map
  factory SurahModel.fromJson(Map<String, dynamic> json,
      [bool isRemote = true]) {
    // log(json.toString());
    // log(json['created_at'].toString());
    // final time1 = DateTime.tryParse(json['created_at']);
    // log(time1.toString());
    return SurahModel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        surahNumber: int.tryParse(json['surah_number'].toString()) ?? 0,
        surahLabelAr: json['surah_label_ar'],
        surahLabelEn: json['surah_label_en'],
        riwayah: json['riwayah'],
        audioPath: isRemote
            ? "${ConstStrings.baseURL}${json['audio_path']}"
            : json['audio_path'],
        isEnabled: () {
          final v = json['is_enabled'];
          if (v is bool) return v;
          final s = v?.toString().toLowerCase();
          return s == '1' || s == 'true';
        }(),
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
        duration: Duration(
            seconds: double.tryParse(json['duration'])?.floor() ?? 5000),
        ayahCount: int.tryParse(json['ayah_count'].toString()) ?? 0);
  }

  // Method to convert a Surah instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'surah_label_ar': surahLabelAr,
      'surah_label_en': surahLabelEn,
      'riwayah': riwayah,
      'audio_path': audioPath,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'duration': duration.inSeconds.toString(),
      'ayah_count': ayahCount.toString()
    };
  }

  factory SurahModel.fromSurah(Surah surah) {
    return SurahModel(
        id: surah.id,
        surahNumber: surah.surahNumber,
        surahLabelAr: surah.surahLabelAr,
        surahLabelEn: surah.surahLabelEn,
        riwayah: surah.riwayah,
        audioPath: surah.audioPath,
        isEnabled: surah.isEnabled,
        createdAt: surah.createdAt,
        updatedAt: surah.updatedAt,
        duration: surah.duration,
        ayahCount: surah.ayahCount);
  }
}
