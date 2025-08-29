import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:quran_app/common/features/quran/domain/entity/current_playing.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/util/audio_handler.dart';
import 'package:quran_app/features/download/presentation/cubit/surah_download_cubit.dart';

import 'dart:async';

class CurrentPlayingCubit extends Cubit<CurrentPlaying?> {
  final AudioHandler audioHandler;
  final InternetConnection _internetConnection;
  bool _isError = false;
  List<Surah> surahsData = [];
  Timer? _retryTimer;

  CurrentPlayingCubit(this.audioHandler, this._internetConnection)
      : super(null) {
    audioHandler.mediaItem.listen((mediaItem) {
      if (_isError) return;
      if (mediaItem != null) {
        final surah =
            surahsData.firstWhere((s) => s.id.toString() == mediaItem.id);

        if (state?.surah.id != surah.id) {
          log("state == null ${state == null}");
          emit(state == null
              ? CurrentPlaying(
                  surah: surah,
                  playingStatus: PlayingStatus.paused,
                  showPopUpPlayer: false,
                  totalDuraion: mediaItem.duration!,
                  currentDuration: Duration.zero,
                  repeatMode: AudioServiceRepeatMode.none,
                  shuffleMode: AudioServiceShuffleMode.none,
                  playlist: surah.riwayah,
                  isBuffering: false,
                )
              : state!.copyWith(
                  surah: surah,
                  totalDuraion: state!.surah.duration,
                  playlist: state!.playlist,
                  isBuffering: false,
                ));
        }
      }
    }, onError: (error, stackTrace) {
      log(error.toString());
    });

    (audioHandler as MyAudioHandler).positionStream.listen((position) {
      if (state != null &&
          state!.currentDuration.inSeconds != position.inSeconds) {
        emit(state!.copyWith(currentDuration: position));
      }
    });

    (audioHandler as MyAudioHandler).errorStream.listen((error) {
      _isError = error;
      if (_isError) {
        _handleError();
      }
    });

    audioHandler.playbackState.listen((playbackState) {
      final repeatMode = playbackState.repeatMode;
      final shuffleMode = playbackState.shuffleMode;
      final isPlaying = playbackState.playing;
      final status = isPlaying ? PlayingStatus.playing : PlayingStatus.paused;
      final isBuffering = _isError
          ? true
          : playbackState.processingState == AudioProcessingState.buffering;

      if (state != null &&
          (repeatMode != state!.repeatMode ||
              shuffleMode != state!.shuffleMode ||
              state!.playingStatus != status ||
              state!.isBuffering != isBuffering)) {
        emit(state!.copyWith(
          repeatMode: repeatMode,
          shuffleMode: shuffleMode,
          playingStatus: playbackState.playing
              ? PlayingStatus.playing
              : PlayingStatus.paused,
          isBuffering: isBuffering,
          // currentDuration: playbackState.position.inSeconds !=
          //         state!.currentDuration.inSeconds
          //     ? playbackState.position
          //     : null,
        ));
      }
    });
  }

  Future<void> addSurahsData(
      List<Surah> surahs, String playList, BuildContext context) async {
    final downloadedSurahsState = context.read<SurahDownloadCubit>().state;
    Map<int, String> paths = {};
    for (var e in downloadedSurahsState) {
      paths.addAll({e.surah.id: e.surah.audioPath});
    }
    surahsData = [...surahs];

    List<MediaItem> mediaItems =
        surahsData.map((e) => e.toMediaItem(paths[e.id]!, playList)).toList();
    // log(mediaItems.toString());

    await audioHandler.addQueueItems(mediaItems);
    emit(state);
  }

