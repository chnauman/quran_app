import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/language/data/models/current_app_language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppLanguagesLocalDataSource {
  CurrentAppLangaugeModel fetchCurrentAppLanguageType();
  Future<Unit> setCurrentAppLanguageType(
      CurrentAppLangaugeModel currentAppLangaugeModel);
}

class AppLanguagesLocalDataSourceImpl implements AppLanguagesLocalDataSource {
  final SharedPreferences sp;

  AppLanguagesLocalDataSourceImpl(this.sp);

  @override
  CurrentAppLangaugeModel fetchCurrentAppLanguageType() {
    try {
      final currentAppLangauge = sp.getString('current_app_language');
      return CurrentAppLangaugeModel.fromString(currentAppLangauge ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> setCurrentAppLanguageType(
      CurrentAppLangaugeModel currentAppLangaugeModel) async {
    try {
      await sp.setString('current_app_language',
          currentAppLangaugeModel.getStringFromCurrentAppLangaugeModel());
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
