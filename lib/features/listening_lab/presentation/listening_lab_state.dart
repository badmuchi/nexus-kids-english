import 'package:equatable/equatable.dart';
import '../domain/entities/minimal_pair_entity.dart';

sealed class ListeningLabState extends Equatable {
  const ListeningLabState();

  @override
  List<Object?> get props => [];
}

final class ListeningLabInitial extends ListeningLabState {
  const ListeningLabInitial();
}

final class ListeningLabLoading extends ListeningLabState {
  const ListeningLabLoading();
}

final class ListeningLabActive extends ListeningLabState {
  final List<MinimalPairEntity> pairs;
  final int currentIndex;
  final String targetWord;
  final String? selectedChoice;
  final bool? isCorrect;
  final int score;

  const ListeningLabActive({
    required this.pairs,
    required this.currentIndex,
    required this.targetWord,
    this.selectedChoice,
    this.isCorrect,
    this.score = 0,
  });

  MinimalPairEntity get currentPair => pairs[currentIndex];

  ListeningLabActive copyWith({
    List<MinimalPairEntity>? pairs,
    int? currentIndex,
    String? targetWord,
    String? selectedChoice,
    bool? isCorrect,
    int? score,
  }) {
    return ListeningLabActive(
      pairs: pairs ?? this.pairs,
      currentIndex: currentIndex ?? this.currentIndex,
      targetWord: targetWord ?? this.targetWord,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      isCorrect: isCorrect,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [
        pairs,
        currentIndex,
        targetWord,
        selectedChoice,
        isCorrect,
        score,
      ];
}

final class ListeningLabErrorState extends ListeningLabState {
  final String message;
  const ListeningLabErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
