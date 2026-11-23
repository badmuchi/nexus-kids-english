import 'package:equatable/equatable.dart';

sealed class ReadingLabEvent extends Equatable {
  const ReadingLabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadReadingStoriesEvent extends ReadingLabEvent {
  const LoadReadingStoriesEvent();
}

final class FilterStoriesByGradeEvent extends ReadingLabEvent {
  final int? grade;
  const FilterStoriesByGradeEvent(this.grade);

  @override
  List<Object?> get props => [grade];
}

final class SubmitStoryQuizScoreEvent extends ReadingLabEvent {
  final String storyId;
  final int score;

  const SubmitStoryQuizScoreEvent({
    required this.storyId,
    required this.score,
  });

  @override
  List<Object?> get props => [storyId, score];
}
