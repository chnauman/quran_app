import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/domain/repository/app_language_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class GetCurrentAppLanguage implements Usecase<CurrentAppLanguage, Unit> {
  final AppLanguageRepository settingsRepository;

  GetCurrentAppLanguage(this.settingsRepository);
  @override
  Future<Either<Failure, CurrentAppLanguage>> call(Unit params) async {
    return settingsRepository.fetchCurrentAppLanguageType();
  }
}
