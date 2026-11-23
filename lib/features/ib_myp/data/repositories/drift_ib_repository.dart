import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/ib_unit_entity.dart';
import '../../domain/repositories/ib_repository.dart';

class DriftIbRepository implements IbRepository {
  final AppDatabase _db;

  DriftIbRepository(this._db);

  @override
  Future<Result<List<IbInquiryUnitEntity>>> getIbUnits() async {
    try {
      final rows = await _db.getAllIbUnits();
      final entities = rows.map((r) {
        final relConcepts = (jsonDecode(r.relatedConceptsJson) as List).cast<String>();
        final qJson = jsonDecode(r.inquiryQuestionsJson) as Map<String, dynamic>;
        final questions = IbInquiryQuestionsEntity(
          factual: qJson['factual'] as String? ?? '',
          conceptual: qJson['conceptual'] as String? ?? '',
          debatable: qJson['debatable'] as String? ?? '',
        );

        final tasksList = jsonDecode(r.criteriaTasksJson) as List;
        final criteriaTasks = tasksList.map((t) {
          final map = t as Map<String, dynamic>;
          return IbCriterionTaskEntity(
            criterion: map['criterion'] as String,
            skill: map['skill'] as String,
            taskTitle: map['taskTitle'] as String,
            prompt: map['prompt'] as String,
            maxScore: map['maxScore'] as int? ?? 8,
          );
        }).toList();

        return IbInquiryUnitEntity(
          id: r.id,
          title: r.title,
          phase: r.phase,
          globalContext: r.globalContext,
          keyConcept: r.keyConcept,
          relatedConcepts: relConcepts,
          statementOfInquiry: r.statementOfInquiry,
          inquiryQuestions: questions,
          criteriaTasks: criteriaTasks,
          completedTasksCount: r.completedTasksCount,
        );
      }).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load IB Units: $e', st));
    }
  }

  @override
  Future<Result<void>> markTaskCompleted(String unitId) async {
    try {
      await _db.incrementIbTaskCompleted(unitId);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to mark IB task completed: $e', st));
    }
  }
}
