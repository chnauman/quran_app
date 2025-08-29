import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/features/download/presentation/model/surah_download_state_model.dart';

class SurahDownloadStateAdapter extends TypeAdapter<SurahDownloadStateModel> {
  @override
  SurahDownloadStateModel read(BinaryReader reader) {
    final jsonString = reader.readString();
    final jsonMap = json.decode(jsonString);
    return SurahDownloadStateModel.fromMap(jsonMap);
  }

  @override
  final int typeId = 3;

  @override
  void write(BinaryWriter writer, SurahDownloadStateModel obj) {
    final jsonString = json.encode(obj.toMap());
    writer.writeString(jsonString);
  }
}
