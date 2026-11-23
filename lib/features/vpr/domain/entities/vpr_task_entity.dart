import 'package:equatable/equatable.dart';

enum VprTaskType {
  readingAloud('Задание 1: Чтение вслух', '🗣️'),
  listening('Задание 2: Аудирование (True/False/Not Stated)', '🎧'),
  textMatching('Задание 3: Понимание текстов (Matching)', '📖'),
  grammarVocab('Задание 4: Грамматика и лексика', '✍️');

  final String label;
  final String emoji;
  const VprTaskType(this.label, this.emoji);

  static VprTaskType fromString(String val) {
    return switch (val) {
      'reading_aloud' => VprTaskType.readingAloud,
      'listening' => VprTaskType.listening,
      'text_matching' => VprTaskType.textMatching,
      _ => VprTaskType.grammarVocab,
    };
  }
}

class VprTaskEntity extends Equatable {
  final String id;
  final int grade; // 5, 6, 7
  final int taskNumber;
  final VprTaskType taskType;
  final String title;
  final String instructions;
  final String? textPassage;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final bool isCompleted;

  const VprTaskEntity({
    required this.id,
    required this.grade,
    required this.taskNumber,
    required this.taskType,
    required this.title,
    required this.instructions,
    this.textPassage,
    this.options = const [],
    required this.correctAnswer,
    this.explanation,
    this.isCompleted = false,
  });

  VprTaskEntity copyWith({
    String? id,
    int? grade,
    int? taskNumber,
    VprTaskType? taskType,
    String? title,
    String? instructions,
    String? textPassage,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    bool? isCompleted,
  }) {
    return VprTaskEntity(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      taskNumber: taskNumber ?? this.taskNumber,
      taskType: taskType ?? this.taskType,
      title: title ?? this.title,
      instructions: instructions ?? this.instructions,
      textPassage: textPassage ?? this.textPassage,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        grade,
        taskNumber,
        taskType,
        title,
        instructions,
        textPassage,
        options,
        correctAnswer,
        explanation,
        isCompleted,
      ];
}
