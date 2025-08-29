import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';

abstract interface class AppLanguageRepository {
  Future<Either<Failure, Unit>> setCurrentLangaugeType(
      CurrentAppLanguage currentAppLanguage);
  Either<Failure, CurrentAppLanguage> fetchCurrentAppLanguageType();
}
