part of 'surah_bloc.dart';

@immutable
sealed class SurahEvent {}

class AddASurahToFavorites extends SurahEvent {
  final Surah surah;

  AddASurahToFavorites(this.surah);
}

class RemoveASurahFromFavorites extends SurahEvent {
  final Surah surah;

  RemoveASurahFromFavorites(this.surah);
}

class FetchAllQari1Surahs extends SurahEvent {
  FetchAllQari1Surahs();
}

class FetchAllQari2Surahs extends SurahEvent {
  FetchAllQari2Surahs();
}

class FavoriteSurahsFetched extends SurahEvent {}

class SurahDownloaded extends SurahEvent {
  final Surah surah;

  SurahDownloaded(this.surah);
}

class RemoveASurahFromDownloads extends SurahEvent {
  final Surah surah;

  RemoveASurahFromDownloads(this.surah);
}

class DownloadSurahsFetched extends SurahEvent {}
