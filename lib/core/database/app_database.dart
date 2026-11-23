import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

part 'app_database.g.dart';

@DataClassName('OgeGrammarTaskRow')
class OgeGrammarTasks extends Table {
  TextColumn get id => text()();
  TextColumn get baseWord => text()();
  TextColumn get sentenceBefore => text()();
  TextColumn get sentenceAfter => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get acceptableAnswersJson => text()();
  TextColumn get ruleCategory => text()();
  TextColumn get ruleExplanation => text()();
  TextColumn get cefrLevel => text().withDefault(const Constant('A2'))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OgeWordFormationTaskRow')
class OgeWordFormationTasks extends Table {
  TextColumn get id => text()();
  TextColumn get baseWord => text()();
  TextColumn get sentenceBefore => text()();
  TextColumn get sentenceAfter => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get acceptableAnswersJson => text()();
  TextColumn get partOfSpeech => text()();
  TextColumn get affix => text()();
  TextColumn get explanation => text()();
  TextColumn get cefrLevel => text().withDefault(const Constant('A2'))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('IbInquiryUnitRow')
class IbInquiryUnits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get phase => text()();
  TextColumn get globalContext => text()();
  TextColumn get keyConcept => text()();
  TextColumn get relatedConceptsJson => text()();
  TextColumn get statementOfInquiry => text()();
  TextColumn get inquiryQuestionsJson => text()();
  TextColumn get criteriaTasksJson => text()();
  IntColumn get completedTasksCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SrsCardRow')
class SrsCards extends Table {
  TextColumn get id => text()();
  TextColumn get frontEnglish => text()();
  TextColumn get backRussian => text()();
  TextColumn get transcriptionIpa => text().nullable()();
  TextColumn get level => text().withDefault(const Constant('B1'))();
  TextColumn get category => text().withDefault(const Constant('OGE_Topic'))();
  TextColumn get exampleSentence => text().nullable()();
  TextColumn get exampleTranslation => text().nullable()();
  TextColumn get fsrsState => text().withDefault(const Constant('newCard'))();
  RealColumn get stability => real().withDefault(const Constant(0.0))();
  RealColumn get difficulty => real().withDefault(const Constant(0.0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StudyGoalRow')
class StudyGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  IntColumn get targetValue => integer()();
  IntColumn get currentValue => integer()();
  TextColumn get unit => text()();
  IntColumn get deadlineDays => integer()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserProgressRow')
class UserProgressTable extends Table {
  TextColumn get id => text()();
  IntColumn get ogeScore => integer().withDefault(const Constant(0))();
  IntColumn get grammarCompletedCount => integer().withDefault(const Constant(0))();
  IntColumn get wordFormationCompletedCount => integer().withDefault(const Constant(0))();
  IntColumn get ibCompletedTasksCount => integer().withDefault(const Constant(0))();
  IntColumn get srsMasteredCount => integer().withDefault(const Constant(0))();
  IntColumn get streakDays => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastPracticeAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserBadgeRow')
class UserBadges extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  TextColumn get category => text()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExamAttemptRow')
class ExamAttempts extends Table {
  TextColumn get id => text()();
  IntColumn get scoreOutOf68 => integer()();
  IntColumn get gradeMark => integer()();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  OgeGrammarTasks,
  OgeWordFormationTasks,
  IbInquiryUnits,
  SrsCards,
  StudyGoals,
  UserProgressTable,
  UserBadges,
  ExamAttempts,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? driftDatabase(name: 'english_for_children_db'));

  @override
  int get schemaVersion => 1;

  // ---------------- OGE Grammar Tasks ----------------
  Future<List<OgeGrammarTaskRow>> getAllGrammarTasks() => select(ogeGrammarTasks).get();

  Future<void> markGrammarTaskCompleted(String id) async {
    await (update(ogeGrammarTasks)..where((t) => t.id.equals(id)))
        .write(const OgeGrammarTasksCompanion(isCompleted: Value(true)));
    await _incrementGrammarProgress();
  }

  Future<void> _incrementGrammarProgress() async {
    final count = await (select(ogeGrammarTasks)..where((t) => t.isCompleted.equals(true))).get();
    await (update(userProgressTable)..where((t) => t.id.equals('current_user'))).write(
      UserProgressTableCompanion(
        grammarCompletedCount: Value(count.length),
        lastPracticeAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------- OGE Word Formation Tasks ----------------
  Future<List<OgeWordFormationTaskRow>> getAllWordFormationTasks() => select(ogeWordFormationTasks).get();

  Future<void> markWordFormationTaskCompleted(String id) async {
    await (update(ogeWordFormationTasks)..where((t) => t.id.equals(id)))
        .write(const OgeWordFormationTasksCompanion(isCompleted: Value(true)));
    await _incrementWordFormationProgress();
  }

  Future<void> _incrementWordFormationProgress() async {
    final count = await (select(ogeWordFormationTasks)..where((t) => t.isCompleted.equals(true))).get();
    await (update(userProgressTable)..where((t) => t.id.equals('current_user'))).write(
      UserProgressTableCompanion(
        wordFormationCompletedCount: Value(count.length),
        lastPracticeAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------- IB Inquiry Units ----------------
  Future<List<IbInquiryUnitRow>> getAllIbUnits() => select(ibInquiryUnits).get();

  Future<void> incrementIbTaskCompleted(String unitId) async {
    final unit = await (select(ibInquiryUnits)..where((t) => t.id.equals(unitId))).getSingleOrNull();
    if (unit != null) {
      await (update(ibInquiryUnits)..where((t) => t.id.equals(unitId))).write(
        IbInquiryUnitsCompanion(
          completedTasksCount: Value(unit.completedTasksCount + 1),
        ),
      );
    }
  }

  // ---------------- SRS Cards ----------------
  Future<List<SrsCardRow>> getAllSrsCards() => select(srsCards).get();

  Future<List<SrsCardRow>> getDueSrsCards() {
    final now = DateTime.now();
    return (select(srsCards)..where((t) => t.dueAt.isSmallerOrEqualValue(now))).get();
  }

  Future<void> updateSrsCard(SrsCardsCompanion card) =>
      into(srsCards).insertOnConflictUpdate(card);

  // ---------------- Study Goals ----------------
  Future<List<StudyGoalRow>> getAllGoals() => select(studyGoals).get();

  Future<void> updateGoalProgress(String id, int newValue) =>
      (update(studyGoals)..where((t) => t.id.equals(id))).write(
        StudyGoalsCompanion(currentValue: Value(newValue)),
      );

  // ---------------- User Progress ----------------
  Future<UserProgressRow> getUserProgress() async {
    var row = await (select(userProgressTable)..where((t) => t.id.equals('current_user'))).getSingleOrNull();
    if (row == null) {
      final initial = UserProgressTableCompanion.insert(
        id: 'current_user',
        ogeScore: const Value(45),
        grammarCompletedCount: const Value(0),
        wordFormationCompletedCount: const Value(0),
        ibCompletedTasksCount: const Value(0),
        srsMasteredCount: const Value(8),
        streakDays: const Value(5),
        lastPracticeAt: Value(DateTime.now()),
      );
      await into(userProgressTable).insert(initial);
      row = await (select(userProgressTable)..where((t) => t.id.equals('current_user'))).getSingle();
    }
    return row;
  }

  // ---------------- Badges ----------------
  Future<List<UserBadgeRow>> getAllBadges() => select(userBadges).get();

  Future<void> unlockBadge(String badgeId) =>
      (update(userBadges)..where((t) => t.id.equals(badgeId))).write(
        UserBadgesCompanion(
          isUnlocked: const Value(true),
          unlockedAt: Value(DateTime.now()),
        ),
      );

  // ---------------- Exam Attempts ----------------
  Future<void> recordExamAttempt(ExamAttemptsCompanion attempt) =>
      into(examAttempts).insert(attempt);

  Future<List<ExamAttemptRow>> getRecentExamAttempts({int limit = 5}) =>
      (select(examAttempts)
            ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
            ..limit(limit))
          .get();

  // ---------------- Seed Initializer ----------------
  Future<void> seedDatabaseIfEmpty() async {
    final grammarCount = await countGrammarTasks();
    if (grammarCount == 0) {
      await _seedGrammar();
      await _seedWordFormation();
      await _seedIbUnits();
      await _seedSrsCards();
      await _seedGoals();
      await _seedBadges();
      await getUserProgress();
    }
  }

  Future<int> countGrammarTasks() async {
    final count = countAll();
    final row = await (selectOnly(ogeGrammarTasks)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> _seedGrammar() async {
    final raw = await rootBundle.loadString('assets/seed/oge_grammar_seed.json');
    final list = jsonDecode(raw) as List;
    for (final item in list) {
      await into(ogeGrammarTasks).insertOnConflictUpdate(
        OgeGrammarTasksCompanion.insert(
          id: item['id'] as String,
          baseWord: item['baseWord'] as String,
          sentenceBefore: item['sentenceBefore'] as String,
          sentenceAfter: item['sentenceAfter'] as String,
          correctAnswer: item['correctAnswer'] as String,
          acceptableAnswersJson: jsonEncode(item['acceptableAnswers']),
          ruleCategory: item['ruleCategory'] as String,
          ruleExplanation: item['ruleExplanation'] as String,
          cefrLevel: Value(item['cefrLevel'] as String? ?? 'A2'),
        ),
      );
    }
  }

  Future<void> _seedWordFormation() async {
    final raw = await rootBundle.loadString('assets/seed/oge_word_formation_seed.json');
    final list = jsonDecode(raw) as List;
    for (final item in list) {
      await into(ogeWordFormationTasks).insertOnConflictUpdate(
        OgeWordFormationTasksCompanion.insert(
          id: item['id'] as String,
          baseWord: item['baseWord'] as String,
          sentenceBefore: item['sentenceBefore'] as String,
          sentenceAfter: item['sentenceAfter'] as String,
          correctAnswer: item['correctAnswer'] as String,
          acceptableAnswersJson: jsonEncode(item['acceptableAnswers']),
          partOfSpeech: item['partOfSpeech'] as String,
          affix: item['affix'] as String,
          explanation: item['explanation'] as String,
          cefrLevel: Value(item['cefrLevel'] as String? ?? 'A2'),
        ),
      );
    }
  }

  Future<void> _seedIbUnits() async {
    final raw = await rootBundle.loadString('assets/seed/ib_inquiry_seed.json');
    final list = jsonDecode(raw) as List;
    for (final item in list) {
      await into(ibInquiryUnits).insertOnConflictUpdate(
        IbInquiryUnitsCompanion.insert(
          id: item['id'] as String,
          title: item['title'] as String,
          phase: item['phase'] as String,
          globalContext: item['globalContext'] as String,
          keyConcept: item['keyConcept'] as String,
          relatedConceptsJson: jsonEncode(item['relatedConcepts']),
          statementOfInquiry: item['statementOfInquiry'] as String,
          inquiryQuestionsJson: jsonEncode(item['inquiryQuestions']),
          criteriaTasksJson: jsonEncode(item['criteriaTasks']),
        ),
      );
    }
  }

  Future<void> _seedSrsCards() async {
    final raw = await rootBundle.loadString('assets/seed/srs_seed.json');
    final list = jsonDecode(raw) as List;
    final now = DateTime.now();
    for (final item in list) {
      await into(srsCards).insertOnConflictUpdate(
        SrsCardsCompanion.insert(
          id: item['id'] as String,
          frontEnglish: item['frontEnglish'] as String,
          backRussian: item['backRussian'] as String,
          transcriptionIpa: Value(item['transcriptionIpa'] as String?),
          level: Value(item['level'] as String? ?? 'B1'),
          category: Value(item['category'] as String? ?? 'OGE_Topic'),
          exampleSentence: Value(item['exampleSentence'] as String?),
          exampleTranslation: Value(item['exampleTranslation'] as String?),
          dueAt: now,
        ),
      );
    }
  }

  Future<void> _seedGoals() async {
    final raw = await rootBundle.loadString('assets/seed/goals_seed.json');
    final list = jsonDecode(raw) as List;
    for (final item in list) {
      await into(studyGoals).insertOnConflictUpdate(
        StudyGoalsCompanion.insert(
          id: item['id'] as String,
          title: item['title'] as String,
          description: item['description'] as String,
          category: item['category'] as String,
          targetValue: item['targetValue'] as int,
          currentValue: item['currentValue'] as int,
          unit: item['unit'] as String,
          deadlineDays: item['deadlineDays'] as int,
          isPrimary: Value(item['isPrimary'] as bool? ?? false),
        ),
      );
    }
  }

  Future<void> _seedBadges() async {
    final raw = await rootBundle.loadString('assets/seed/badges_seed.json');
    final list = jsonDecode(raw) as List;
    for (final item in list) {
      await into(userBadges).insertOnConflictUpdate(
        UserBadgesCompanion.insert(
          id: item['id'] as String,
          title: item['title'] as String,
          description: item['description'] as String,
          icon: item['icon'] as String,
          category: item['category'] as String,
          isUnlocked: Value(item['isUnlocked'] as bool? ?? false),
        ),
      );
    }
  }
}
