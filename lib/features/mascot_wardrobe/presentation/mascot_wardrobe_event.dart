import 'package:equatable/equatable.dart';

sealed class MascotWardrobeEvent extends Equatable {
  const MascotWardrobeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadWardrobeEvent extends MascotWardrobeEvent {
  const LoadWardrobeEvent();
}

final class EquipAccessoryEvent extends MascotWardrobeEvent {
  final String id;
  const EquipAccessoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class UnlockAccessoryEvent extends MascotWardrobeEvent {
  final String id;
  const UnlockAccessoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}
