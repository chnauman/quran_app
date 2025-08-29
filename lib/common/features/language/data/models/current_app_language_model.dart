import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';

class CurrentAppLangaugeModel extends CurrentAppLanguage {
  CurrentAppLangaugeModel(super.currentAppLanguageType);

  factory CurrentAppLangaugeModel.fromCurrentAppLanguage(
      CurrentAppLanguage currentAppLanguage) {
    return CurrentAppLangaugeModel(currentAppLanguage.currentAppLanguageType);
  }

  factory CurrentAppLangaugeModel.fromString(String type) {
    switch (type) {
      case 'arabic':
        return CurrentAppLangaugeModel(AppLanguageType.arabic);
      case 'english':
        return CurrentAppLangaugeModel(AppLanguageType.english);
      default:
        return CurrentAppLangaugeModel(AppLanguageType.arabic);
    }
  }

  String getStringFromCurrentAppLangaugeModel() {
    switch (currentAppLanguageType) {
      case AppLanguageType.english:
        return 'english';
      case AppLanguageType.arabic:
        return 'arabic';
      default:
        return 'invalid theme type';
    }
  }
}
