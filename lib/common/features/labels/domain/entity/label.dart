// ignore_for_file: constant_identifier_names

class Label {
  final int id;
  final String englishLabel;
  final String arabicLabel;

  Label(
      {required this.id,
      required this.englishLabel,
      required this.arabicLabel});
}

enum LabelKeys {
  hafs_an_asim,
  hafs_an_nafi,
  riwayah_hafs_an_nafi,
  riwayah_hafs_an_asim,
  choose_app_language,
  language_type,
  btn_riwayah_switch,
  choose_riwayah,
  bookmarks_list,
  now_playing,
}
