import 'package:equatable/equatable.dart';

class MistakeEntity extends Equatable {
  final String id;
  final String taskType; // GRAMMAR, WORD_FORMATION, LISTENING, READING
  final String prompt;
  final String wrongAnswer;
  final String correctAnswer;
  final String explanation;
  final int masteryStreak; // 0..3 (3 consecutive correct answers marks as resolved)
  final bool isResolved;
  final DateTime lastAttemptAt;

  const MistakeEntity({
    required this.id,
    required this.taskType,
    required this.prompt,
    required this.wrongAnswer,
    required this.correctAnswer,
    required this.explanation,
    required this.masteryStreak,
    required this.isResolved,
    required this.lastAttemptAt,
  });

  MistakeEntity copyWith({
    String? id,
    String? taskType,
    String? prompt,
    String? wrongAnswer,
    String? correctAnswer,
    String? explanation,
    int? masteryStreak,
    bool? isResolved,
    DateTime? lastAttemptAt,
  }) {
    return MistakeEntity(
      id: id ?? this.id,
      taskType: taskType ?? this.taskType,
      prompt: prompt ?? this.prompt,
      wrongAnswer: wrongAnswer ?? this.wrongAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      masteryStreak: masteryStreak ?? this.masteryStreak,
      isResolved: isResolved ?? this.isResolved,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        taskType,
        prompt,
        wrongAnswer,
        correctAnswer,
        explanation,
        masteryStreak,
        isResolved,
        lastAttemptAt,
      ];
}
