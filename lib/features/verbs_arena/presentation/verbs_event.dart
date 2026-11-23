import 'package:equatable/equatable.dart';

sealed class VerbsEvent extends Equatable {
  const VerbsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAllVerbsEvent extends VerbsEvent {
  const LoadAllVerbsEvent();
}

final class FilterVerbsByRhymeEvent extends VerbsEvent {
  final String rhymeGroup;
  const FilterVerbsByRhymeEvent(this.rhymeGroup);

  @override
  List<Object?> get props => [rhymeGroup];
}
