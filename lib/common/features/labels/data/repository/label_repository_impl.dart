import 'dart:developer';

import 'package:fpdart/src/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:quran_app/common/error/exceptions.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/labels/data/datasource/labels_local_datasource.dart';
import 'package:quran_app/common/features/labels/data/datasource/labels_remote_datasource.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/domain/repository/label_repository.dart';

class LabelRepositoryImpl implements LabelRepository {
  final LabelsLocalDatasource labelsLocalDatasource;
  final LabelsRemoteDatasource labelsRemoteDatasource;
  final InternetConnection internetConnection;

  LabelRepositoryImpl(this.labelsLocalDatasource, this.labelsRemoteDatasource,
      this.internetConnection);
  @override
  Future<Either<Failure, Map<LabelKeys, Label>>> fetchLabels() async {
    try {
      if (await internetConnection.hasInternetAccess) {
        final labels = await labelsRemoteDatasource.fetchLabelsFromInternet();
        labelsLocalDatasource.saveLabelsToLocalDB(labels);
        return right(labels);
      } else {
        final labels = await labelsLocalDatasource.fetchLabelsFromLocalDB();
        return right(labels);
      }
    } on ServerException catch (e) {
      final labels = await labelsLocalDatasource.fetchLabelsFromLocalDB();
      if (labels.isNotEmpty) {
        return right(labels);
      }
      return left(Failure(e.exceptionMessage.toString()));
    }
  }
}
