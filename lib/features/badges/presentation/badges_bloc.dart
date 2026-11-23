import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/badges_repository.dart';
import 'badges_event.dart';
import 'badges_state.dart';

class BadgesBloc extends Bloc<BadgesEvent, BadgesState> {
  final BadgesRepository _repository;

  BadgesBloc({required BadgesRepository repository})
      : _repository = repository,
        super(const BadgesInitial()) {
    on<LoadBadgesEvent>(_onLoadBadges);
    on<UnlockBadgeEvent>(_onUnlockBadge);
  }

  Future<void> _onLoadBadges(LoadBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(const BadgesLoading());
    final result = await _repository.getAllBadges();
    switch (result) {
      case Success(value: final list):
        emit(BadgesLoaded(list));
      case Failure(error: final err):
        emit(BadgesErrorState(err.toString()));
    }
  }

  Future<void> _onUnlockBadge(UnlockBadgeEvent event, Emitter<BadgesState> emit) async {
    await _repository.unlockBadge(event.badgeId);
    add(const LoadBadgesEvent());
  }
}
