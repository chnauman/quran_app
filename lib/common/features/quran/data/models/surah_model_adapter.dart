import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/common/features/quran/data/models/surah_model.dart';

class SurahModelAdapter extends TypeAdapter<SurahModel> {
  @override
  SurahModel read(BinaryReader reader) {
    final jsonString = reader.readString();
    final jsonMap = json.decode(jsonString);
    return SurahModel.fromJson(jsonMap, false);
  }

  @override
  final int typeId = 1;

  @override
  void write(BinaryWriter writer, SurahModel obj) {
    final jsonString = json.encode(obj.toJson());
    writer.writeString(jsonString);
  }
}
