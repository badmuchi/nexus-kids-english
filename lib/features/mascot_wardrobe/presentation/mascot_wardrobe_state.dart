import 'package:equatable/equatable.dart';
import '../domain/entities/mascot_accessory_entity.dart';

sealed class MascotWardrobeState extends Equatable {
  const MascotWardrobeState();

  @override
  List<Object?> get props => [];
}

final class MascotWardrobeInitial extends MascotWardrobeState {
  const MascotWardrobeInitial();
}

final class MascotWardrobeLoading extends MascotWardrobeState {
  const MascotWardrobeLoading();
}

final class MascotWardrobeLoaded extends MascotWardrobeState {
  final List<MascotAccessoryEntity> accessories;
  final List<BadgeEntity> badges;
  final MascotAccessoryEntity? equippedItem;

  const MascotWardrobeLoaded({
    required this.accessories,
    required this.badges,
    this.equippedItem,
  });

  @override
  List<Object?> get props => [accessories, badges, equippedItem];
}

final class MascotWardrobeErrorState extends MascotWardrobeState {
  final String message;
  const MascotWardrobeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
