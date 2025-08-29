import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/usecases/add_surah_to_favorite.dart';
import 'package:quran_app/common/features/quran/domain/usecases/download_a_surah.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_downloaded_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_favorite_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_qari1_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/fetch_qari2_surahs.dart';
import 'package:quran_app/common/features/quran/domain/usecases/remove_surah_from_favorite.dart';

part 'surah_event.dart';
part 'surah_state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final AddSurahToFavorite addSurahToFavorite;
  final FetchQari1Surahs fetchQari1Surah;
  final FetchQari2Surahs fetchQari2Surah;
  final FetchFavoriteSurahs fetchFavoriteSurahs;
  final RemoveSurahFromFavorite removeSurahFromFavorite;
  final DownloadASurah downloadASurah;
  final FetchDownloadedSurahs fetchDownloadedSurahs;
  SurahBloc(
    this.addSurahToFavorite,
    this.fetchQari1Surah,
    this.fetchFavoriteSurahs,
    this.removeSurahFromFavorite,
    this.fetchQari2Surah,
    this.downloadASurah,
    this.fetchDownloadedSurahs,
  ) : super(SurahInitial()) {
    on<AddASurahToFavorites>((event, emit) async {
      final res = await addSurahToFavorite.call(event.surah);
      res.fold((l) => emit(AddToFavoriteFailure(l.message)),
          (r) => emit(AddToFavoriteSuccess()));
    });

    on<RemoveASurahFromFavorites>((event, emit) async {
      final res = await removeSurahFromFavorite.call(event.surah);
      res.fold((l) => emit(RemoveFromFavoriteFailure(l.message)),
          (r) => emit(RemoveFromFavoriteSuccess()));
    });

    on<FetchAllQari1Surahs>((event, emit) async {
      emit(Qari1AllSurahsFetchedLoading());
      final res = await fetchQari1Surah.call(unit);
      res.fold(
        (l) => emit(Qari1AllSurahsFetchedFailure(l.message)),
        (r) {
          return emit(Qari1AllSurahsFetchedSuccess(r));
        },
      );
    });

    on<FavoriteSurahsFetched>((event, emit) async {
      final res = await fetchFavoriteSurahs.call(unit);

      res.fold((l) {
        emit(FavoriteSurahsFetchedFailure(l.message));
      }, (r) {
        emit(FavoriteSurahsFetchedSuccess(r));
      });
    });

    on<FetchAllQari2Surahs>((event, emit) async {
      emit(Qari2AllSurahsFetchedLoading());
      final res = await fetchQari2Surah.call(unit);
      res.fold(
        (l) => emit(Qari2AllSurahsFetchedFailure(l.message)),
        (r) => emit(Qari2AllSurahsFetchedSuccess(r)),
      );
    });

    on<DownloadSurahsFetched>((event, emit) async {
      final res = await fetchDownloadedSurahs.call(unit);
      res.fold(
        (l) => emit(DownloadSurahsFetchedFailure(l.message)),
        (r) => emit(DownloadSurahsFetchedSuccess(r)),
      );
    });
    on<SurahDownloaded>((event, emit) async {
      final res = await downloadASurah.call(event.surah);
      res.fold(
        (l) => emit(DownloadASurahFailure(l.message)),
        (r) => emit(DownloadASurahSuccess(r)),
      );
    });
  }
}
