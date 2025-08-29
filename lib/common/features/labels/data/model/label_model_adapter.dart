// import 'dart:convert';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:quran_app/common/features/labels/data/model/labels_model.dart';
// import 'package:quran_app/common/features/labels/domain/entity/label.dart';

// class LabelsModelAdapter extends TypeAdapter<Map<LabelKeys, LabelsModel>> {
//   @override
//   final int typeId = 2;

//   @override
//   Map<LabelKeys, LabelsModel> read(BinaryReader reader) {
//     final int length = reader.readInt();
//     final Map<LabelKeys, LabelsModel> labelsMap = {};
//     for (int i = 0; i < length; i++) {
//       final keyString = reader.readString();
//       final jsonString = reader.readString();
//       final jsonMap = json.decode(jsonString);
//       final labelKey = LabelsModel.labelKeysEnumFromStringKey(keyString);
//       final labelsModel = LabelsModel.fromJson(jsonMap)[labelKey];
//       if (labelsModel != null) {
//         labelsMap[labelKey] = labelsModel;
//       }
//     }
//     return labelsMap;
//   }

//   @override
//   void write(BinaryWriter writer, Map<LabelKeys, LabelsModel> map) {
//     writer.writeInt(map.length);
//     map.forEach((key, value) {
//       final keyString = LabelsModel.labelKeysEnumToString(key);
//       final jsonString = json.encode(value.toJson(key));
//       writer.writeString(keyString);
//       writer.writeString(jsonString);
//     });
//   }
// }
