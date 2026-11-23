import 'package:equatable/equatable.dart';

class IbWritingTaskEntity extends Equatable {
  final String id;
  final String format; // Informal Email, School Blog Post, Campaign Poster
  final String title;
  final String globalContext;
  final String instructions;
  final int minWords;
  final int maxWords;
  final List<String> requiredPrompts;
  final String sampleTemplate;
  final String? savedText;
  final double? scoreOutOf8;
  final bool isCompleted;

  const IbWritingTaskEntity({
    required this.id,
    required this.format,
    required this.title,
    required this.globalContext,
    required this.instructions,
    required this.minWords,
    required this.maxWords,
    required this.requiredPrompts,
    required this.sampleTemplate,
    this.savedText,
    this.scoreOutOf8,
    this.isCompleted = false,
  });

  IbWritingTaskEntity copyWith({
    String? id,
    String? format,
    String? title,
    String? globalContext,
    String? instructions,
    int? minWords,
    int? maxWords,
    List<String>? requiredPrompts,
    String? sampleTemplate,
    String? savedText,
    double? scoreOutOf8,
    bool? isCompleted,
  }) {
    return IbWritingTaskEntity(
      id: id ?? this.id,
      format: format ?? this.format,
      title: title ?? this.title,
      globalContext: globalContext ?? this.globalContext,
      instructions: instructions ?? this.instructions,
      minWords: minWords ?? this.minWords,
      maxWords: maxWords ?? this.maxWords,
      requiredPrompts: requiredPrompts ?? this.requiredPrompts,
      sampleTemplate: sampleTemplate ?? this.sampleTemplate,
      savedText: savedText ?? this.savedText,
      scoreOutOf8: scoreOutOf8 ?? this.scoreOutOf8,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        format,
        title,
        globalContext,
        instructions,
        minWords,
        maxWords,
        requiredPrompts,
        sampleTemplate,
        savedText,
        scoreOutOf8,
        isCompleted,
      ];
}