  Future<void> replaceWithDownloadedSurah(Surah surah, String playList) async {
    try {
      final index = surahsData.indexWhere(
        (element) => element.id == surah.id,
      );

      if (index == -1) {
        return;
      }

      surahsData[index] = surah;
      MediaItem mediaItem = surah.toMediaItem(surah.audioPath, playList);
      await audioHandler.updateMediaItem(mediaItem);
      if (state != null && state!.surah.id == surah.id) {
        emit(state!.copyWith(
            surah: state!.surah.copyWith(audioPath: surah.audioPath)));
      }
      log("completed replacing");
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> removeSurahsData() async {
    await audioHandler.customAction('clearPlayList');
    surahsData.clear();
    emit(null);
  }

  List<Surah> getCurrentQueuedSurahs() => surahsData;

  Future<void> playSurah(Surah surah, String playlist,
      [Duration duration = Duration.zero]) async {
    final surahData = surahsData.firstWhere(
      (element) => element.id == surah.id,
    );
    await pauseAudio();
    await _playAudio(surahData, duration);

    CurrentPlaying newState = CurrentPlaying(
        playlist: playlist,
        surah: surahData,
        playingStatus: state!.playingStatus,
        showPopUpPlayer: true,
        totalDuraion: surahData.duration,
        currentDuration: state!.currentDuration,
        isBuffering: state!.isBuffering,
        repeatMode: state?.repeatMode ?? AudioServiceRepeatMode.none,
        shuffleMode: state?.shuffleMode ?? AudioServiceShuffleMode.none);
    emit(newState);
  }

  void stopAudio() async {
    await audioHandler.stop();
  }

  Future<void> pauseAudio() async {
    await audioHandler.pause();
    if (state != null) {
      emit(state!.copyWith(isBuffering: false));
    }
  }

  Future<void> resumeAudio() async {
    await audioHandler.play();
  }

  void updateShowPopUpStatus(bool status) {
    if (state != null) {
      emit(state!.copyWith(showPopUpPlayer: status));
    }
  }

  void changePlayingStatus() async {
    if (state == null) return;

    if (state!.playingStatus == PlayingStatus.playing) {
      await pauseAudio();
      emit(state!.copyWith(playingStatus: PlayingStatus.paused));
    } else {
      await resumeAudio();
      emit(state!.copyWith(playingStatus: PlayingStatus.playing));
    }
  }

  void playNext() async {
    final currentSurah = state!.surah;
    if (surahsData.last == currentSurah) {
      final Surah surah = surahsData.first;
      await _playAudio(surah);
      return;
    }

    await audioHandler.skipToNext();
  }

  void playPrevious() async {
    final Surah currentSurah = state!.surah;
    if (currentSurah == surahsData.first) {
      final Surah surah = surahsData.last;
      await _playAudio(surah);
      return;
    }

    await audioHandler.skipToPrevious();
  }

  Future<void> seekAudio(Duration duration) async {
    await audioHandler.seek(duration);
  }

  Future<void> _playAudio(Surah surah,
      [Duration duration = Duration.zero]) async {
    try {
      await audioHandler
          .playFromMediaId(surah.id.toString(), {"duration": duration});
      await audioHandler.play();
    } catch (e) {
      log(e.toString());
      // if (state!.playingStatus != PlayingStatus.paused) {
      //   _handleError();
      // }
    }
  }

  void _handleError() {
    if (_retryTimer != null && _retryTimer!.isActive) {
      return;
    }

    emit(state!.copyWith(isBuffering: true));

    _retryTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      var connectivityResult = await _internetConnection.hasInternetAccess;
      if (connectivityResult) {
        log('Internet connected, trying to play again...');

        await playSurah(state!.surah, state!.playlist, state!.currentDuration);
        // await seekAudio(state!.currentDuration);

        timer.cancel();
        emit(state!.copyWith(isBuffering: false));
      } else {
        log('No internet connection, retrying in 5 seconds...');
        emit(state!.copyWith(isBuffering: true));
      }
    });
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    return super.close();
  }

  Future<void> setRepeatMode() async {
    AudioServiceRepeatMode repeatMode = state!.repeatMode;
    AudioServiceRepeatMode updatedRepeatMode =
        repeatMode == AudioServiceRepeatMode.none
            ? AudioServiceRepeatMode.one
            : AudioServiceRepeatMode.none;
    await audioHandler.setRepeatMode(updatedRepeatMode);
  }

  Future<void> setShuffleMode() async {
    AudioServiceShuffleMode shuffleMode = state!.shuffleMode;
    AudioServiceShuffleMode updatedShuffledMode =
        shuffleMode == AudioServiceShuffleMode.none
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none;
    await audioHandler.setShuffleMode(updatedShuffledMode);
  }
}
