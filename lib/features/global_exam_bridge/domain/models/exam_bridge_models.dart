enum InternationalExamTrack { toefl, ielts }

class BridgeReadingQuestion {
  final String prompt;
  final InternationalExamTrack format;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const BridgeReadingQuestion({
    required this.prompt,
    required this.format,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class BridgeReadingPassage {
  final String id;
  final String title;
  final String topicTag;
  final String text;
  final List<String> keyVocabulary;
  final List<BridgeReadingQuestion> questions;

  const BridgeReadingPassage({
    required this.id,
    required this.title,
    required this.topicTag,
    required this.text,
    required this.keyVocabulary,
    required this.questions,
  });
}

class BridgeListeningTask {
  final String id;
  final String title;
  final InternationalExamTrack examType;
  final String accentCode;
  final String transcript;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String rationale;

  const BridgeListeningTask({
    required this.id,
    required this.title,
    required this.examType,
    required this.accentCode,
    required this.transcript,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.rationale,
  });
}

class BridgeSpeakingPrompt {
  final String id;
  final InternationalExamTrack examType;
  final String topic;
  final String prompt;
  final List<String> bulletPoints;
  final int prepSeconds;
  final int speakSeconds;
  final List<String> usefulPhrases;

  const BridgeSpeakingPrompt({
    required this.id,
    required this.examType,
    required this.topic,
    required this.prompt,
    required this.bulletPoints,
    required this.prepSeconds,
    required this.speakSeconds,
    required this.usefulPhrases,
  });
}

class BridgeWritingPrompt {
  final String id;
  final InternationalExamTrack examType;
  final String title;
  final String scenario;
  final int targetWords;
  final int timerMinutes;
  final List<String> starterFrames;

  const BridgeWritingPrompt({
    required this.id,
    required this.examType,
    required this.title,
    required this.scenario,
    required this.targetWords,
    required this.timerMinutes,
    required this.starterFrames,
  });
}
