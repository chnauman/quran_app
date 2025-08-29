import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/quran/domain/entity/surah.dart';
import 'package:quran_app/common/features/quran/domain/repository/surah_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class FetchQari2Surahs implements Usecase<List<Surah>, Unit> {
  final SurahRepository surahRepository;

  FetchQari2Surahs(this.surahRepository);

  @override
  Future<Either<Failure, List<Surah>>> call(Unit params) async {
    return await surahRepository.fetchQari2Surahs();
  }
}
