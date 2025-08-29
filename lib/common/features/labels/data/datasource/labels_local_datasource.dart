import 'dart:convert';
import 'dart:developer';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/labels/data/model/labels_model.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';

abstract interface class LabelsLocalDatasource {
  Future<Map<LabelKeys, LabelsModel>> fetchLabelsFromLocalDB();
  Future<Unit> saveLabelsToLocalDB(Map<LabelKeys, LabelsModel> map);
}

class LabelsLocalDatasourceImpl implements LabelsLocalDatasource {
  final Box labelsBox;

  LabelsLocalDatasourceImpl(this.labelsBox);

  @override
  Future<Map<LabelKeys, LabelsModel>> fetchLabelsFromLocalDB() async {
    try {
      final jsonString = labelsBox.get('labels');
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        final Map<LabelKeys, LabelsModel> labelsMap = jsonMap.map((key, value) {
          final labelKey = LabelsModel.labelKeysEnumFromStringKey(key);
          return MapEntry(labelKey, LabelsModel.fromJson(value)[labelKey]!);
        });
        return labelsMap;
      }
      return {};
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> saveLabelsToLocalDB(Map<LabelKeys, LabelsModel> map) async {
    try {
      final jsonMap = map.map((key, value) {
        final stringKey = value.labelKeysEnumToString(key);
        return MapEntry(stringKey, value.toJson(key));
      });
      final jsonString = json.encode(jsonMap);
      await labelsBox.put('labels', jsonString);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
