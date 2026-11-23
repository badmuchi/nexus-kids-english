import 'package:equatable/equatable.dart';

class IbCriterionTaskEntity extends Equatable {
  final String criterion;
  final String skill;
  final String taskTitle;
  final String prompt;
  final int maxScore;

  const IbCriterionTaskEntity({
    required this.criterion,
    required this.skill,
    required this.taskTitle,
    required this.prompt,
    required this.maxScore,
  });

  @override
  List<Object?> get props => [criterion, skill, taskTitle, prompt, maxScore];
}

class IbInquiryQuestionsEntity extends Equatable {
  final String factual;
  final String conceptual;
  final String debatable;

  const IbInquiryQuestionsEntity({
    required this.factual,
    required this.conceptual,
    required this.debatable,
  });

  @override
  List<Object?> get props => [factual, conceptual, debatable];
}

class IbInquiryUnitEntity extends Equatable {
  final String id;
  final String title;
  final String phase;
  final String globalContext;
  final String keyConcept;
  final List<String> relatedConcepts;
  final String statementOfInquiry;
  final IbInquiryQuestionsEntity inquiryQuestions;
  final List<IbCriterionTaskEntity> criteriaTasks;
  final int completedTasksCount;

  const IbInquiryUnitEntity({
    required this.id,
    required this.title,
    required this.phase,
    required this.globalContext,
    required this.keyConcept,
    required this.relatedConcepts,
    required this.statementOfInquiry,
    required this.inquiryQuestions,
    required this.criteriaTasks,
    this.completedTasksCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        phase,
        globalContext,
        keyConcept,
        relatedConcepts,
        statementOfInquiry,
        inquiryQuestions,
        criteriaTasks,
        completedTasksCount,
      ];
}
