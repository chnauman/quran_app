import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  // Configure iOS audio session for background playback
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  final _errorStreamController = StreamController<bool>.broadcast();
  Stream<bool> get errorStream => _errorStreamController.stream;
  bool _error = false;
  int? _errorIndex = 0;
  Duration _duration = Duration.zero;

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Stream<Duration> get positionStream => _player.positionStream;
  bool get isError => _error;

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      log("Error: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) async {
      final isPlaying = _player.playing;

      // if (!await InternetConnection.createInstance().hasInternetAccess &&
      //     _player.position.compareTo(_player.bufferedPosition) >= 0) {
      //   _error = true;
      //   _errorStreamController.add(_error);
      //   await pause();
      // } else {
      _error = false;
      _errorStreamController.add(_error);
      // }

      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.setShuffleMode,
          MediaAction.setRepeatMode,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: isPlaying,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    }, onError: (error, stack) {
      _error = true;
      _errorIndex = playbackState.value.queueIndex;
      _errorStreamController.add(_error);
      playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.buffering,
          queueIndex: _errorIndex));

      // Pause the player when an error occurs
      // await pause();
      // await skipToQueueItem(_errorIndex!);
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    }, onError: (error, stack) {
      log(error.toString());
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) async {
      final playlist = queue.value;

      if (index != null && _error) {
        _errorStreamController.add(true);
        await stop();
        // await skipToQueueItem(_errorIndex!);

        mediaItem.add(playlist[_errorIndex!]);
        return;
      }

      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    }, onError: (error, stack) {
      log(error.toString());
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    }, onError: (error, stack) {
      log(error.toString());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['audioPath'] as String),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  @override
  Future<void> seek(Duration position) async => await _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() async => await _player.seekToNext();

  @override
  Future<void> skipToPrevious() async => await _player.seekToPrevious();

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    final index = queue.value.indexWhere((item) => item.id == mediaId);

    if (index != -1) {
      await skipToQueueItem(index);
      final Duration duration = extras!['duration'];
      if (duration != Duration.zero) {
        await seek(duration);
      }
    } else {
      throw Exception('Did not find item in queue');
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
    if (name == 'clearPlayList') {
      _playlist.clear();
      queue.value.clear();
    }
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    // Find the index of the mediaItem in the queue
    final index = queue.value.indexWhere((item) => item.id == mediaItem.id);

    if (index == -1) {
      // If the mediaItem is not found, you may want to throw an error or simply return
      throw Exception('MediaItem not found in queue');
    } else {
      // Update the media item in the queue
      final newQueue = List<MediaItem>.from(queue.value);
      newQueue[index] = mediaItem;
      queue.add(newQueue);

      // Update the corresponding audio source in the _playlist
      final oldAudioSource = _playlist.children[index] as UriAudioSource;
      final newAudioSource = _createAudioSource(mediaItem);

      // Replace the old audio source with the new one
      _playlist.removeAt(index);
      _playlist.insert(index, newAudioSource);
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
      updatePosition: _player.position,
    ));
  }

  @override
  Future<void> seekBackward(bool begin) async {
    final newPosition = _player.position - const Duration(seconds: 10);
    if (newPosition >= Duration.zero) {
      await _player.seek(newPosition);
    } else {
      await _player.seek(Duration.zero);
    }
  }

  @override
  Future<void> seekForward(bool begin) async {
    final maxPosition = _player.duration ?? Duration.zero;
    final newPosition = _player.position + const Duration(seconds: 10);
    if (newPosition <= maxPosition) {
      await _player.seek(newPosition);
    } else {
      await _player.seek(maxPosition);
    }
  }
}
