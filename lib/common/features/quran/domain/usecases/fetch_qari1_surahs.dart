import 'package:fpdart/fpdart.dart';
import 'package:fpdart/src/either.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class FetchQari1Surahs implements Usecase<List<Surah>, Unit> {
  final SurahRepository surahRepository;

  FetchQari1Surahs(this.surahRepository);

  @override
  Future<Either<Failure, List<Surah>>> call(params) async {
    return await surahRepository.fetchQari1Surahs();
  }
}
