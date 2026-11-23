import 'package:equatable/equatable.dart';

class DuelQuestionEntity extends Equatable {
  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String type;

  const DuelQuestionEntity({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.type,
  });

  @override
  List<Object?> get props => [id, prompt, options, correctIndex, type];
}
