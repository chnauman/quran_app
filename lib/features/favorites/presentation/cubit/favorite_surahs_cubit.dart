import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/presentation/bloc/surah_bloc.dart';

class FavoriteSurahsCubit extends Cubit<List<Surah>> {
  FavoriteSurahsCubit(this.surahBloc) : super([]);

  final SurahBloc surahBloc;

  void addToFavorite(Surah surah) {
    if (!state.any(
      (element) => element.id == surah.id,
    )) {
      surahBloc.add(AddASurahToFavorites(surah));
      emit([...state, surah]);
    }
  }

  void removeFromFavorite(Surah surah) {
    if (state.any(
      (element) => element.id == surah.id,
    )) {
      surahBloc.add(RemoveASurahFromFavorites(surah));
      final newState =
          state.where((element) => element.id != surah.id).toList();
      emit(newState);
    }
  }

  void initalizeCubit(List<Surah> surahs) {
    emit(surahs);
  }
}
