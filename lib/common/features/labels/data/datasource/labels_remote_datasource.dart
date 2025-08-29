import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:quran_app/common/constants/const_strings.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/features/labels/data/model/labels_model.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';

abstract interface class LabelsRemoteDatasource {
  Future<Map<LabelKeys, LabelsModel>> fetchLabelsFromInternet();
}

class LabelsRemoteDatasourceImpl implements LabelsRemoteDatasource {
  @override
  Future<Map<LabelKeys, LabelsModel>> fetchLabelsFromInternet() async {
    try {
      Uri url = Uri.parse(ConstStrings.labelURL);
      final res = await http.get(url);

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        final Map<LabelKeys, LabelsModel> labels = {};
        data.map((e) {
          final entry = LabelsModel.fromJson(e);
          labels.addAll(entry);
        }).toList();

        return labels;
      }
      throw ServerException("Error Occurred");
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }
}
