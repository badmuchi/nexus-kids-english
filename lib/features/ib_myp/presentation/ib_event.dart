import 'package:equatable/equatable.dart';

sealed class IbEvent extends Equatable {
  const IbEvent();

  @override
  List<Object?> get props => [];
}

class LoadIbUnitsEvent extends IbEvent {
  const LoadIbUnitsEvent();
}

class CompleteIbTaskEvent extends IbEvent {
  final String unitId;

  const CompleteIbTaskEvent(this.unitId);

  @override
  List<Object?> get props => [unitId];
}
