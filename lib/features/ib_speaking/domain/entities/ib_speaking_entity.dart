import 'package:equatable/equatable.dart';

class IbSpeakingTaskEntity extends Equatable {
  final String id;
  final String title;
  final String globalContext;
  final String topic;
  final String imageEmoji;
  final String description;
  final int prepTimeSeconds;
  final int speakTimeSeconds;
  final List<String> guidingQuestions;
  final List<String> phraseBank;
  final String sampleAnswer;
  final bool isCompleted;
  final int? scoreOutOf8;

  const IbSpeakingTaskEntity({
    required this.id,
    required this.title,
    required this.globalContext,
    required this.topic,
    required this.imageEmoji,
    required this.description,
    this.prepTimeSeconds = 60,
    this.speakTimeSeconds = 90,
    required this.guidingQuestions,
    required this.phraseBank,
    required this.sampleAnswer,
    this.isCompleted = false,
    this.scoreOutOf8,
  });

  IbSpeakingTaskEntity copyWith({
    String? id,
    String? title,
    String? globalContext,
    String? topic,
    String? imageEmoji,
    String? description,
    int? prepTimeSeconds,
    int? speakTimeSeconds,
    List<String>? guidingQuestions,
    List<String>? phraseBank,
    String? sampleAnswer,
    bool? isCompleted,
    int? scoreOutOf8,
  }) {
    return IbSpeakingTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      globalContext: globalContext ?? this.globalContext,
      topic: topic ?? this.topic,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      description: description ?? this.description,
      prepTimeSeconds: prepTimeSeconds ?? this.prepTimeSeconds,
      speakTimeSeconds: speakTimeSeconds ?? this.speakTimeSeconds,
      guidingQuestions: guidingQuestions ?? this.guidingQuestions,
      phraseBank: phraseBank ?? this.phraseBank,
      sampleAnswer: sampleAnswer ?? this.sampleAnswer,
      isCompleted: isCompleted ?? this.isCompleted,
      scoreOutOf8: scoreOutOf8 ?? this.scoreOutOf8,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        globalContext,
        topic,
        imageEmoji,
        description,
        prepTimeSeconds,
        speakTimeSeconds,
        guidingQuestions,
        phraseBank,
        sampleAnswer,
        isCompleted,
        scoreOutOf8,
      ];
}
