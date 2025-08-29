import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';

class SurahsQari1Cubit extends Cubit<List<Surah>> {
  SurahsQari1Cubit() : super([]);
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  void initializeCubit(List<Surah> surahs) {
    emit(surahs);
  }

  Future<void> loadSurahDurations() async {
    for (int i = 0; i < state.length; i++) {
      var surah = state[i];
      Duration? duration = await _audioPlayer.setUrl(surah.audioPath);
      final updatedSurah = surah.copyWith(duration: duration);

      // Update the list with the new Surah object
      final updatedState = List<Surah>.from(state);
      updatedState[i] = updatedSurah;

      // Log the update
      log('${updatedSurah.surahNumber} ${updatedSurah.duration.toString()}');

      // Emit the updated state
      emit(updatedState);
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}