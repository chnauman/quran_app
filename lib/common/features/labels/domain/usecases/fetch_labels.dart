import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/domain/repository/label_repository.dart';
import 'package:quran_app/common/usecase/usecase.dart';

class FetchLabels implements Usecase<Map<LabelKeys, Label>, Unit> {
  final LabelRepository labelRepository;

  FetchLabels(this.labelRepository);
  @override
  Future<Either<Failure, Map<LabelKeys, Label>>> call(Unit params) async {
    return await labelRepository.fetchLabels();
  }
}
