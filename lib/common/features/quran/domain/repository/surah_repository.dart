import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';

abstract interface class SurahRepository {
  Future<Either<Failure, List<Surah>>> fetchQari1Surahs();
  Future<Either<Failure, List<Surah>>> fetchQari2Surahs();
  Future<Either<Failure, Unit>> addSurahToFavorites(Surah surah);
  Future<Either<Failure, List<Surah>>> fetchAllFavoritesSurahs();
  Future<Either<Failure, Unit>> removeASurahFromFavorites(Surah surah);
  Future<Either<Failure, Surah>> downloadASurah(Surah surah);
  Future<Either<Failure, Unit>> removeASurahFromDownloads(Surah surah);
  Future<Either<Failure, List<Surah>>> fetchAllDownloadedSurahs();
}
