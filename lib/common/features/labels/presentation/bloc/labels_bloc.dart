import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quran_app/common/features/labels/domain/entity/label.dart';
import 'package:quran_app/common/features/labels/domain/usecases/fetch_labels.dart';

part 'labels_event.dart';
part 'labels_state.dart';

class LabelsBloc extends Bloc<LabelsEvent, LabelsState> {
  final FetchLabels fetchLabels;
  LabelsBloc(this.fetchLabels) : super(LabelsInitial()) {
    on<LabelsFetched>((event, emit) async {
     
      final labels = await fetchLabels.call(unit);
      labels.fold(
        (l) => emit(LabelsFetchedFailure(l.message)),
        (r) => emit(LabelsFetchedSuccess(r)),
      );
    });
  }
}
