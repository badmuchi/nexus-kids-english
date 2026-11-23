import 'package:equatable/equatable.dart';

class StudyGoalEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final int targetValue;
  final int currentValue;
  final String unit;
  final int deadlineDays;
  final bool isPrimary;

  const StudyGoalEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.deadlineDays,
    this.isPrimary = false,
  });

  double get progressFraction => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
  int get progressPercent => (progressFraction * 100).toInt();

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        targetValue,
        currentValue,
        unit,
        deadlineDays,
        isPrimary,
      ];
}
