import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/entities/mascot_accessory_entity.dart';
import '../domain/repositories/mascot_wardrobe_repository.dart';
import 'mascot_wardrobe_event.dart';
import 'mascot_wardrobe_state.dart';

class MascotWardrobeBloc extends Bloc<MascotWardrobeEvent, MascotWardrobeState> {
  final MascotWardrobeRepository _repository;

  MascotWardrobeBloc({required MascotWardrobeRepository repository})
      : _repository = repository,
        super(const MascotWardrobeInitial()) {
    on<LoadWardrobeEvent>(_onLoadWardrobe);
    on<EquipAccessoryEvent>(_onEquipAccessory);
    on<UnlockAccessoryEvent>(_onUnlockAccessory);
  }

  Future<void> _onLoadWardrobe(LoadWardrobeEvent event, Emitter<MascotWardrobeState> emit) async {
    emit(const MascotWardrobeLoading());
    final accRes = await _repository.getAccessories();
    final badgeRes = await _repository.getBadges();

    if (accRes is Success<List<MascotAccessoryEntity>> &&
        badgeRes is Success<List<BadgeEntity>>) {
      final accessories = accRes.value;
      final badges = badgeRes.value;
      final equipped = accessories.where((a) => a.isEquipped).firstOrNull;

      emit(MascotWardrobeLoaded(
        accessories: accessories,
        badges: badges,
        equippedItem: equipped,
      ));
    } else {
      emit(const MascotWardrobeErrorState('Ошибка загрузки гардероба'));
    }
  }

  Future<void> _onEquipAccessory(EquipAccessoryEvent event, Emitter<MascotWardrobeState> emit) async {
    await _repository.equipAccessory(event.id);
    add(const LoadWardrobeEvent());
  }

  Future<void> _onUnlockAccessory(UnlockAccessoryEvent event, Emitter<MascotWardrobeState> emit) async {
    await _repository.unlockAccessory(event.id);
    add(const LoadWardrobeEvent());
  }
}
