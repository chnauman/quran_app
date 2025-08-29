import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';

class LabelsCubit extends Cubit<Map<LabelKeys, Label>> {
  LabelsCubit() : super({});

  void initializeCubit(Map<LabelKeys, Label> labels) {
    emit(labels);
  }
}
