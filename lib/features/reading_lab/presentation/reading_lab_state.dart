import 'package:equatable/equatable.dart';
import '../domain/entities/reading_story_entity.dart';

sealed class ReadingLabState extends Equatable {
  const ReadingLabState();

  @override
  List<Object?> get props => [];
}

final class ReadingLabInitial extends ReadingLabState {
  const ReadingLabInitial();
}

final class ReadingLabLoading extends ReadingLabState {
  const ReadingLabLoading();
}

final class ReadingLabLoaded extends ReadingLabState {
  final List<ReadingStoryEntity> allStories;
  final List<ReadingStoryEntity> displayedStories;
  final int? selectedGrade;

  const ReadingLabLoaded({
    required this.allStories,
    required this.displayedStories,
    this.selectedGrade,
  });

  ReadingLabLoaded copyWith({
    List<ReadingStoryEntity>? allStories,
    List<ReadingStoryEntity>? displayedStories,
    int? selectedGrade,
    bool clearGrade = false,
  }) {
    return ReadingLabLoaded(
      allStories: allStories ?? this.allStories,
      displayedStories: displayedStories ?? this.displayedStories,
      selectedGrade: clearGrade ? null : (selectedGrade ?? this.selectedGrade),
    );
  }

  @override
  List<Object?> get props => [allStories, displayedStories, selectedGrade];
}

final class ReadingLabErrorState extends ReadingLabState {
  final String message;
  const ReadingLabErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
