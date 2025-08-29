import 'package:audio_service/audio_service.dart';

class Surah {
  final int id;
  final int surahNumber;
  final String surahLabelAr;
  final String surahLabelEn;
  final String riwayah;
  final int ayahCount;
  final String audioPath;
  final bool isEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Duration duration;

  Surah(
      {required this.id,
      required this.surahNumber,
      required this.surahLabelAr,
      required this.surahLabelEn,
      required this.riwayah,
      required this.audioPath,
      required this.isEnabled,
      required this.ayahCount,
      this.createdAt,
      this.updatedAt,
      required this.duration});

  // Method to create a copy of the Surah instance with optional new values
  Surah copyWith({
    int? id,
    int? surahNumber,
    String? surahLabelAr,
    String? surahLabelEn,
    String? riwayah,
    String? audioPath,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Duration? duration,
    int? ayahCount,
  }) {
    return Surah(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahLabelAr: surahLabelAr ?? this.surahLabelAr,
      surahLabelEn: surahLabelEn ?? this.surahLabelEn,
      riwayah: riwayah ?? this.riwayah,
      audioPath: audioPath ?? this.audioPath,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      duration: duration ?? this.duration,
      ayahCount: ayahCount ?? this.ayahCount,
    );
  }

  MediaItem toMediaItem(String localPath, String playList) {
    return MediaItem(
      id: id.toString(),
      album: "Quran",
      artist: riwayah,
      title: surahLabelEn,
      duration: duration,
      extras: {
        'audioPath': localPath,
        // 'ayat': ayat,
        // 'duration': duration.inMilliseconds,
        'surahNumber': surahNumber,
        'surahLabelAr': surahLabelAr,
        'surahLabelEn': surahLabelEn,
        'isEnabled': isEnabled,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'ayahcount': ayahCount,
        'duration': duration.inSeconds,
        'playList': playList
      },
    );
  }

  factory Surah.fromMediaItem(MediaItem mediaItem) {
    return Surah(
        id: int.parse(mediaItem.id),
        surahNumber: mediaItem.extras!['surahNumber'],
        surahLabelAr: mediaItem.extras!['surahLabelAr'],
        surahLabelEn: mediaItem.extras!['surahLabelEn'],
        riwayah: mediaItem.artist!,
        audioPath: mediaItem.extras!['audioPath'],
        isEnabled: mediaItem.extras!['isEnabled'],
        createdAt: mediaItem.extras!['createdAt'] != null
            ? DateTime.tryParse(mediaItem.extras!['createdAt'])
            : null,
        updatedAt: mediaItem.extras!['updatedAt'] != null
            ? DateTime.tryParse(mediaItem.extras!['updatedAt'])
            : null,
        ayahCount: mediaItem.extras!['ayahcount'],
        duration: Duration(seconds: mediaItem.extras!['duration']));
  }

  // Override toString for better readability
  @override
  String toString() {
    return 'Surah(id: $id, surahNumber: $surahNumber, surahLabelAr: $surahLabelAr, surahLabelEn: $surahLabelEn, riwayah: $riwayah, audioPath: $audioPath, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Override equality operator and hash code
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Surah &&
        other.id == id &&
        other.surahNumber == surahNumber &&
        other.surahLabelAr == surahLabelAr &&
        other.surahLabelEn == surahLabelEn &&
        other.riwayah == riwayah &&
        other.audioPath == audioPath &&
        other.isEnabled == isEnabled &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        surahNumber.hashCode ^
        surahLabelAr.hashCode ^
        surahLabelEn.hashCode ^
        riwayah.hashCode ^
        audioPath.hashCode ^
        isEnabled.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}






// import 'package:audio_service/audio_service.dart';

// class Surah {
//   int index;
//   String name;
//   String arabicSurahName;
//   String arabicQariName;
//   String ayat;
//   String path;
//   Duration duration;
//   String qariName;

//   String get surahUniqueId => index.toString() + qariName;

//   Surah({
//     required this.index,
//     required this.name,
//     required this.ayat,
//     required this.path,
//     required this.duration,
//     required this.qariName,
//     required this.arabicQariName,
//     required this.arabicSurahName,
//   });

//   factory Surah.fromMediaItem(MediaItem mediaItem) {
//     return Surah(
//       index: int.parse(mediaItem.extras!['index']),
//       name: mediaItem.title,
//       ayat: mediaItem.extras!['ayat'],
//       path: mediaItem.extras!['path'],
//       duration: Duration(milliseconds: mediaItem.duration!.inMilliseconds),
//       qariName: mediaItem.artist!,
//       arabicQariName: mediaItem.extras!['arabicQariName'],
//       arabicSurahName: mediaItem.extras!['arabicSurahName'],
//     );
//   }

//   MediaItem toMediaItem() {
//     return MediaItem(
//       id: surahUniqueId,
//       album: "Quran",
//       artist: qariName,
//       title: name,
//       duration: duration,
//       extras: {
//         'path': 'asset:///$path',
//         'ayat': ayat,
//         'duration': duration.inMilliseconds,
//         'index': index,
//         'arabicQariName': arabicQariName,
//         'arabicSurahName': arabicSurahName,
//       },
//     );
//   }
// }
