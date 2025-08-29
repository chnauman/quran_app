import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/language/domain/entities/current_app_language.dart';
import 'package:quran_app/common/features/language/presentation/cubit/current_app_language_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';

class LanguageChangeButton extends StatelessWidget {
  const LanguageChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    return IconButton(
      iconSize: 30,
      onPressed: () {
        _onPressedChangeLanguage(context, currentAppLanguage);
      },
      icon: const Icon(
        Icons.more_vert,
      ),
    );
  }

  _onPressedChangeLanguage(
      BuildContext context, CurrentAppLanguage currentAppLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(
          //   AppLocalizations.of(context)!.settingsType_chooseAppLanguage,
          //   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          //       fontSize: currentAppLanguage.currentAppLanguageType ==
          //               AppLanguageType.english
          //           ? Theme.of(context).textTheme.headlineMedium!.fontSize
          //           : Theme.of(context).textTheme.headlineMedium!.fontSize! +
          //               2),
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                  title: Text(
                    AppLocalizations.of(context)!.settingsType_arabic,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: currentAppLanguage.currentAppLanguageType ==
                                AppLanguageType.english
                            ? Theme.of(context).textTheme.titleSmall!.fontSize
                            : Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize! +
                                1),
                  ),
                  selected: currentAppLanguage.currentAppLanguageType ==
                      AppLanguageType.arabic,
                  value: AppLanguageType.arabic,
                  groupValue: currentAppLanguage.currentAppLanguageType,
                  onChanged: (value) async {
                    context
                        .read<CurrentAppLanguageCubit>()
                        .setLanguage(AppLanguageType.arabic);
                    Navigator.pop(context);
                  }),
              RadioListTile(
                  title: Text(
                    AppLocalizations.of(context)!.settingsType_english,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: currentAppLanguage.currentAppLanguageType ==
                                AppLanguageType.english
                            ? Theme.of(context).textTheme.titleSmall!.fontSize
                            : Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize! +
                                1),
                  ),
                  selected: currentAppLanguage.currentAppLanguageType ==
                      AppLanguageType.english,
                  value: AppLanguageType.english,
                  groupValue: currentAppLanguage.currentAppLanguageType,
                  onChanged: (value) async {
                    context
                        .read<CurrentAppLanguageCubit>()
                        .setLanguage(AppLanguageType.english);
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
