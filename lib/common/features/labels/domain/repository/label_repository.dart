import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';

abstract interface class LabelRepository {
  Future<Either<Failure, Map<LabelKeys, Label>>> fetchLabels();
}
