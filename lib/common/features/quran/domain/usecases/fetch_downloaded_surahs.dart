import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class FetchDownloadedSurahs implements Usecase<List<Surah>, Unit> {
  final SurahRepository surahRepository;

  FetchDownloadedSurahs(this.surahRepository);
  @override
  Future<Either<Failure, List<Surah>>> call(Unit params) async {
    return await surahRepository.fetchAllDownloadedSurahs();
  }
}
