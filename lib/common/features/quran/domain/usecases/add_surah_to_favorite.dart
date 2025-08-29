import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class AddSurahToFavorite implements Usecase<Unit, Surah> {
  final SurahRepository surahRepository;

  AddSurahToFavorite(this.surahRepository);

  @override
  Future<Either<Failure, Unit>> call(Surah params) async {
    return await surahRepository.addSurahToFavorites(params);
  }
}
