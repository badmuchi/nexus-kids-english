import 'package:equatable/equatable.dart';
import '../domain/entities/mistake_entity.dart';

abstract class MistakesState extends Equatable {
  const MistakesState();

  @override
  List<Object?> get props => [];
}

class MistakesInitial extends MistakesState {
  const MistakesInitial();
}

class MistakesLoading extends MistakesState {
  const MistakesLoading();
}

class MistakesLoaded extends MistakesState {
  final List<MistakeEntity> allMistakes;
  final List<MistakeEntity> unresolvedMistakes;

  const MistakesLoaded({
    required this.allMistakes,
    required this.unresolvedMistakes,
  });

  int get resolvedCount => allMistakes.where((m) => m.isResolved).length;
  int get activeCount => unresolvedMistakes.length;

  @override
  List<Object?> get props => [allMistakes, unresolvedMistakes];
}

class MistakesError extends MistakesState {
  final String message;

  const MistakesError(this.message);

  @override
  List<Object?> get props => [message];
}
