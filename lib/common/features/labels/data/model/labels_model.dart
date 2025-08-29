import 'package:quran_app/common/features/labels/domain/entity/label.dart';

class LabelsModel extends Label {
  LabelsModel({
    required super.id,
    required super.englishLabel,
    required super.arabicLabel,
  });

  static Map<LabelKeys, LabelsModel> fromJson(Map<String, dynamic> map) {
    final labelEnum = labelKeysEnumFromStringKey(map['key']);
    final labelsModel = LabelsModel(
      id: map['id'],
      englishLabel: map['english_label'],
      arabicLabel: map['arabic_label'],
    );
    return {labelEnum: labelsModel};
  }

  Map<String, dynamic> toJson(LabelKeys labelKey) {
    final stringKey = labelKeysEnumToString(labelKey);
    return {
      'key': stringKey,
      'id': id,
      'english_label': englishLabel,
      'arabic_label': arabicLabel,
    };
  }

  static LabelKeys labelKeysEnumFromStringKey(String key) => switch (key) {
        'hafs_an_asim' => LabelKeys.hafs_an_asim,
        'hafs_an_nafi' => LabelKeys.hafs_an_nafi,
        'riwayah_hafs_an_nafi' => LabelKeys.riwayah_hafs_an_nafi,
        'riwayah_hafs_an_asim' => LabelKeys.riwayah_hafs_an_asim,
        'choose_app_language' => LabelKeys.choose_app_language,
        'language_type' => LabelKeys.language_type,
        'btn_riwayah_switch' => LabelKeys.btn_riwayah_switch,
        'choose_riwayah' => LabelKeys.choose_riwayah,
        'bookmarks_list' => LabelKeys.bookmarks_list,
        'now_playing' => LabelKeys.now_playing,
        _ => throw ArgumentError('Invalid key: $key'),
      };

  String labelKeysEnumToString(LabelKeys key) => switch (key) {
        LabelKeys.hafs_an_asim => 'hafs_an_asim',
        LabelKeys.hafs_an_nafi => 'hafs_an_nafi',
        LabelKeys.riwayah_hafs_an_nafi => 'riwayah_hafs_an_nafi',
        LabelKeys.riwayah_hafs_an_asim => 'riwayah_hafs_an_asim',
        LabelKeys.choose_app_language => 'choose_app_language',
        LabelKeys.language_type => 'language_type',
        LabelKeys.btn_riwayah_switch => 'btn_riwayah_switch',
        LabelKeys.choose_riwayah => 'choose_riwayah',
        LabelKeys.bookmarks_list => 'bookmarks_list',
        LabelKeys.now_playing => 'now_playing',
      };
}
