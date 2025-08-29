part of 'surah_bloc.dart';

@immutable
sealed class SurahState {}

final class SurahInitial extends SurahState {}

final class Qari1AllSurahsFetchedSuccess extends SurahState {
  final List<Surah> surahs;

  Qari1AllSurahsFetchedSuccess(this.surahs);
}

final class Qari1AllSurahsFetchedLoading extends SurahState {
  Qari1AllSurahsFetchedLoading();
}

final class Qari1AllSurahsFetchedFailure extends SurahState {
  final String message;

  Qari1AllSurahsFetchedFailure(this.message);
}

final class Qari2AllSurahsFetchedSuccess extends SurahState {
  final List<Surah> surahs;

  Qari2AllSurahsFetchedSuccess(this.surahs);
}

final class Qari2AllSurahsFetchedLoading extends SurahState {
  Qari2AllSurahsFetchedLoading();
}

final class Qari2AllSurahsFetchedFailure extends SurahState {
  final String message;

  Qari2AllSurahsFetchedFailure(this.message);
}

final class FavoriteSurahsFetchedSuccess extends SurahState {
  final List<Surah> surahs;

  FavoriteSurahsFetchedSuccess(this.surahs);
}

final class FavoriteSurahsFetchedFailure extends SurahState {
  final String message;

  FavoriteSurahsFetchedFailure(this.message);
}

final class AddToFavoriteSuccess extends SurahState {}

final class AddToFavoriteFailure extends SurahState {
  final String message;

  AddToFavoriteFailure(this.message);
}

final class RemoveFromFavoriteSuccess extends SurahState {}

final class RemoveFromFavoriteFailure extends SurahState {
  final String message;

  RemoveFromFavoriteFailure(this.message);
}

final class DownloadSurahsFetchedSuccess extends SurahState {
  final List<Surah> surahs;

  DownloadSurahsFetchedSuccess(this.surahs);
}

final class DownloadSurahsFetchedFailure extends SurahState {
  final String message;

  DownloadSurahsFetchedFailure(this.message);
}

final class DownloadASurahSuccess extends SurahState {
  final Surah surah;

  DownloadASurahSuccess(this.surah);
}

final class DownloadASurahFailure extends SurahState {
  final String message;

  DownloadASurahFailure(this.message);
}
