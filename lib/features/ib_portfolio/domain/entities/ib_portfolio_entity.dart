import 'package:equatable/equatable.dart';

class IbPortfolioEntity extends Equatable {
  final String id;
  final String unitId;
  final String unitTitle;
  final String criterion; // Criterion A, B, C, D
  final String taskTitle;
  final String content;
  final int scoreOutOf8;
  final DateTime createdAt;

  const IbPortfolioEntity({
    required this.id,
    required this.unitId,
    required this.unitTitle,
    required this.criterion,
    required this.taskTitle,
    required this.content,
    required this.scoreOutOf8,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        unitId,
        unitTitle,
        criterion,
        taskTitle,
        content,
        scoreOutOf8,
        createdAt,
      ];
}

class IbScoreSummary extends Equatable {
  final int criterionA;
  final int criterionB;
  final int criterionC;
  final int criterionD;

  const IbScoreSummary({
    required this.criterionA,
    required this.criterionB,
    required this.criterionC,
    required this.criterionD,
  });

  int get totalOutOf32 => criterionA + criterionB + criterionC + criterionD;

  int get ibFinalGrade {
    final t = totalOutOf32;
    if (t >= 28) return 7;
    if (t >= 24) return 6;
    if (t >= 19) return 5;
    if (t >= 15) return 4;
    if (t >= 10) return 3;
    if (t >= 6) return 2;
    return 1;
  }

  String get ibGradeDescriptor {
    switch (ibFinalGrade) {
      case 7:
        return 'Grade 7 • Excellent (Выдающийся академический уровень)';
      case 6:
        return 'Grade 6 • Very Good (Высокий уровень владения языком)';
      case 5:
        return 'Grade 5 • Good (Хороший уверенный уровень)';
      case 4:
        return 'Grade 4 • Satisfactory (Базовый стандарт MYP)';
      case 3:
        return 'Grade 3 • Mediocre (Требуется дополнительная практика)';
      case 2:
        return 'Grade 2 • Poor';
      default:
        return 'Grade 1 • Very Poor';
    }
  }

  @override
  List<Object?> get props => [criterionA, criterionB, criterionC, criterionD];
}
