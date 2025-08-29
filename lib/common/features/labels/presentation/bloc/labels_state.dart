part of 'labels_bloc.dart';

@immutable
sealed class LabelsState {}

final class LabelsInitial extends LabelsState {}

final class LabelsFetchedLoading extends LabelsState {
  LabelsFetchedLoading();
}

final class LabelsFetchedSuccess extends LabelsState {
  final Map<LabelKeys, Label> labels;

  LabelsFetchedSuccess(this.labels);
}

final class LabelsFetchedFailure extends LabelsState {
  final String message;

  LabelsFetchedFailure(this.message);
}
