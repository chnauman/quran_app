import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
