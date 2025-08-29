import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/error/failure.dart';

abstract interface class StreamUseCase<SuccessType, Params> {
  Either<Failure, Stream<SuccessType>> call(Params params);
}
