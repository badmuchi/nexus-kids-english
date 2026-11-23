import 'package:equatable/equatable.dart';
import '../domain/entities/ib_unit_entity.dart';

sealed class IbState extends Equatable {
  const IbState();

  @override
  List<Object?> get props => [];
}

class IbInitial extends IbState {
  const IbInitial();
}

class IbLoading extends IbState {
  const IbLoading();
}

class IbLoaded extends IbState {
  final List<IbInquiryUnitEntity> units;

  const IbLoaded(this.units);

  @override
  List<Object?> get props => [units];
}

class IbErrorState extends IbState {
  final String message;

  const IbErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
