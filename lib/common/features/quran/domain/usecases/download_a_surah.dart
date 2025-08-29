import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class DownloadASurah implements Usecase<Surah, Surah> {
  final SurahRepository surahRepository;

  DownloadASurah(this.surahRepository);

  @override
  Future<Either<Failure, Surah>> call(Surah params) async {
    return await surahRepository.downloadASurah(params);
  }
}
