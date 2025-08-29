import 'package:audio_service/audio_service.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';

class CurrentPlaying {
  final Surah surah;
  final PlayingStatus playingStatus;
  final bool showPopUpPlayer;
  final Duration totalDuraion;
  final Duration currentDuration;
  final AudioServiceRepeatMode repeatMode;
  final AudioServiceShuffleMode shuffleMode;
  final String playlist;
  final bool isBuffering;

  CurrentPlaying(
      {required this.playlist,
      required this.surah,
      required this.playingStatus,
      required this.showPopUpPlayer,
      required this.totalDuraion,
      required this.currentDuration,
      required this.repeatMode,
      required this.shuffleMode,
      required this.isBuffering});

  CurrentPlaying copyWith(
      {Surah? surah,
      PlayingStatus? playingStatus,
      bool? showPopUpPlayer,
      String? playlist,
      Duration? totalDuraion,
      Duration? currentDuration,
      AudioServiceRepeatMode? repeatMode,
      AudioServiceShuffleMode? shuffleMode,
      bool? isBuffering}) {
    return CurrentPlaying(
        surah: surah ?? this.surah,
        playingStatus: playingStatus ?? this.playingStatus,
        showPopUpPlayer: showPopUpPlayer ?? this.showPopUpPlayer,
        totalDuraion: totalDuraion ?? this.totalDuraion,
        currentDuration: currentDuration ?? this.currentDuration,
        repeatMode: repeatMode ?? this.repeatMode,
        shuffleMode: shuffleMode ?? this.shuffleMode,
        playlist: playlist ?? this.playlist,
        isBuffering: isBuffering ?? this.isBuffering);
  }
}

enum PlayingStatus { playing, paused }
