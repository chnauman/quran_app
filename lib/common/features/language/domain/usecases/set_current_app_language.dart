import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/domain/repository/app_language_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class SetCurrentAppLanguage implements Usecase<Unit, CurrentAppLanguage> {
  final AppLanguageRepository settingsRepository;

  SetCurrentAppLanguage(this.settingsRepository);
  @override
  Future<Either<Failure, Unit>> call(CurrentAppLanguage params) async {
    return await settingsRepository.setCurrentLangaugeType(params);
  }
}
