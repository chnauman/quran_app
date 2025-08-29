import 'package:fpdart/src/either.dart';
import 'package:fpdart/src/unit.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/language/data/datasources/app_langauge_local_datasource.dart';
import 'package:quran_app/common/features/language/data/models/current_app_language_model.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/domain/repository/app_language_repository.dart';

class AppLanguageRepositoryImpl implements AppLanguageRepository {
  final AppLanguagesLocalDataSource appLanguagesLocalDataSource;

  AppLanguageRepositoryImpl(this.appLanguagesLocalDataSource);
  @override
  @override
  Either<Failure, CurrentAppLanguage> fetchCurrentAppLanguageType() {
    try {
      final res = appLanguagesLocalDataSource.fetchCurrentAppLanguageType();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCurrentLangaugeType(
      CurrentAppLanguage currentAppLanguage) async {
    try {
      final res = await appLanguagesLocalDataSource.setCurrentAppLanguageType(
          CurrentAppLangaugeModel.fromCurrentAppLanguage(currentAppLanguage));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
