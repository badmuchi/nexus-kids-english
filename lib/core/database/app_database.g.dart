// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OgeGrammarTasksTable extends OgeGrammarTasks
    with TableInfo<$OgeGrammarTasksTable, OgeGrammarTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OgeGrammarTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseWordMeta =
      const VerificationMeta('baseWord');
  @override
  late final GeneratedColumn<String> baseWord = GeneratedColumn<String>(
      'base_word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentenceBeforeMeta =
      const VerificationMeta('sentenceBefore');
  @override
  late final GeneratedColumn<String> sentenceBefore = GeneratedColumn<String>(
      'sentence_before', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentenceAfterMeta =
      const VerificationMeta('sentenceAfter');
  @override
  late final GeneratedColumn<String> sentenceAfter = GeneratedColumn<String>(
      'sentence_after', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _acceptableAnswersJsonMeta =
      const VerificationMeta('acceptableAnswersJson');
  @override
  late final GeneratedColumn<String> acceptableAnswersJson =
      GeneratedColumn<String>('acceptable_answers_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ruleCategoryMeta =
      const VerificationMeta('ruleCategory');
  @override
  late final GeneratedColumn<String> ruleCategory = GeneratedColumn<String>(
      'rule_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ruleExplanationMeta =
      const VerificationMeta('ruleExplanation');
  @override
  late final GeneratedColumn<String> ruleExplanation = GeneratedColumn<String>(
      'rule_explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cefrLevelMeta =
      const VerificationMeta('cefrLevel');
  @override
  late final GeneratedColumn<String> cefrLevel = GeneratedColumn<String>(
      'cefr_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A2'));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        baseWord,
        sentenceBefore,
        sentenceAfter,
        correctAnswer,
        acceptableAnswersJson,
        ruleCategory,
        ruleExplanation,
        cefrLevel,
        isCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'oge_grammar_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<OgeGrammarTaskRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_word')) {
      context.handle(_baseWordMeta,
          baseWord.isAcceptableOrUnknown(data['base_word']!, _baseWordMeta));
    } else if (isInserting) {
      context.missing(_baseWordMeta);
    }
    if (data.containsKey('sentence_before')) {
      context.handle(
          _sentenceBeforeMeta,
          sentenceBefore.isAcceptableOrUnknown(
              data['sentence_before']!, _sentenceBeforeMeta));
    } else if (isInserting) {
      context.missing(_sentenceBeforeMeta);
    }
    if (data.containsKey('sentence_after')) {
      context.handle(
          _sentenceAfterMeta,
          sentenceAfter.isAcceptableOrUnknown(
              data['sentence_after']!, _sentenceAfterMeta));
    } else if (isInserting) {
      context.missing(_sentenceAfterMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('acceptable_answers_json')) {
      context.handle(
          _acceptableAnswersJsonMeta,
          acceptableAnswersJson.isAcceptableOrUnknown(
              data['acceptable_answers_json']!, _acceptableAnswersJsonMeta));
    } else if (isInserting) {
      context.missing(_acceptableAnswersJsonMeta);
    }
    if (data.containsKey('rule_category')) {
      context.handle(
          _ruleCategoryMeta,
          ruleCategory.isAcceptableOrUnknown(
              data['rule_category']!, _ruleCategoryMeta));
    } else if (isInserting) {
      context.missing(_ruleCategoryMeta);
    }
    if (data.containsKey('rule_explanation')) {
      context.handle(
          _ruleExplanationMeta,
          ruleExplanation.isAcceptableOrUnknown(
              data['rule_explanation']!, _ruleExplanationMeta));
    } else if (isInserting) {
      context.missing(_ruleExplanationMeta);
    }
    if (data.containsKey('cefr_level')) {
      context.handle(_cefrLevelMeta,
          cefrLevel.isAcceptableOrUnknown(data['cefr_level']!, _cefrLevelMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OgeGrammarTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OgeGrammarTaskRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_word'])!,
      sentenceBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sentence_before'])!,
      sentenceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentence_after'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_answer'])!,
      acceptableAnswersJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}acceptable_answers_json'])!,
      ruleCategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_category'])!,
      ruleExplanation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rule_explanation'])!,
      cefrLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cefr_level'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $OgeGrammarTasksTable createAlias(String alias) {
    return $OgeGrammarTasksTable(attachedDatabase, alias);
  }
}

class OgeGrammarTaskRow extends DataClass
    implements Insertable<OgeGrammarTaskRow> {
  final String id;
  final String baseWord;
  final String sentenceBefore;
  final String sentenceAfter;
  final String correctAnswer;
  final String acceptableAnswersJson;
  final String ruleCategory;
  final String ruleExplanation;
  final String cefrLevel;
  final bool isCompleted;
  const OgeGrammarTaskRow(
      {required this.id,
      required this.baseWord,
      required this.sentenceBefore,
      required this.sentenceAfter,
      required this.correctAnswer,
      required this.acceptableAnswersJson,
      required this.ruleCategory,
      required this.ruleExplanation,
      required this.cefrLevel,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_word'] = Variable<String>(baseWord);
    map['sentence_before'] = Variable<String>(sentenceBefore);
    map['sentence_after'] = Variable<String>(sentenceAfter);
    map['correct_answer'] = Variable<String>(correctAnswer);
    map['acceptable_answers_json'] = Variable<String>(acceptableAnswersJson);
    map['rule_category'] = Variable<String>(ruleCategory);
    map['rule_explanation'] = Variable<String>(ruleExplanation);
    map['cefr_level'] = Variable<String>(cefrLevel);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  OgeGrammarTasksCompanion toCompanion(bool nullToAbsent) {
    return OgeGrammarTasksCompanion(
      id: Value(id),
      baseWord: Value(baseWord),
      sentenceBefore: Value(sentenceBefore),
      sentenceAfter: Value(sentenceAfter),
      correctAnswer: Value(correctAnswer),
      acceptableAnswersJson: Value(acceptableAnswersJson),
      ruleCategory: Value(ruleCategory),
      ruleExplanation: Value(ruleExplanation),
      cefrLevel: Value(cefrLevel),
      isCompleted: Value(isCompleted),
    );
  }

  factory OgeGrammarTaskRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OgeGrammarTaskRow(
      id: serializer.fromJson<String>(json['id']),
      baseWord: serializer.fromJson<String>(json['baseWord']),
      sentenceBefore: serializer.fromJson<String>(json['sentenceBefore']),
      sentenceAfter: serializer.fromJson<String>(json['sentenceAfter']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      acceptableAnswersJson:
          serializer.fromJson<String>(json['acceptableAnswersJson']),
      ruleCategory: serializer.fromJson<String>(json['ruleCategory']),
      ruleExplanation: serializer.fromJson<String>(json['ruleExplanation']),
      cefrLevel: serializer.fromJson<String>(json['cefrLevel']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseWord': serializer.toJson<String>(baseWord),
      'sentenceBefore': serializer.toJson<String>(sentenceBefore),
      'sentenceAfter': serializer.toJson<String>(sentenceAfter),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'acceptableAnswersJson': serializer.toJson<String>(acceptableAnswersJson),
      'ruleCategory': serializer.toJson<String>(ruleCategory),
      'ruleExplanation': serializer.toJson<String>(ruleExplanation),
      'cefrLevel': serializer.toJson<String>(cefrLevel),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  OgeGrammarTaskRow copyWith(
          {String? id,
          String? baseWord,
          String? sentenceBefore,
          String? sentenceAfter,
          String? correctAnswer,
          String? acceptableAnswersJson,
          String? ruleCategory,
          String? ruleExplanation,
          String? cefrLevel,
          bool? isCompleted}) =>
      OgeGrammarTaskRow(
        id: id ?? this.id,
        baseWord: baseWord ?? this.baseWord,
        sentenceBefore: sentenceBefore ?? this.sentenceBefore,
        sentenceAfter: sentenceAfter ?? this.sentenceAfter,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        acceptableAnswersJson:
            acceptableAnswersJson ?? this.acceptableAnswersJson,
        ruleCategory: ruleCategory ?? this.ruleCategory,
        ruleExplanation: ruleExplanation ?? this.ruleExplanation,
        cefrLevel: cefrLevel ?? this.cefrLevel,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  OgeGrammarTaskRow copyWithCompanion(OgeGrammarTasksCompanion data) {
    return OgeGrammarTaskRow(
      id: data.id.present ? data.id.value : this.id,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      sentenceBefore: data.sentenceBefore.present
          ? data.sentenceBefore.value
          : this.sentenceBefore,
      sentenceAfter: data.sentenceAfter.present
          ? data.sentenceAfter.value
          : this.sentenceAfter,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      acceptableAnswersJson: data.acceptableAnswersJson.present
          ? data.acceptableAnswersJson.value
          : this.acceptableAnswersJson,
      ruleCategory: data.ruleCategory.present
          ? data.ruleCategory.value
          : this.ruleCategory,
      ruleExplanation: data.ruleExplanation.present
          ? data.ruleExplanation.value
          : this.ruleExplanation,
      cefrLevel: data.cefrLevel.present ? data.cefrLevel.value : this.cefrLevel,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OgeGrammarTaskRow(')
          ..write('id: $id, ')
          ..write('baseWord: $baseWord, ')
          ..write('sentenceBefore: $sentenceBefore, ')
          ..write('sentenceAfter: $sentenceAfter, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('acceptableAnswersJson: $acceptableAnswersJson, ')
          ..write('ruleCategory: $ruleCategory, ')
          ..write('ruleExplanation: $ruleExplanation, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      baseWord,
      sentenceBefore,
      sentenceAfter,
      correctAnswer,
      acceptableAnswersJson,
      ruleCategory,
      ruleExplanation,
      cefrLevel,
      isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OgeGrammarTaskRow &&
          other.id == this.id &&
          other.baseWord == this.baseWord &&
          other.sentenceBefore == this.sentenceBefore &&
          other.sentenceAfter == this.sentenceAfter &&
          other.correctAnswer == this.correctAnswer &&
          other.acceptableAnswersJson == this.acceptableAnswersJson &&
          other.ruleCategory == this.ruleCategory &&
          other.ruleExplanation == this.ruleExplanation &&
          other.cefrLevel == this.cefrLevel &&
          other.isCompleted == this.isCompleted);
}

class OgeGrammarTasksCompanion extends UpdateCompanion<OgeGrammarTaskRow> {
  final Value<String> id;
  final Value<String> baseWord;
  final Value<String> sentenceBefore;
  final Value<String> sentenceAfter;
  final Value<String> correctAnswer;
  final Value<String> acceptableAnswersJson;
  final Value<String> ruleCategory;
  final Value<String> ruleExplanation;
  final Value<String> cefrLevel;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const OgeGrammarTasksCompanion({
    this.id = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.sentenceBefore = const Value.absent(),
    this.sentenceAfter = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.acceptableAnswersJson = const Value.absent(),
    this.ruleCategory = const Value.absent(),
    this.ruleExplanation = const Value.absent(),
    this.cefrLevel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OgeGrammarTasksCompanion.insert({
    required String id,
    required String baseWord,
    required String sentenceBefore,
    required String sentenceAfter,
    required String correctAnswer,
    required String acceptableAnswersJson,
    required String ruleCategory,
    required String ruleExplanation,
    this.cefrLevel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        baseWord = Value(baseWord),
        sentenceBefore = Value(sentenceBefore),
        sentenceAfter = Value(sentenceAfter),
        correctAnswer = Value(correctAnswer),
        acceptableAnswersJson = Value(acceptableAnswersJson),
        ruleCategory = Value(ruleCategory),
        ruleExplanation = Value(ruleExplanation);
  static Insertable<OgeGrammarTaskRow> custom({
    Expression<String>? id,
    Expression<String>? baseWord,
    Expression<String>? sentenceBefore,
    Expression<String>? sentenceAfter,
    Expression<String>? correctAnswer,
    Expression<String>? acceptableAnswersJson,
    Expression<String>? ruleCategory,
    Expression<String>? ruleExplanation,
    Expression<String>? cefrLevel,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseWord != null) 'base_word': baseWord,
      if (sentenceBefore != null) 'sentence_before': sentenceBefore,
      if (sentenceAfter != null) 'sentence_after': sentenceAfter,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (acceptableAnswersJson != null)
        'acceptable_answers_json': acceptableAnswersJson,
      if (ruleCategory != null) 'rule_category': ruleCategory,
      if (ruleExplanation != null) 'rule_explanation': ruleExplanation,
      if (cefrLevel != null) 'cefr_level': cefrLevel,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OgeGrammarTasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? baseWord,
      Value<String>? sentenceBefore,
      Value<String>? sentenceAfter,
      Value<String>? correctAnswer,
      Value<String>? acceptableAnswersJson,
      Value<String>? ruleCategory,
      Value<String>? ruleExplanation,
      Value<String>? cefrLevel,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return OgeGrammarTasksCompanion(
      id: id ?? this.id,
      baseWord: baseWord ?? this.baseWord,
      sentenceBefore: sentenceBefore ?? this.sentenceBefore,
      sentenceAfter: sentenceAfter ?? this.sentenceAfter,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      acceptableAnswersJson:
          acceptableAnswersJson ?? this.acceptableAnswersJson,
      ruleCategory: ruleCategory ?? this.ruleCategory,
      ruleExplanation: ruleExplanation ?? this.ruleExplanation,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseWord.present) {
      map['base_word'] = Variable<String>(baseWord.value);
    }
    if (sentenceBefore.present) {
      map['sentence_before'] = Variable<String>(sentenceBefore.value);
    }
    if (sentenceAfter.present) {
      map['sentence_after'] = Variable<String>(sentenceAfter.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (acceptableAnswersJson.present) {
      map['acceptable_answers_json'] =
          Variable<String>(acceptableAnswersJson.value);
    }
    if (ruleCategory.present) {
      map['rule_category'] = Variable<String>(ruleCategory.value);
    }
    if (ruleExplanation.present) {
      map['rule_explanation'] = Variable<String>(ruleExplanation.value);
    }
    if (cefrLevel.present) {
      map['cefr_level'] = Variable<String>(cefrLevel.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OgeGrammarTasksCompanion(')
          ..write('id: $id, ')
          ..write('baseWord: $baseWord, ')
          ..write('sentenceBefore: $sentenceBefore, ')
          ..write('sentenceAfter: $sentenceAfter, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('acceptableAnswersJson: $acceptableAnswersJson, ')
          ..write('ruleCategory: $ruleCategory, ')
          ..write('ruleExplanation: $ruleExplanation, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OgeWordFormationTasksTable extends OgeWordFormationTasks
    with TableInfo<$OgeWordFormationTasksTable, OgeWordFormationTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OgeWordFormationTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseWordMeta =
      const VerificationMeta('baseWord');
  @override
  late final GeneratedColumn<String> baseWord = GeneratedColumn<String>(
      'base_word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentenceBeforeMeta =
      const VerificationMeta('sentenceBefore');
  @override
  late final GeneratedColumn<String> sentenceBefore = GeneratedColumn<String>(
      'sentence_before', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentenceAfterMeta =
      const VerificationMeta('sentenceAfter');
  @override
  late final GeneratedColumn<String> sentenceAfter = GeneratedColumn<String>(
      'sentence_after', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _acceptableAnswersJsonMeta =
      const VerificationMeta('acceptableAnswersJson');
  @override
  late final GeneratedColumn<String> acceptableAnswersJson =
      GeneratedColumn<String>('acceptable_answers_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _affixMeta = const VerificationMeta('affix');
  @override
  late final GeneratedColumn<String> affix = GeneratedColumn<String>(
      'affix', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cefrLevelMeta =
      const VerificationMeta('cefrLevel');
  @override
  late final GeneratedColumn<String> cefrLevel = GeneratedColumn<String>(
      'cefr_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('A2'));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        baseWord,
        sentenceBefore,
        sentenceAfter,
        correctAnswer,
        acceptableAnswersJson,
        partOfSpeech,
        affix,
        explanation,
        cefrLevel,
        isCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'oge_word_formation_tasks';
  @override
  VerificationContext validateIntegrity(
      Insertable<OgeWordFormationTaskRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_word')) {
      context.handle(_baseWordMeta,
          baseWord.isAcceptableOrUnknown(data['base_word']!, _baseWordMeta));
    } else if (isInserting) {
      context.missing(_baseWordMeta);
    }
    if (data.containsKey('sentence_before')) {
      context.handle(
          _sentenceBeforeMeta,
          sentenceBefore.isAcceptableOrUnknown(
              data['sentence_before']!, _sentenceBeforeMeta));
    } else if (isInserting) {
      context.missing(_sentenceBeforeMeta);
    }
    if (data.containsKey('sentence_after')) {
      context.handle(
          _sentenceAfterMeta,
          sentenceAfter.isAcceptableOrUnknown(
              data['sentence_after']!, _sentenceAfterMeta));
    } else if (isInserting) {
      context.missing(_sentenceAfterMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('acceptable_answers_json')) {
      context.handle(
          _acceptableAnswersJsonMeta,
          acceptableAnswersJson.isAcceptableOrUnknown(
              data['acceptable_answers_json']!, _acceptableAnswersJsonMeta));
    } else if (isInserting) {
      context.missing(_acceptableAnswersJsonMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    } else if (isInserting) {
      context.missing(_partOfSpeechMeta);
    }
    if (data.containsKey('affix')) {
      context.handle(
          _affixMeta, affix.isAcceptableOrUnknown(data['affix']!, _affixMeta));
    } else if (isInserting) {
      context.missing(_affixMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('cefr_level')) {
      context.handle(_cefrLevelMeta,
          cefrLevel.isAcceptableOrUnknown(data['cefr_level']!, _cefrLevelMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OgeWordFormationTaskRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OgeWordFormationTaskRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_word'])!,
      sentenceBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sentence_before'])!,
      sentenceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentence_after'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_answer'])!,
      acceptableAnswersJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}acceptable_answers_json'])!,
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech'])!,
      affix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}affix'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      cefrLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cefr_level'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $OgeWordFormationTasksTable createAlias(String alias) {
    return $OgeWordFormationTasksTable(attachedDatabase, alias);
  }
}

class OgeWordFormationTaskRow extends DataClass
    implements Insertable<OgeWordFormationTaskRow> {
  final String id;
  final String baseWord;
  final String sentenceBefore;
  final String sentenceAfter;
  final String correctAnswer;
  final String acceptableAnswersJson;
  final String partOfSpeech;
  final String affix;
  final String explanation;
  final String cefrLevel;
  final bool isCompleted;
  const OgeWordFormationTaskRow(
      {required this.id,
      required this.baseWord,
      required this.sentenceBefore,
      required this.sentenceAfter,
      required this.correctAnswer,
      required this.acceptableAnswersJson,
      required this.partOfSpeech,
      required this.affix,
      required this.explanation,
      required this.cefrLevel,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_word'] = Variable<String>(baseWord);
    map['sentence_before'] = Variable<String>(sentenceBefore);
    map['sentence_after'] = Variable<String>(sentenceAfter);
    map['correct_answer'] = Variable<String>(correctAnswer);
    map['acceptable_answers_json'] = Variable<String>(acceptableAnswersJson);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    map['affix'] = Variable<String>(affix);
    map['explanation'] = Variable<String>(explanation);
    map['cefr_level'] = Variable<String>(cefrLevel);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  OgeWordFormationTasksCompanion toCompanion(bool nullToAbsent) {
    return OgeWordFormationTasksCompanion(
      id: Value(id),
      baseWord: Value(baseWord),
      sentenceBefore: Value(sentenceBefore),
      sentenceAfter: Value(sentenceAfter),
      correctAnswer: Value(correctAnswer),
      acceptableAnswersJson: Value(acceptableAnswersJson),
      partOfSpeech: Value(partOfSpeech),
      affix: Value(affix),
      explanation: Value(explanation),
      cefrLevel: Value(cefrLevel),
      isCompleted: Value(isCompleted),
    );
  }

  factory OgeWordFormationTaskRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OgeWordFormationTaskRow(
      id: serializer.fromJson<String>(json['id']),
      baseWord: serializer.fromJson<String>(json['baseWord']),
      sentenceBefore: serializer.fromJson<String>(json['sentenceBefore']),
      sentenceAfter: serializer.fromJson<String>(json['sentenceAfter']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      acceptableAnswersJson:
          serializer.fromJson<String>(json['acceptableAnswersJson']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      affix: serializer.fromJson<String>(json['affix']),
      explanation: serializer.fromJson<String>(json['explanation']),
      cefrLevel: serializer.fromJson<String>(json['cefrLevel']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseWord': serializer.toJson<String>(baseWord),
      'sentenceBefore': serializer.toJson<String>(sentenceBefore),
      'sentenceAfter': serializer.toJson<String>(sentenceAfter),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'acceptableAnswersJson': serializer.toJson<String>(acceptableAnswersJson),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'affix': serializer.toJson<String>(affix),
      'explanation': serializer.toJson<String>(explanation),
      'cefrLevel': serializer.toJson<String>(cefrLevel),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  OgeWordFormationTaskRow copyWith(
          {String? id,
          String? baseWord,
          String? sentenceBefore,
          String? sentenceAfter,
          String? correctAnswer,
          String? acceptableAnswersJson,
          String? partOfSpeech,
          String? affix,
          String? explanation,
          String? cefrLevel,
          bool? isCompleted}) =>
      OgeWordFormationTaskRow(
        id: id ?? this.id,
        baseWord: baseWord ?? this.baseWord,
        sentenceBefore: sentenceBefore ?? this.sentenceBefore,
        sentenceAfter: sentenceAfter ?? this.sentenceAfter,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        acceptableAnswersJson:
            acceptableAnswersJson ?? this.acceptableAnswersJson,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        affix: affix ?? this.affix,
        explanation: explanation ?? this.explanation,
        cefrLevel: cefrLevel ?? this.cefrLevel,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  OgeWordFormationTaskRow copyWithCompanion(
      OgeWordFormationTasksCompanion data) {
    return OgeWordFormationTaskRow(
      id: data.id.present ? data.id.value : this.id,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      sentenceBefore: data.sentenceBefore.present
          ? data.sentenceBefore.value
          : this.sentenceBefore,
      sentenceAfter: data.sentenceAfter.present
          ? data.sentenceAfter.value
          : this.sentenceAfter,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      acceptableAnswersJson: data.acceptableAnswersJson.present
          ? data.acceptableAnswersJson.value
          : this.acceptableAnswersJson,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      affix: data.affix.present ? data.affix.value : this.affix,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      cefrLevel: data.cefrLevel.present ? data.cefrLevel.value : this.cefrLevel,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OgeWordFormationTaskRow(')
          ..write('id: $id, ')
          ..write('baseWord: $baseWord, ')
          ..write('sentenceBefore: $sentenceBefore, ')
          ..write('sentenceAfter: $sentenceAfter, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('acceptableAnswersJson: $acceptableAnswersJson, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('affix: $affix, ')
          ..write('explanation: $explanation, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      baseWord,
      sentenceBefore,
      sentenceAfter,
      correctAnswer,
      acceptableAnswersJson,
      partOfSpeech,
      affix,
      explanation,
      cefrLevel,
      isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OgeWordFormationTaskRow &&
          other.id == this.id &&
          other.baseWord == this.baseWord &&
          other.sentenceBefore == this.sentenceBefore &&
          other.sentenceAfter == this.sentenceAfter &&
          other.correctAnswer == this.correctAnswer &&
          other.acceptableAnswersJson == this.acceptableAnswersJson &&
          other.partOfSpeech == this.partOfSpeech &&
          other.affix == this.affix &&
          other.explanation == this.explanation &&
          other.cefrLevel == this.cefrLevel &&
          other.isCompleted == this.isCompleted);
}

class OgeWordFormationTasksCompanion
    extends UpdateCompanion<OgeWordFormationTaskRow> {
  final Value<String> id;
  final Value<String> baseWord;
  final Value<String> sentenceBefore;
  final Value<String> sentenceAfter;
  final Value<String> correctAnswer;
  final Value<String> acceptableAnswersJson;
  final Value<String> partOfSpeech;
  final Value<String> affix;
  final Value<String> explanation;
  final Value<String> cefrLevel;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const OgeWordFormationTasksCompanion({
    this.id = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.sentenceBefore = const Value.absent(),
    this.sentenceAfter = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.acceptableAnswersJson = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.affix = const Value.absent(),
    this.explanation = const Value.absent(),
    this.cefrLevel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OgeWordFormationTasksCompanion.insert({
    required String id,
    required String baseWord,
    required String sentenceBefore,
    required String sentenceAfter,
    required String correctAnswer,
    required String acceptableAnswersJson,
    required String partOfSpeech,
    required String affix,
    required String explanation,
    this.cefrLevel = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        baseWord = Value(baseWord),
        sentenceBefore = Value(sentenceBefore),
        sentenceAfter = Value(sentenceAfter),
        correctAnswer = Value(correctAnswer),
        acceptableAnswersJson = Value(acceptableAnswersJson),
        partOfSpeech = Value(partOfSpeech),
        affix = Value(affix),
        explanation = Value(explanation);
  static Insertable<OgeWordFormationTaskRow> custom({
    Expression<String>? id,
    Expression<String>? baseWord,
    Expression<String>? sentenceBefore,
    Expression<String>? sentenceAfter,
    Expression<String>? correctAnswer,
    Expression<String>? acceptableAnswersJson,
    Expression<String>? partOfSpeech,
    Expression<String>? affix,
    Expression<String>? explanation,
    Expression<String>? cefrLevel,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseWord != null) 'base_word': baseWord,
      if (sentenceBefore != null) 'sentence_before': sentenceBefore,
      if (sentenceAfter != null) 'sentence_after': sentenceAfter,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (acceptableAnswersJson != null)
        'acceptable_answers_json': acceptableAnswersJson,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (affix != null) 'affix': affix,
      if (explanation != null) 'explanation': explanation,
      if (cefrLevel != null) 'cefr_level': cefrLevel,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OgeWordFormationTasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? baseWord,
      Value<String>? sentenceBefore,
      Value<String>? sentenceAfter,
      Value<String>? correctAnswer,
      Value<String>? acceptableAnswersJson,
      Value<String>? partOfSpeech,
      Value<String>? affix,
      Value<String>? explanation,
      Value<String>? cefrLevel,
      Value<bool>? isCompleted,
      Value<int>? rowid}) {
    return OgeWordFormationTasksCompanion(
      id: id ?? this.id,
      baseWord: baseWord ?? this.baseWord,
      sentenceBefore: sentenceBefore ?? this.sentenceBefore,
      sentenceAfter: sentenceAfter ?? this.sentenceAfter,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      acceptableAnswersJson:
          acceptableAnswersJson ?? this.acceptableAnswersJson,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      affix: affix ?? this.affix,
      explanation: explanation ?? this.explanation,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseWord.present) {
      map['base_word'] = Variable<String>(baseWord.value);
    }
    if (sentenceBefore.present) {
      map['sentence_before'] = Variable<String>(sentenceBefore.value);
    }
    if (sentenceAfter.present) {
      map['sentence_after'] = Variable<String>(sentenceAfter.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (acceptableAnswersJson.present) {
      map['acceptable_answers_json'] =
          Variable<String>(acceptableAnswersJson.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (affix.present) {
      map['affix'] = Variable<String>(affix.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (cefrLevel.present) {
      map['cefr_level'] = Variable<String>(cefrLevel.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OgeWordFormationTasksCompanion(')
          ..write('id: $id, ')
          ..write('baseWord: $baseWord, ')
          ..write('sentenceBefore: $sentenceBefore, ')
          ..write('sentenceAfter: $sentenceAfter, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('acceptableAnswersJson: $acceptableAnswersJson, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('affix: $affix, ')
          ..write('explanation: $explanation, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IbInquiryUnitsTable extends IbInquiryUnits
    with TableInfo<$IbInquiryUnitsTable, IbInquiryUnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IbInquiryUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
      'phase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _globalContextMeta =
      const VerificationMeta('globalContext');
  @override
  late final GeneratedColumn<String> globalContext = GeneratedColumn<String>(
      'global_context', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyConceptMeta =
      const VerificationMeta('keyConcept');
  @override
  late final GeneratedColumn<String> keyConcept = GeneratedColumn<String>(
      'key_concept', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relatedConceptsJsonMeta =
      const VerificationMeta('relatedConceptsJson');
  @override
  late final GeneratedColumn<String> relatedConceptsJson =
      GeneratedColumn<String>('related_concepts_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statementOfInquiryMeta =
      const VerificationMeta('statementOfInquiry');
  @override
  late final GeneratedColumn<String> statementOfInquiry =
      GeneratedColumn<String>('statement_of_inquiry', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inquiryQuestionsJsonMeta =
      const VerificationMeta('inquiryQuestionsJson');
  @override
  late final GeneratedColumn<String> inquiryQuestionsJson =
      GeneratedColumn<String>('inquiry_questions_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _criteriaTasksJsonMeta =
      const VerificationMeta('criteriaTasksJson');
  @override
  late final GeneratedColumn<String> criteriaTasksJson =
      GeneratedColumn<String>('criteria_tasks_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedTasksCountMeta =
      const VerificationMeta('completedTasksCount');
  @override
  late final GeneratedColumn<int> completedTasksCount = GeneratedColumn<int>(
      'completed_tasks_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        phase,
        globalContext,
        keyConcept,
        relatedConceptsJson,
        statementOfInquiry,
        inquiryQuestionsJson,
        criteriaTasksJson,
        completedTasksCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ib_inquiry_units';
  @override
  VerificationContext validateIntegrity(Insertable<IbInquiryUnitRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
          _phaseMeta, phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta));
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('global_context')) {
      context.handle(
          _globalContextMeta,
          globalContext.isAcceptableOrUnknown(
              data['global_context']!, _globalContextMeta));
    } else if (isInserting) {
      context.missing(_globalContextMeta);
    }
    if (data.containsKey('key_concept')) {
      context.handle(
          _keyConceptMeta,
          keyConcept.isAcceptableOrUnknown(
              data['key_concept']!, _keyConceptMeta));
    } else if (isInserting) {
      context.missing(_keyConceptMeta);
    }
    if (data.containsKey('related_concepts_json')) {
      context.handle(
          _relatedConceptsJsonMeta,
          relatedConceptsJson.isAcceptableOrUnknown(
              data['related_concepts_json']!, _relatedConceptsJsonMeta));
    } else if (isInserting) {
      context.missing(_relatedConceptsJsonMeta);
    }
    if (data.containsKey('statement_of_inquiry')) {
      context.handle(
          _statementOfInquiryMeta,
          statementOfInquiry.isAcceptableOrUnknown(
              data['statement_of_inquiry']!, _statementOfInquiryMeta));
    } else if (isInserting) {
      context.missing(_statementOfInquiryMeta);
    }
    if (data.containsKey('inquiry_questions_json')) {
      context.handle(
          _inquiryQuestionsJsonMeta,
          inquiryQuestionsJson.isAcceptableOrUnknown(
              data['inquiry_questions_json']!, _inquiryQuestionsJsonMeta));
    } else if (isInserting) {
      context.missing(_inquiryQuestionsJsonMeta);
    }
    if (data.containsKey('criteria_tasks_json')) {
      context.handle(
          _criteriaTasksJsonMeta,
          criteriaTasksJson.isAcceptableOrUnknown(
              data['criteria_tasks_json']!, _criteriaTasksJsonMeta));
    } else if (isInserting) {
      context.missing(_criteriaTasksJsonMeta);
    }
    if (data.containsKey('completed_tasks_count')) {
      context.handle(
          _completedTasksCountMeta,
          completedTasksCount.isAcceptableOrUnknown(
              data['completed_tasks_count']!, _completedTasksCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IbInquiryUnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IbInquiryUnitRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      phase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phase'])!,
      globalContext: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}global_context'])!,
      keyConcept: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_concept'])!,
      relatedConceptsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}related_concepts_json'])!,
      statementOfInquiry: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}statement_of_inquiry'])!,
      inquiryQuestionsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}inquiry_questions_json'])!,
      criteriaTasksJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}criteria_tasks_json'])!,
      completedTasksCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}completed_tasks_count'])!,
    );
  }

  @override
  $IbInquiryUnitsTable createAlias(String alias) {
    return $IbInquiryUnitsTable(attachedDatabase, alias);
  }
}

class IbInquiryUnitRow extends DataClass
    implements Insertable<IbInquiryUnitRow> {
  final String id;
  final String title;
  final String phase;
  final String globalContext;
  final String keyConcept;
  final String relatedConceptsJson;
  final String statementOfInquiry;
  final String inquiryQuestionsJson;
  final String criteriaTasksJson;
  final int completedTasksCount;
  const IbInquiryUnitRow(
      {required this.id,
      required this.title,
      required this.phase,
      required this.globalContext,
      required this.keyConcept,
      required this.relatedConceptsJson,
      required this.statementOfInquiry,
      required this.inquiryQuestionsJson,
      required this.criteriaTasksJson,
      required this.completedTasksCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['phase'] = Variable<String>(phase);
    map['global_context'] = Variable<String>(globalContext);
    map['key_concept'] = Variable<String>(keyConcept);
    map['related_concepts_json'] = Variable<String>(relatedConceptsJson);
    map['statement_of_inquiry'] = Variable<String>(statementOfInquiry);
    map['inquiry_questions_json'] = Variable<String>(inquiryQuestionsJson);
    map['criteria_tasks_json'] = Variable<String>(criteriaTasksJson);
    map['completed_tasks_count'] = Variable<int>(completedTasksCount);
    return map;
  }

  IbInquiryUnitsCompanion toCompanion(bool nullToAbsent) {
    return IbInquiryUnitsCompanion(
      id: Value(id),
      title: Value(title),
      phase: Value(phase),
      globalContext: Value(globalContext),
      keyConcept: Value(keyConcept),
      relatedConceptsJson: Value(relatedConceptsJson),
      statementOfInquiry: Value(statementOfInquiry),
      inquiryQuestionsJson: Value(inquiryQuestionsJson),
      criteriaTasksJson: Value(criteriaTasksJson),
      completedTasksCount: Value(completedTasksCount),
    );
  }

  factory IbInquiryUnitRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IbInquiryUnitRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      phase: serializer.fromJson<String>(json['phase']),
      globalContext: serializer.fromJson<String>(json['globalContext']),
      keyConcept: serializer.fromJson<String>(json['keyConcept']),
      relatedConceptsJson:
          serializer.fromJson<String>(json['relatedConceptsJson']),
      statementOfInquiry:
          serializer.fromJson<String>(json['statementOfInquiry']),
      inquiryQuestionsJson:
          serializer.fromJson<String>(json['inquiryQuestionsJson']),
      criteriaTasksJson: serializer.fromJson<String>(json['criteriaTasksJson']),
      completedTasksCount:
          serializer.fromJson<int>(json['completedTasksCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'phase': serializer.toJson<String>(phase),
      'globalContext': serializer.toJson<String>(globalContext),
      'keyConcept': serializer.toJson<String>(keyConcept),
      'relatedConceptsJson': serializer.toJson<String>(relatedConceptsJson),
      'statementOfInquiry': serializer.toJson<String>(statementOfInquiry),
      'inquiryQuestionsJson': serializer.toJson<String>(inquiryQuestionsJson),
      'criteriaTasksJson': serializer.toJson<String>(criteriaTasksJson),
      'completedTasksCount': serializer.toJson<int>(completedTasksCount),
    };
  }

  IbInquiryUnitRow copyWith(
          {String? id,
          String? title,
          String? phase,
          String? globalContext,
          String? keyConcept,
          String? relatedConceptsJson,
          String? statementOfInquiry,
          String? inquiryQuestionsJson,
          String? criteriaTasksJson,
          int? completedTasksCount}) =>
      IbInquiryUnitRow(
        id: id ?? this.id,
        title: title ?? this.title,
        phase: phase ?? this.phase,
        globalContext: globalContext ?? this.globalContext,
        keyConcept: keyConcept ?? this.keyConcept,
        relatedConceptsJson: relatedConceptsJson ?? this.relatedConceptsJson,
        statementOfInquiry: statementOfInquiry ?? this.statementOfInquiry,
        inquiryQuestionsJson: inquiryQuestionsJson ?? this.inquiryQuestionsJson,
        criteriaTasksJson: criteriaTasksJson ?? this.criteriaTasksJson,
        completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      );
  IbInquiryUnitRow copyWithCompanion(IbInquiryUnitsCompanion data) {
    return IbInquiryUnitRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      phase: data.phase.present ? data.phase.value : this.phase,
      globalContext: data.globalContext.present
          ? data.globalContext.value
          : this.globalContext,
      keyConcept:
          data.keyConcept.present ? data.keyConcept.value : this.keyConcept,
      relatedConceptsJson: data.relatedConceptsJson.present
          ? data.relatedConceptsJson.value
          : this.relatedConceptsJson,
      statementOfInquiry: data.statementOfInquiry.present
          ? data.statementOfInquiry.value
          : this.statementOfInquiry,
      inquiryQuestionsJson: data.inquiryQuestionsJson.present
          ? data.inquiryQuestionsJson.value
          : this.inquiryQuestionsJson,
      criteriaTasksJson: data.criteriaTasksJson.present
          ? data.criteriaTasksJson.value
          : this.criteriaTasksJson,
      completedTasksCount: data.completedTasksCount.present
          ? data.completedTasksCount.value
          : this.completedTasksCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IbInquiryUnitRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('phase: $phase, ')
          ..write('globalContext: $globalContext, ')
          ..write('keyConcept: $keyConcept, ')
          ..write('relatedConceptsJson: $relatedConceptsJson, ')
          ..write('statementOfInquiry: $statementOfInquiry, ')
          ..write('inquiryQuestionsJson: $inquiryQuestionsJson, ')
          ..write('criteriaTasksJson: $criteriaTasksJson, ')
          ..write('completedTasksCount: $completedTasksCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      phase,
      globalContext,
      keyConcept,
      relatedConceptsJson,
      statementOfInquiry,
      inquiryQuestionsJson,
      criteriaTasksJson,
      completedTasksCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IbInquiryUnitRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.phase == this.phase &&
          other.globalContext == this.globalContext &&
          other.keyConcept == this.keyConcept &&
          other.relatedConceptsJson == this.relatedConceptsJson &&
          other.statementOfInquiry == this.statementOfInquiry &&
          other.inquiryQuestionsJson == this.inquiryQuestionsJson &&
          other.criteriaTasksJson == this.criteriaTasksJson &&
          other.completedTasksCount == this.completedTasksCount);
}

class IbInquiryUnitsCompanion extends UpdateCompanion<IbInquiryUnitRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> phase;
  final Value<String> globalContext;
  final Value<String> keyConcept;
  final Value<String> relatedConceptsJson;
  final Value<String> statementOfInquiry;
  final Value<String> inquiryQuestionsJson;
  final Value<String> criteriaTasksJson;
  final Value<int> completedTasksCount;
  final Value<int> rowid;
  const IbInquiryUnitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.phase = const Value.absent(),
    this.globalContext = const Value.absent(),
    this.keyConcept = const Value.absent(),
    this.relatedConceptsJson = const Value.absent(),
    this.statementOfInquiry = const Value.absent(),
    this.inquiryQuestionsJson = const Value.absent(),
    this.criteriaTasksJson = const Value.absent(),
    this.completedTasksCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IbInquiryUnitsCompanion.insert({
    required String id,
    required String title,
    required String phase,
    required String globalContext,
    required String keyConcept,
    required String relatedConceptsJson,
    required String statementOfInquiry,
    required String inquiryQuestionsJson,
    required String criteriaTasksJson,
    this.completedTasksCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        phase = Value(phase),
        globalContext = Value(globalContext),
        keyConcept = Value(keyConcept),
        relatedConceptsJson = Value(relatedConceptsJson),
        statementOfInquiry = Value(statementOfInquiry),
        inquiryQuestionsJson = Value(inquiryQuestionsJson),
        criteriaTasksJson = Value(criteriaTasksJson);
  static Insertable<IbInquiryUnitRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? phase,
    Expression<String>? globalContext,
    Expression<String>? keyConcept,
    Expression<String>? relatedConceptsJson,
    Expression<String>? statementOfInquiry,
    Expression<String>? inquiryQuestionsJson,
    Expression<String>? criteriaTasksJson,
    Expression<int>? completedTasksCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (phase != null) 'phase': phase,
      if (globalContext != null) 'global_context': globalContext,
      if (keyConcept != null) 'key_concept': keyConcept,
      if (relatedConceptsJson != null)
        'related_concepts_json': relatedConceptsJson,
      if (statementOfInquiry != null)
        'statement_of_inquiry': statementOfInquiry,
      if (inquiryQuestionsJson != null)
        'inquiry_questions_json': inquiryQuestionsJson,
      if (criteriaTasksJson != null) 'criteria_tasks_json': criteriaTasksJson,
      if (completedTasksCount != null)
        'completed_tasks_count': completedTasksCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IbInquiryUnitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? phase,
      Value<String>? globalContext,
      Value<String>? keyConcept,
      Value<String>? relatedConceptsJson,
      Value<String>? statementOfInquiry,
      Value<String>? inquiryQuestionsJson,
      Value<String>? criteriaTasksJson,
      Value<int>? completedTasksCount,
      Value<int>? rowid}) {
    return IbInquiryUnitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      phase: phase ?? this.phase,
      globalContext: globalContext ?? this.globalContext,
      keyConcept: keyConcept ?? this.keyConcept,
      relatedConceptsJson: relatedConceptsJson ?? this.relatedConceptsJson,
      statementOfInquiry: statementOfInquiry ?? this.statementOfInquiry,
      inquiryQuestionsJson: inquiryQuestionsJson ?? this.inquiryQuestionsJson,
      criteriaTasksJson: criteriaTasksJson ?? this.criteriaTasksJson,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (globalContext.present) {
      map['global_context'] = Variable<String>(globalContext.value);
    }
    if (keyConcept.present) {
      map['key_concept'] = Variable<String>(keyConcept.value);
    }
    if (relatedConceptsJson.present) {
      map['related_concepts_json'] =
          Variable<String>(relatedConceptsJson.value);
    }
    if (statementOfInquiry.present) {
      map['statement_of_inquiry'] = Variable<String>(statementOfInquiry.value);
    }
    if (inquiryQuestionsJson.present) {
      map['inquiry_questions_json'] =
          Variable<String>(inquiryQuestionsJson.value);
    }
    if (criteriaTasksJson.present) {
      map['criteria_tasks_json'] = Variable<String>(criteriaTasksJson.value);
    }
    if (completedTasksCount.present) {
      map['completed_tasks_count'] = Variable<int>(completedTasksCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IbInquiryUnitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('phase: $phase, ')
          ..write('globalContext: $globalContext, ')
          ..write('keyConcept: $keyConcept, ')
          ..write('relatedConceptsJson: $relatedConceptsJson, ')
          ..write('statementOfInquiry: $statementOfInquiry, ')
          ..write('inquiryQuestionsJson: $inquiryQuestionsJson, ')
          ..write('criteriaTasksJson: $criteriaTasksJson, ')
          ..write('completedTasksCount: $completedTasksCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrsCardsTable extends SrsCards
    with TableInfo<$SrsCardsTable, SrsCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frontEnglishMeta =
      const VerificationMeta('frontEnglish');
  @override
  late final GeneratedColumn<String> frontEnglish = GeneratedColumn<String>(
      'front_english', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backRussianMeta =
      const VerificationMeta('backRussian');
  @override
  late final GeneratedColumn<String> backRussian = GeneratedColumn<String>(
      'back_russian', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptionIpaMeta =
      const VerificationMeta('transcriptionIpa');
  @override
  late final GeneratedColumn<String> transcriptionIpa = GeneratedColumn<String>(
      'transcription_ipa', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('B1'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('OGE_Topic'));
  static const VerificationMeta _exampleSentenceMeta =
      const VerificationMeta('exampleSentence');
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
      'example_sentence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleTranslationMeta =
      const VerificationMeta('exampleTranslation');
  @override
  late final GeneratedColumn<String> exampleTranslation =
      GeneratedColumn<String>('example_translation', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fsrsStateMeta =
      const VerificationMeta('fsrsState');
  @override
  late final GeneratedColumn<String> fsrsState = GeneratedColumn<String>(
      'fsrs_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('newCard'));
  static const VerificationMeta _stabilityMeta =
      const VerificationMeta('stability');
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
      'stability', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        frontEnglish,
        backRussian,
        transcriptionIpa,
        level,
        category,
        exampleSentence,
        exampleTranslation,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(Insertable<SrsCardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('front_english')) {
      context.handle(
          _frontEnglishMeta,
          frontEnglish.isAcceptableOrUnknown(
              data['front_english']!, _frontEnglishMeta));
    } else if (isInserting) {
      context.missing(_frontEnglishMeta);
    }
    if (data.containsKey('back_russian')) {
      context.handle(
          _backRussianMeta,
          backRussian.isAcceptableOrUnknown(
              data['back_russian']!, _backRussianMeta));
    } else if (isInserting) {
      context.missing(_backRussianMeta);
    }
    if (data.containsKey('transcription_ipa')) {
      context.handle(
          _transcriptionIpaMeta,
          transcriptionIpa.isAcceptableOrUnknown(
              data['transcription_ipa']!, _transcriptionIpaMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
          _exampleSentenceMeta,
          exampleSentence.isAcceptableOrUnknown(
              data['example_sentence']!, _exampleSentenceMeta));
    }
    if (data.containsKey('example_translation')) {
      context.handle(
          _exampleTranslationMeta,
          exampleTranslation.isAcceptableOrUnknown(
              data['example_translation']!, _exampleTranslationMeta));
    }
    if (data.containsKey('fsrs_state')) {
      context.handle(_fsrsStateMeta,
          fsrsState.isAcceptableOrUnknown(data['fsrs_state']!, _fsrsStateMeta));
    }
    if (data.containsKey('stability')) {
      context.handle(_stabilityMeta,
          stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      frontEnglish: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}front_english'])!,
      backRussian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}back_russian'])!,
      transcriptionIpa: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_ipa']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      exampleSentence: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_sentence']),
      exampleTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_translation']),
      fsrsState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fsrs_state'])!,
      stability: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stability'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      lapses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $SrsCardsTable createAlias(String alias) {
    return $SrsCardsTable(attachedDatabase, alias);
  }
}

class SrsCardRow extends DataClass implements Insertable<SrsCardRow> {
  final String id;
  final String frontEnglish;
  final String backRussian;
  final String? transcriptionIpa;
  final String level;
  final String category;
  final String? exampleSentence;
  final String? exampleTranslation;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;
  const SrsCardRow(
      {required this.id,
      required this.frontEnglish,
      required this.backRussian,
      this.transcriptionIpa,
      required this.level,
      required this.category,
      this.exampleSentence,
      this.exampleTranslation,
      required this.fsrsState,
      required this.stability,
      required this.difficulty,
      required this.reps,
      required this.lapses,
      required this.dueAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['front_english'] = Variable<String>(frontEnglish);
    map['back_russian'] = Variable<String>(backRussian);
    if (!nullToAbsent || transcriptionIpa != null) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa);
    }
    map['level'] = Variable<String>(level);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || exampleSentence != null) {
      map['example_sentence'] = Variable<String>(exampleSentence);
    }
    if (!nullToAbsent || exampleTranslation != null) {
      map['example_translation'] = Variable<String>(exampleTranslation);
    }
    map['fsrs_state'] = Variable<String>(fsrsState);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    map['due_at'] = Variable<DateTime>(dueAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      id: Value(id),
      frontEnglish: Value(frontEnglish),
      backRussian: Value(backRussian),
      transcriptionIpa: transcriptionIpa == null && nullToAbsent
          ? const Value.absent()
          : Value(transcriptionIpa),
      level: Value(level),
      category: Value(category),
      exampleSentence: exampleSentence == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentence),
      exampleTranslation: exampleTranslation == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleTranslation),
      fsrsState: Value(fsrsState),
      stability: Value(stability),
      difficulty: Value(difficulty),
      reps: Value(reps),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory SrsCardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCardRow(
      id: serializer.fromJson<String>(json['id']),
      frontEnglish: serializer.fromJson<String>(json['frontEnglish']),
      backRussian: serializer.fromJson<String>(json['backRussian']),
      transcriptionIpa: serializer.fromJson<String?>(json['transcriptionIpa']),
      level: serializer.fromJson<String>(json['level']),
      category: serializer.fromJson<String>(json['category']),
      exampleSentence: serializer.fromJson<String?>(json['exampleSentence']),
      exampleTranslation:
          serializer.fromJson<String?>(json['exampleTranslation']),
      fsrsState: serializer.fromJson<String>(json['fsrsState']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'frontEnglish': serializer.toJson<String>(frontEnglish),
      'backRussian': serializer.toJson<String>(backRussian),
      'transcriptionIpa': serializer.toJson<String?>(transcriptionIpa),
      'level': serializer.toJson<String>(level),
      'category': serializer.toJson<String>(category),
      'exampleSentence': serializer.toJson<String?>(exampleSentence),
      'exampleTranslation': serializer.toJson<String?>(exampleTranslation),
      'fsrsState': serializer.toJson<String>(fsrsState),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  SrsCardRow copyWith(
          {String? id,
          String? frontEnglish,
          String? backRussian,
          Value<String?> transcriptionIpa = const Value.absent(),
          String? level,
          String? category,
          Value<String?> exampleSentence = const Value.absent(),
          Value<String?> exampleTranslation = const Value.absent(),
          String? fsrsState,
          double? stability,
          double? difficulty,
          int? reps,
          int? lapses,
          DateTime? dueAt,
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      SrsCardRow(
        id: id ?? this.id,
        frontEnglish: frontEnglish ?? this.frontEnglish,
        backRussian: backRussian ?? this.backRussian,
        transcriptionIpa: transcriptionIpa.present
            ? transcriptionIpa.value
            : this.transcriptionIpa,
        level: level ?? this.level,
        category: category ?? this.category,
        exampleSentence: exampleSentence.present
            ? exampleSentence.value
            : this.exampleSentence,
        exampleTranslation: exampleTranslation.present
            ? exampleTranslation.value
            : this.exampleTranslation,
        fsrsState: fsrsState ?? this.fsrsState,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        dueAt: dueAt ?? this.dueAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  SrsCardRow copyWithCompanion(SrsCardsCompanion data) {
    return SrsCardRow(
      id: data.id.present ? data.id.value : this.id,
      frontEnglish: data.frontEnglish.present
          ? data.frontEnglish.value
          : this.frontEnglish,
      backRussian:
          data.backRussian.present ? data.backRussian.value : this.backRussian,
      transcriptionIpa: data.transcriptionIpa.present
          ? data.transcriptionIpa.value
          : this.transcriptionIpa,
      level: data.level.present ? data.level.value : this.level,
      category: data.category.present ? data.category.value : this.category,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      exampleTranslation: data.exampleTranslation.present
          ? data.exampleTranslation.value
          : this.exampleTranslation,
      fsrsState: data.fsrsState.present ? data.fsrsState.value : this.fsrsState,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardRow(')
          ..write('id: $id, ')
          ..write('frontEnglish: $frontEnglish, ')
          ..write('backRussian: $backRussian, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      frontEnglish,
      backRussian,
      transcriptionIpa,
      level,
      category,
      exampleSentence,
      exampleTranslation,
      fsrsState,
      stability,
      difficulty,
      reps,
      lapses,
      dueAt,
      lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCardRow &&
          other.id == this.id &&
          other.frontEnglish == this.frontEnglish &&
          other.backRussian == this.backRussian &&
          other.transcriptionIpa == this.transcriptionIpa &&
          other.level == this.level &&
          other.category == this.category &&
          other.exampleSentence == this.exampleSentence &&
          other.exampleTranslation == this.exampleTranslation &&
          other.fsrsState == this.fsrsState &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.dueAt == this.dueAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCardRow> {
  final Value<String> id;
  final Value<String> frontEnglish;
  final Value<String> backRussian;
  final Value<String?> transcriptionIpa;
  final Value<String> level;
  final Value<String> category;
  final Value<String?> exampleSentence;
  final Value<String?> exampleTranslation;
  final Value<String> fsrsState;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<DateTime> dueAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.id = const Value.absent(),
    this.frontEnglish = const Value.absent(),
    this.backRussian = const Value.absent(),
    this.transcriptionIpa = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String id,
    required String frontEnglish,
    required String backRussian,
    this.transcriptionIpa = const Value.absent(),
    this.level = const Value.absent(),
    this.category = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.fsrsState = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    required DateTime dueAt,
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        frontEnglish = Value(frontEnglish),
        backRussian = Value(backRussian),
        dueAt = Value(dueAt);
  static Insertable<SrsCardRow> custom({
    Expression<String>? id,
    Expression<String>? frontEnglish,
    Expression<String>? backRussian,
    Expression<String>? transcriptionIpa,
    Expression<String>? level,
    Expression<String>? category,
    Expression<String>? exampleSentence,
    Expression<String>? exampleTranslation,
    Expression<String>? fsrsState,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frontEnglish != null) 'front_english': frontEnglish,
      if (backRussian != null) 'back_russian': backRussian,
      if (transcriptionIpa != null) 'transcription_ipa': transcriptionIpa,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleTranslation != null) 'example_translation': exampleTranslation,
      if (fsrsState != null) 'fsrs_state': fsrsState,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (dueAt != null) 'due_at': dueAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? frontEnglish,
      Value<String>? backRussian,
      Value<String?>? transcriptionIpa,
      Value<String>? level,
      Value<String>? category,
      Value<String?>? exampleSentence,
      Value<String?>? exampleTranslation,
      Value<String>? fsrsState,
      Value<double>? stability,
      Value<double>? difficulty,
      Value<int>? reps,
      Value<int>? lapses,
      Value<DateTime>? dueAt,
      Value<DateTime?>? lastReviewedAt,
      Value<int>? rowid}) {
    return SrsCardsCompanion(
      id: id ?? this.id,
      frontEnglish: frontEnglish ?? this.frontEnglish,
      backRussian: backRussian ?? this.backRussian,
      transcriptionIpa: transcriptionIpa ?? this.transcriptionIpa,
      level: level ?? this.level,
      category: category ?? this.category,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      fsrsState: fsrsState ?? this.fsrsState,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (frontEnglish.present) {
      map['front_english'] = Variable<String>(frontEnglish.value);
    }
    if (backRussian.present) {
      map['back_russian'] = Variable<String>(backRussian.value);
    }
    if (transcriptionIpa.present) {
      map['transcription_ipa'] = Variable<String>(transcriptionIpa.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (exampleTranslation.present) {
      map['example_translation'] = Variable<String>(exampleTranslation.value);
    }
    if (fsrsState.present) {
      map['fsrs_state'] = Variable<String>(fsrsState.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('id: $id, ')
          ..write('frontEnglish: $frontEnglish, ')
          ..write('backRussian: $backRussian, ')
          ..write('transcriptionIpa: $transcriptionIpa, ')
          ..write('level: $level, ')
          ..write('category: $category, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('fsrsState: $fsrsState, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyGoalsTable extends StudyGoals
    with TableInfo<$StudyGoalsTable, StudyGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
      'target_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentValueMeta =
      const VerificationMeta('currentValue');
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
      'current_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deadlineDaysMeta =
      const VerificationMeta('deadlineDays');
  @override
  late final GeneratedColumn<int> deadlineDays = GeneratedColumn<int>(
      'deadline_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isPrimaryMeta =
      const VerificationMeta('isPrimary');
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
      'is_primary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_primary" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        category,
        targetValue,
        currentValue,
        unit,
        deadlineDays,
        isPrimary
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_goals';
  @override
  VerificationContext validateIntegrity(Insertable<StudyGoalRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
          _currentValueMeta,
          currentValue.isAcceptableOrUnknown(
              data['current_value']!, _currentValueMeta));
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('deadline_days')) {
      context.handle(
          _deadlineDaysMeta,
          deadlineDays.isAcceptableOrUnknown(
              data['deadline_days']!, _deadlineDaysMeta));
    } else if (isInserting) {
      context.missing(_deadlineDaysMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(_isPrimaryMeta,
          isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyGoalRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_value'])!,
      currentValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_value'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      deadlineDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deadline_days'])!,
      isPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_primary'])!,
    );
  }

  @override
  $StudyGoalsTable createAlias(String alias) {
    return $StudyGoalsTable(attachedDatabase, alias);
  }
}

class StudyGoalRow extends DataClass implements Insertable<StudyGoalRow> {
  final String id;
  final String title;
  final String description;
  final String category;
  final int targetValue;
  final int currentValue;
  final String unit;
  final int deadlineDays;
  final bool isPrimary;
  const StudyGoalRow(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.targetValue,
      required this.currentValue,
      required this.unit,
      required this.deadlineDays,
      required this.isPrimary});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['target_value'] = Variable<int>(targetValue);
    map['current_value'] = Variable<int>(currentValue);
    map['unit'] = Variable<String>(unit);
    map['deadline_days'] = Variable<int>(deadlineDays);
    map['is_primary'] = Variable<bool>(isPrimary);
    return map;
  }

  StudyGoalsCompanion toCompanion(bool nullToAbsent) {
    return StudyGoalsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      unit: Value(unit),
      deadlineDays: Value(deadlineDays),
      isPrimary: Value(isPrimary),
    );
  }

  factory StudyGoalRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyGoalRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      unit: serializer.fromJson<String>(json['unit']),
      deadlineDays: serializer.fromJson<int>(json['deadlineDays']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'targetValue': serializer.toJson<int>(targetValue),
      'currentValue': serializer.toJson<int>(currentValue),
      'unit': serializer.toJson<String>(unit),
      'deadlineDays': serializer.toJson<int>(deadlineDays),
      'isPrimary': serializer.toJson<bool>(isPrimary),
    };
  }

  StudyGoalRow copyWith(
          {String? id,
          String? title,
          String? description,
          String? category,
          int? targetValue,
          int? currentValue,
          String? unit,
          int? deadlineDays,
          bool? isPrimary}) =>
      StudyGoalRow(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        targetValue: targetValue ?? this.targetValue,
        currentValue: currentValue ?? this.currentValue,
        unit: unit ?? this.unit,
        deadlineDays: deadlineDays ?? this.deadlineDays,
        isPrimary: isPrimary ?? this.isPrimary,
      );
  StudyGoalRow copyWithCompanion(StudyGoalsCompanion data) {
    return StudyGoalRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      deadlineDays: data.deadlineDays.present
          ? data.deadlineDays.value
          : this.deadlineDays,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyGoalRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('deadlineDays: $deadlineDays, ')
          ..write('isPrimary: $isPrimary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, category, targetValue,
      currentValue, unit, deadlineDays, isPrimary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyGoalRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.unit == this.unit &&
          other.deadlineDays == this.deadlineDays &&
          other.isPrimary == this.isPrimary);
}

class StudyGoalsCompanion extends UpdateCompanion<StudyGoalRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<int> targetValue;
  final Value<int> currentValue;
  final Value<String> unit;
  final Value<int> deadlineDays;
  final Value<bool> isPrimary;
  final Value<int> rowid;
  const StudyGoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.deadlineDays = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyGoalsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String category,
    required int targetValue,
    required int currentValue,
    required String unit,
    required int deadlineDays,
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        category = Value(category),
        targetValue = Value(targetValue),
        currentValue = Value(currentValue),
        unit = Value(unit),
        deadlineDays = Value(deadlineDays);
  static Insertable<StudyGoalRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? targetValue,
    Expression<int>? currentValue,
    Expression<String>? unit,
    Expression<int>? deadlineDays,
    Expression<bool>? isPrimary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (unit != null) 'unit': unit,
      if (deadlineDays != null) 'deadline_days': deadlineDays,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? category,
      Value<int>? targetValue,
      Value<int>? currentValue,
      Value<String>? unit,
      Value<int>? deadlineDays,
      Value<bool>? isPrimary,
      Value<int>? rowid}) {
    return StudyGoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      deadlineDays: deadlineDays ?? this.deadlineDays,
      isPrimary: isPrimary ?? this.isPrimary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (deadlineDays.present) {
      map['deadline_days'] = Variable<int>(deadlineDays.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('deadlineDays: $deadlineDays, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTableTable extends UserProgressTable
    with TableInfo<$UserProgressTableTable, UserProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ogeScoreMeta =
      const VerificationMeta('ogeScore');
  @override
  late final GeneratedColumn<int> ogeScore = GeneratedColumn<int>(
      'oge_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _grammarCompletedCountMeta =
      const VerificationMeta('grammarCompletedCount');
  @override
  late final GeneratedColumn<int> grammarCompletedCount = GeneratedColumn<int>(
      'grammar_completed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wordFormationCompletedCountMeta =
      const VerificationMeta('wordFormationCompletedCount');
  @override
  late final GeneratedColumn<int> wordFormationCompletedCount =
      GeneratedColumn<int>('word_formation_completed_count', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _ibCompletedTasksCountMeta =
      const VerificationMeta('ibCompletedTasksCount');
  @override
  late final GeneratedColumn<int> ibCompletedTasksCount = GeneratedColumn<int>(
      'ib_completed_tasks_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _srsMasteredCountMeta =
      const VerificationMeta('srsMasteredCount');
  @override
  late final GeneratedColumn<int> srsMasteredCount = GeneratedColumn<int>(
      'srs_mastered_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakDaysMeta =
      const VerificationMeta('streakDays');
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
      'streak_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _lastPracticeAtMeta =
      const VerificationMeta('lastPracticeAt');
  @override
  late final GeneratedColumn<DateTime> lastPracticeAt =
      GeneratedColumn<DateTime>('last_practice_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ogeScore,
        grammarCompletedCount,
        wordFormationCompletedCount,
        ibCompletedTasksCount,
        srsMasteredCount,
        streakDays,
        lastPracticeAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('oge_score')) {
      context.handle(_ogeScoreMeta,
          ogeScore.isAcceptableOrUnknown(data['oge_score']!, _ogeScoreMeta));
    }
    if (data.containsKey('grammar_completed_count')) {
      context.handle(
          _grammarCompletedCountMeta,
          grammarCompletedCount.isAcceptableOrUnknown(
              data['grammar_completed_count']!, _grammarCompletedCountMeta));
    }
    if (data.containsKey('word_formation_completed_count')) {
      context.handle(
          _wordFormationCompletedCountMeta,
          wordFormationCompletedCount.isAcceptableOrUnknown(
              data['word_formation_completed_count']!,
              _wordFormationCompletedCountMeta));
    }
    if (data.containsKey('ib_completed_tasks_count')) {
      context.handle(
          _ibCompletedTasksCountMeta,
          ibCompletedTasksCount.isAcceptableOrUnknown(
              data['ib_completed_tasks_count']!, _ibCompletedTasksCountMeta));
    }
    if (data.containsKey('srs_mastered_count')) {
      context.handle(
          _srsMasteredCountMeta,
          srsMasteredCount.isAcceptableOrUnknown(
              data['srs_mastered_count']!, _srsMasteredCountMeta));
    }
    if (data.containsKey('streak_days')) {
      context.handle(
          _streakDaysMeta,
          streakDays.isAcceptableOrUnknown(
              data['streak_days']!, _streakDaysMeta));
    }
    if (data.containsKey('last_practice_at')) {
      context.handle(
          _lastPracticeAtMeta,
          lastPracticeAt.isAcceptableOrUnknown(
              data['last_practice_at']!, _lastPracticeAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ogeScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}oge_score'])!,
      grammarCompletedCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}grammar_completed_count'])!,
      wordFormationCompletedCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}word_formation_completed_count'])!,
      ibCompletedTasksCount: attachedDatabase.typeMapping.read(DriftSqlType.int,
          data['${effectivePrefix}ib_completed_tasks_count'])!,
      srsMasteredCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}srs_mastered_count'])!,
      streakDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_days'])!,
      lastPracticeAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_practice_at']),
    );
  }

  @override
  $UserProgressTableTable createAlias(String alias) {
    return $UserProgressTableTable(attachedDatabase, alias);
  }
}

class UserProgressRow extends DataClass implements Insertable<UserProgressRow> {
  final String id;
  final int ogeScore;
  final int grammarCompletedCount;
  final int wordFormationCompletedCount;
  final int ibCompletedTasksCount;
  final int srsMasteredCount;
  final int streakDays;
  final DateTime? lastPracticeAt;
  const UserProgressRow(
      {required this.id,
      required this.ogeScore,
      required this.grammarCompletedCount,
      required this.wordFormationCompletedCount,
      required this.ibCompletedTasksCount,
      required this.srsMasteredCount,
      required this.streakDays,
      this.lastPracticeAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['oge_score'] = Variable<int>(ogeScore);
    map['grammar_completed_count'] = Variable<int>(grammarCompletedCount);
    map['word_formation_completed_count'] =
        Variable<int>(wordFormationCompletedCount);
    map['ib_completed_tasks_count'] = Variable<int>(ibCompletedTasksCount);
    map['srs_mastered_count'] = Variable<int>(srsMasteredCount);
    map['streak_days'] = Variable<int>(streakDays);
    if (!nullToAbsent || lastPracticeAt != null) {
      map['last_practice_at'] = Variable<DateTime>(lastPracticeAt);
    }
    return map;
  }

  UserProgressTableCompanion toCompanion(bool nullToAbsent) {
    return UserProgressTableCompanion(
      id: Value(id),
      ogeScore: Value(ogeScore),
      grammarCompletedCount: Value(grammarCompletedCount),
      wordFormationCompletedCount: Value(wordFormationCompletedCount),
      ibCompletedTasksCount: Value(ibCompletedTasksCount),
      srsMasteredCount: Value(srsMasteredCount),
      streakDays: Value(streakDays),
      lastPracticeAt: lastPracticeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPracticeAt),
    );
  }

  factory UserProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressRow(
      id: serializer.fromJson<String>(json['id']),
      ogeScore: serializer.fromJson<int>(json['ogeScore']),
      grammarCompletedCount:
          serializer.fromJson<int>(json['grammarCompletedCount']),
      wordFormationCompletedCount:
          serializer.fromJson<int>(json['wordFormationCompletedCount']),
      ibCompletedTasksCount:
          serializer.fromJson<int>(json['ibCompletedTasksCount']),
      srsMasteredCount: serializer.fromJson<int>(json['srsMasteredCount']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
      lastPracticeAt: serializer.fromJson<DateTime?>(json['lastPracticeAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ogeScore': serializer.toJson<int>(ogeScore),
      'grammarCompletedCount': serializer.toJson<int>(grammarCompletedCount),
      'wordFormationCompletedCount':
          serializer.toJson<int>(wordFormationCompletedCount),
      'ibCompletedTasksCount': serializer.toJson<int>(ibCompletedTasksCount),
      'srsMasteredCount': serializer.toJson<int>(srsMasteredCount),
      'streakDays': serializer.toJson<int>(streakDays),
      'lastPracticeAt': serializer.toJson<DateTime?>(lastPracticeAt),
    };
  }

  UserProgressRow copyWith(
          {String? id,
          int? ogeScore,
          int? grammarCompletedCount,
          int? wordFormationCompletedCount,
          int? ibCompletedTasksCount,
          int? srsMasteredCount,
          int? streakDays,
          Value<DateTime?> lastPracticeAt = const Value.absent()}) =>
      UserProgressRow(
        id: id ?? this.id,
        ogeScore: ogeScore ?? this.ogeScore,
        grammarCompletedCount:
            grammarCompletedCount ?? this.grammarCompletedCount,
        wordFormationCompletedCount:
            wordFormationCompletedCount ?? this.wordFormationCompletedCount,
        ibCompletedTasksCount:
            ibCompletedTasksCount ?? this.ibCompletedTasksCount,
        srsMasteredCount: srsMasteredCount ?? this.srsMasteredCount,
        streakDays: streakDays ?? this.streakDays,
        lastPracticeAt:
            lastPracticeAt.present ? lastPracticeAt.value : this.lastPracticeAt,
      );
  UserProgressRow copyWithCompanion(UserProgressTableCompanion data) {
    return UserProgressRow(
      id: data.id.present ? data.id.value : this.id,
      ogeScore: data.ogeScore.present ? data.ogeScore.value : this.ogeScore,
      grammarCompletedCount: data.grammarCompletedCount.present
          ? data.grammarCompletedCount.value
          : this.grammarCompletedCount,
      wordFormationCompletedCount: data.wordFormationCompletedCount.present
          ? data.wordFormationCompletedCount.value
          : this.wordFormationCompletedCount,
      ibCompletedTasksCount: data.ibCompletedTasksCount.present
          ? data.ibCompletedTasksCount.value
          : this.ibCompletedTasksCount,
      srsMasteredCount: data.srsMasteredCount.present
          ? data.srsMasteredCount.value
          : this.srsMasteredCount,
      streakDays:
          data.streakDays.present ? data.streakDays.value : this.streakDays,
      lastPracticeAt: data.lastPracticeAt.present
          ? data.lastPracticeAt.value
          : this.lastPracticeAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressRow(')
          ..write('id: $id, ')
          ..write('ogeScore: $ogeScore, ')
          ..write('grammarCompletedCount: $grammarCompletedCount, ')
          ..write('wordFormationCompletedCount: $wordFormationCompletedCount, ')
          ..write('ibCompletedTasksCount: $ibCompletedTasksCount, ')
          ..write('srsMasteredCount: $srsMasteredCount, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastPracticeAt: $lastPracticeAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ogeScore,
      grammarCompletedCount,
      wordFormationCompletedCount,
      ibCompletedTasksCount,
      srsMasteredCount,
      streakDays,
      lastPracticeAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressRow &&
          other.id == this.id &&
          other.ogeScore == this.ogeScore &&
          other.grammarCompletedCount == this.grammarCompletedCount &&
          other.wordFormationCompletedCount ==
              this.wordFormationCompletedCount &&
          other.ibCompletedTasksCount == this.ibCompletedTasksCount &&
          other.srsMasteredCount == this.srsMasteredCount &&
          other.streakDays == this.streakDays &&
          other.lastPracticeAt == this.lastPracticeAt);
}

class UserProgressTableCompanion extends UpdateCompanion<UserProgressRow> {
  final Value<String> id;
  final Value<int> ogeScore;
  final Value<int> grammarCompletedCount;
  final Value<int> wordFormationCompletedCount;
  final Value<int> ibCompletedTasksCount;
  final Value<int> srsMasteredCount;
  final Value<int> streakDays;
  final Value<DateTime?> lastPracticeAt;
  final Value<int> rowid;
  const UserProgressTableCompanion({
    this.id = const Value.absent(),
    this.ogeScore = const Value.absent(),
    this.grammarCompletedCount = const Value.absent(),
    this.wordFormationCompletedCount = const Value.absent(),
    this.ibCompletedTasksCount = const Value.absent(),
    this.srsMasteredCount = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastPracticeAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProgressTableCompanion.insert({
    required String id,
    this.ogeScore = const Value.absent(),
    this.grammarCompletedCount = const Value.absent(),
    this.wordFormationCompletedCount = const Value.absent(),
    this.ibCompletedTasksCount = const Value.absent(),
    this.srsMasteredCount = const Value.absent(),
    this.streakDays = const Value.absent(),
    this.lastPracticeAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserProgressRow> custom({
    Expression<String>? id,
    Expression<int>? ogeScore,
    Expression<int>? grammarCompletedCount,
    Expression<int>? wordFormationCompletedCount,
    Expression<int>? ibCompletedTasksCount,
    Expression<int>? srsMasteredCount,
    Expression<int>? streakDays,
    Expression<DateTime>? lastPracticeAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ogeScore != null) 'oge_score': ogeScore,
      if (grammarCompletedCount != null)
        'grammar_completed_count': grammarCompletedCount,
      if (wordFormationCompletedCount != null)
        'word_formation_completed_count': wordFormationCompletedCount,
      if (ibCompletedTasksCount != null)
        'ib_completed_tasks_count': ibCompletedTasksCount,
      if (srsMasteredCount != null) 'srs_mastered_count': srsMasteredCount,
      if (streakDays != null) 'streak_days': streakDays,
      if (lastPracticeAt != null) 'last_practice_at': lastPracticeAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProgressTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? ogeScore,
      Value<int>? grammarCompletedCount,
      Value<int>? wordFormationCompletedCount,
      Value<int>? ibCompletedTasksCount,
      Value<int>? srsMasteredCount,
      Value<int>? streakDays,
      Value<DateTime?>? lastPracticeAt,
      Value<int>? rowid}) {
    return UserProgressTableCompanion(
      id: id ?? this.id,
      ogeScore: ogeScore ?? this.ogeScore,
      grammarCompletedCount:
          grammarCompletedCount ?? this.grammarCompletedCount,
      wordFormationCompletedCount:
          wordFormationCompletedCount ?? this.wordFormationCompletedCount,
      ibCompletedTasksCount:
          ibCompletedTasksCount ?? this.ibCompletedTasksCount,
      srsMasteredCount: srsMasteredCount ?? this.srsMasteredCount,
      streakDays: streakDays ?? this.streakDays,
      lastPracticeAt: lastPracticeAt ?? this.lastPracticeAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ogeScore.present) {
      map['oge_score'] = Variable<int>(ogeScore.value);
    }
    if (grammarCompletedCount.present) {
      map['grammar_completed_count'] =
          Variable<int>(grammarCompletedCount.value);
    }
    if (wordFormationCompletedCount.present) {
      map['word_formation_completed_count'] =
          Variable<int>(wordFormationCompletedCount.value);
    }
    if (ibCompletedTasksCount.present) {
      map['ib_completed_tasks_count'] =
          Variable<int>(ibCompletedTasksCount.value);
    }
    if (srsMasteredCount.present) {
      map['srs_mastered_count'] = Variable<int>(srsMasteredCount.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    if (lastPracticeAt.present) {
      map['last_practice_at'] = Variable<DateTime>(lastPracticeAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('ogeScore: $ogeScore, ')
          ..write('grammarCompletedCount: $grammarCompletedCount, ')
          ..write('wordFormationCompletedCount: $wordFormationCompletedCount, ')
          ..write('ibCompletedTasksCount: $ibCompletedTasksCount, ')
          ..write('srsMasteredCount: $srsMasteredCount, ')
          ..write('streakDays: $streakDays, ')
          ..write('lastPracticeAt: $lastPracticeAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserBadgesTable extends UserBadges
    with TableInfo<$UserBadgesTable, UserBadgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserBadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isUnlockedMeta =
      const VerificationMeta('isUnlocked');
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
      'is_unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, icon, category, isUnlocked, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_badges';
  @override
  VerificationContext validateIntegrity(Insertable<UserBadgeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
          _isUnlockedMeta,
          isUnlocked.isAcceptableOrUnknown(
              data['is_unlocked']!, _isUnlockedMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserBadgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserBadgeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isUnlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_unlocked'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at']),
    );
  }

  @override
  $UserBadgesTable createAlias(String alias) {
    return $UserBadgesTable(attachedDatabase, alias);
  }
}

class UserBadgeRow extends DataClass implements Insertable<UserBadgeRow> {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  const UserBadgeRow(
      {required this.id,
      required this.title,
      required this.description,
      required this.icon,
      required this.category,
      required this.isUnlocked,
      this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['category'] = Variable<String>(category);
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    return map;
  }

  UserBadgesCompanion toCompanion(bool nullToAbsent) {
    return UserBadgesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      icon: Value(icon),
      category: Value(category),
      isUnlocked: Value(isUnlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
    );
  }

  factory UserBadgeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserBadgeRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      category: serializer.fromJson<String>(json['category']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'category': serializer.toJson<String>(category),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
    };
  }

  UserBadgeRow copyWith(
          {String? id,
          String? title,
          String? description,
          String? icon,
          String? category,
          bool? isUnlocked,
          Value<DateTime?> unlockedAt = const Value.absent()}) =>
      UserBadgeRow(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        category: category ?? this.category,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
      );
  UserBadgeRow copyWithCompanion(UserBadgesCompanion data) {
    return UserBadgeRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      category: data.category.present ? data.category.value : this.category,
      isUnlocked:
          data.isUnlocked.present ? data.isUnlocked.value : this.isUnlocked,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserBadgeRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, icon, category, isUnlocked, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBadgeRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.category == this.category &&
          other.isUnlocked == this.isUnlocked &&
          other.unlockedAt == this.unlockedAt);
}

class UserBadgesCompanion extends UpdateCompanion<UserBadgeRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> icon;
  final Value<String> category;
  final Value<bool> isUnlocked;
  final Value<DateTime?> unlockedAt;
  final Value<int> rowid;
  const UserBadgesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserBadgesCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String icon,
    required String category,
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        icon = Value(icon),
        category = Value(category);
  static Insertable<UserBadgeRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? category,
    Expression<bool>? isUnlocked,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (category != null) 'category': category,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserBadgesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? icon,
      Value<String>? category,
      Value<bool>? isUnlocked,
      Value<DateTime?>? unlockedAt,
      Value<int>? rowid}) {
    return UserBadgesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserBadgesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamAttemptsTable extends ExamAttempts
    with TableInfo<$ExamAttemptsTable, ExamAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreOutOf68Meta =
      const VerificationMeta('scoreOutOf68');
  @override
  late final GeneratedColumn<int> scoreOutOf68 = GeneratedColumn<int>(
      'score_out_of68', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gradeMarkMeta =
      const VerificationMeta('gradeMark');
  @override
  late final GeneratedColumn<int> gradeMark = GeneratedColumn<int>(
      'grade_mark', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, scoreOutOf68, gradeMark, durationSeconds, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<ExamAttemptRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('score_out_of68')) {
      context.handle(
          _scoreOutOf68Meta,
          scoreOutOf68.isAcceptableOrUnknown(
              data['score_out_of68']!, _scoreOutOf68Meta));
    } else if (isInserting) {
      context.missing(_scoreOutOf68Meta);
    }
    if (data.containsKey('grade_mark')) {
      context.handle(_gradeMarkMeta,
          gradeMark.isAcceptableOrUnknown(data['grade_mark']!, _gradeMarkMeta));
    } else if (isInserting) {
      context.missing(_gradeMarkMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamAttemptRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      scoreOutOf68: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score_out_of68'])!,
      gradeMark: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade_mark'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $ExamAttemptsTable createAlias(String alias) {
    return $ExamAttemptsTable(attachedDatabase, alias);
  }
}

class ExamAttemptRow extends DataClass implements Insertable<ExamAttemptRow> {
  final String id;
  final int scoreOutOf68;
  final int gradeMark;
  final int durationSeconds;
  final DateTime completedAt;
  const ExamAttemptRow(
      {required this.id,
      required this.scoreOutOf68,
      required this.gradeMark,
      required this.durationSeconds,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['score_out_of68'] = Variable<int>(scoreOutOf68);
    map['grade_mark'] = Variable<int>(gradeMark);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  ExamAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ExamAttemptsCompanion(
      id: Value(id),
      scoreOutOf68: Value(scoreOutOf68),
      gradeMark: Value(gradeMark),
      durationSeconds: Value(durationSeconds),
      completedAt: Value(completedAt),
    );
  }

  factory ExamAttemptRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamAttemptRow(
      id: serializer.fromJson<String>(json['id']),
      scoreOutOf68: serializer.fromJson<int>(json['scoreOutOf68']),
      gradeMark: serializer.fromJson<int>(json['gradeMark']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scoreOutOf68': serializer.toJson<int>(scoreOutOf68),
      'gradeMark': serializer.toJson<int>(gradeMark),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  ExamAttemptRow copyWith(
          {String? id,
          int? scoreOutOf68,
          int? gradeMark,
          int? durationSeconds,
          DateTime? completedAt}) =>
      ExamAttemptRow(
        id: id ?? this.id,
        scoreOutOf68: scoreOutOf68 ?? this.scoreOutOf68,
        gradeMark: gradeMark ?? this.gradeMark,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        completedAt: completedAt ?? this.completedAt,
      );
  ExamAttemptRow copyWithCompanion(ExamAttemptsCompanion data) {
    return ExamAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      scoreOutOf68: data.scoreOutOf68.present
          ? data.scoreOutOf68.value
          : this.scoreOutOf68,
      gradeMark: data.gradeMark.present ? data.gradeMark.value : this.gradeMark,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptRow(')
          ..write('id: $id, ')
          ..write('scoreOutOf68: $scoreOutOf68, ')
          ..write('gradeMark: $gradeMark, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, scoreOutOf68, gradeMark, durationSeconds, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamAttemptRow &&
          other.id == this.id &&
          other.scoreOutOf68 == this.scoreOutOf68 &&
          other.gradeMark == this.gradeMark &&
          other.durationSeconds == this.durationSeconds &&
          other.completedAt == this.completedAt);
}

class ExamAttemptsCompanion extends UpdateCompanion<ExamAttemptRow> {
  final Value<String> id;
  final Value<int> scoreOutOf68;
  final Value<int> gradeMark;
  final Value<int> durationSeconds;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const ExamAttemptsCompanion({
    this.id = const Value.absent(),
    this.scoreOutOf68 = const Value.absent(),
    this.gradeMark = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamAttemptsCompanion.insert({
    required String id,
    required int scoreOutOf68,
    required int gradeMark,
    required int durationSeconds,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        scoreOutOf68 = Value(scoreOutOf68),
        gradeMark = Value(gradeMark),
        durationSeconds = Value(durationSeconds),
        completedAt = Value(completedAt);
  static Insertable<ExamAttemptRow> custom({
    Expression<String>? id,
    Expression<int>? scoreOutOf68,
    Expression<int>? gradeMark,
    Expression<int>? durationSeconds,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scoreOutOf68 != null) 'score_out_of68': scoreOutOf68,
      if (gradeMark != null) 'grade_mark': gradeMark,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamAttemptsCompanion copyWith(
      {Value<String>? id,
      Value<int>? scoreOutOf68,
      Value<int>? gradeMark,
      Value<int>? durationSeconds,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return ExamAttemptsCompanion(
      id: id ?? this.id,
      scoreOutOf68: scoreOutOf68 ?? this.scoreOutOf68,
      gradeMark: gradeMark ?? this.gradeMark,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scoreOutOf68.present) {
      map['score_out_of68'] = Variable<int>(scoreOutOf68.value);
    }
    if (gradeMark.present) {
      map['grade_mark'] = Variable<int>(gradeMark.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('scoreOutOf68: $scoreOutOf68, ')
          ..write('gradeMark: $gradeMark, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OgeGrammarTasksTable ogeGrammarTasks =
      $OgeGrammarTasksTable(this);
  late final $OgeWordFormationTasksTable ogeWordFormationTasks =
      $OgeWordFormationTasksTable(this);
  late final $IbInquiryUnitsTable ibInquiryUnits = $IbInquiryUnitsTable(this);
  late final $SrsCardsTable srsCards = $SrsCardsTable(this);
  late final $StudyGoalsTable studyGoals = $StudyGoalsTable(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  late final $UserBadgesTable userBadges = $UserBadgesTable(this);
  late final $ExamAttemptsTable examAttempts = $ExamAttemptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        ogeGrammarTasks,
        ogeWordFormationTasks,
        ibInquiryUnits,
        srsCards,
        studyGoals,
        userProgressTable,
        userBadges,
        examAttempts
      ];
}

typedef $$OgeGrammarTasksTableCreateCompanionBuilder = OgeGrammarTasksCompanion
    Function({
  required String id,
  required String baseWord,
  required String sentenceBefore,
  required String sentenceAfter,
  required String correctAnswer,
  required String acceptableAnswersJson,
  required String ruleCategory,
  required String ruleExplanation,
  Value<String> cefrLevel,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$OgeGrammarTasksTableUpdateCompanionBuilder = OgeGrammarTasksCompanion
    Function({
  Value<String> id,
  Value<String> baseWord,
  Value<String> sentenceBefore,
  Value<String> sentenceAfter,
  Value<String> correctAnswer,
  Value<String> acceptableAnswersJson,
  Value<String> ruleCategory,
  Value<String> ruleExplanation,
  Value<String> cefrLevel,
  Value<bool> isCompleted,
  Value<int> rowid,
});

class $$OgeGrammarTasksTableFilterComposer
    extends Composer<_$AppDatabase, $OgeGrammarTasksTable> {
  $$OgeGrammarTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseWord => $composableBuilder(
      column: $table.baseWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleCategory => $composableBuilder(
      column: $table.ruleCategory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleExplanation => $composableBuilder(
      column: $table.ruleExplanation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cefrLevel => $composableBuilder(
      column: $table.cefrLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));
}

class $$OgeGrammarTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $OgeGrammarTasksTable> {
  $$OgeGrammarTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseWord => $composableBuilder(
      column: $table.baseWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleCategory => $composableBuilder(
      column: $table.ruleCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleExplanation => $composableBuilder(
      column: $table.ruleExplanation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cefrLevel => $composableBuilder(
      column: $table.cefrLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));
}

class $$OgeGrammarTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $OgeGrammarTasksTable> {
  $$OgeGrammarTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseWord =>
      $composableBuilder(column: $table.baseWord, builder: (column) => column);

  GeneratedColumn<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore, builder: (column) => column);

  GeneratedColumn<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter, builder: (column) => column);

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => column);

  GeneratedColumn<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson, builder: (column) => column);

  GeneratedColumn<String> get ruleCategory => $composableBuilder(
      column: $table.ruleCategory, builder: (column) => column);

  GeneratedColumn<String> get ruleExplanation => $composableBuilder(
      column: $table.ruleExplanation, builder: (column) => column);

  GeneratedColumn<String> get cefrLevel =>
      $composableBuilder(column: $table.cefrLevel, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);
}

class $$OgeGrammarTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OgeGrammarTasksTable,
    OgeGrammarTaskRow,
    $$OgeGrammarTasksTableFilterComposer,
    $$OgeGrammarTasksTableOrderingComposer,
    $$OgeGrammarTasksTableAnnotationComposer,
    $$OgeGrammarTasksTableCreateCompanionBuilder,
    $$OgeGrammarTasksTableUpdateCompanionBuilder,
    (
      OgeGrammarTaskRow,
      BaseReferences<_$AppDatabase, $OgeGrammarTasksTable, OgeGrammarTaskRow>
    ),
    OgeGrammarTaskRow,
    PrefetchHooks Function()> {
  $$OgeGrammarTasksTableTableManager(
      _$AppDatabase db, $OgeGrammarTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OgeGrammarTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OgeGrammarTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OgeGrammarTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> baseWord = const Value.absent(),
            Value<String> sentenceBefore = const Value.absent(),
            Value<String> sentenceAfter = const Value.absent(),
            Value<String> correctAnswer = const Value.absent(),
            Value<String> acceptableAnswersJson = const Value.absent(),
            Value<String> ruleCategory = const Value.absent(),
            Value<String> ruleExplanation = const Value.absent(),
            Value<String> cefrLevel = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OgeGrammarTasksCompanion(
            id: id,
            baseWord: baseWord,
            sentenceBefore: sentenceBefore,
            sentenceAfter: sentenceAfter,
            correctAnswer: correctAnswer,
            acceptableAnswersJson: acceptableAnswersJson,
            ruleCategory: ruleCategory,
            ruleExplanation: ruleExplanation,
            cefrLevel: cefrLevel,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String baseWord,
            required String sentenceBefore,
            required String sentenceAfter,
            required String correctAnswer,
            required String acceptableAnswersJson,
            required String ruleCategory,
            required String ruleExplanation,
            Value<String> cefrLevel = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OgeGrammarTasksCompanion.insert(
            id: id,
            baseWord: baseWord,
            sentenceBefore: sentenceBefore,
            sentenceAfter: sentenceAfter,
            correctAnswer: correctAnswer,
            acceptableAnswersJson: acceptableAnswersJson,
            ruleCategory: ruleCategory,
            ruleExplanation: ruleExplanation,
            cefrLevel: cefrLevel,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$OgeGrammarTasksTable, OgeGrammarTaskRow>(
                        table),
                    BaseReferences<_$AppDatabase, $OgeGrammarTasksTable,
                        OgeGrammarTaskRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OgeGrammarTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OgeGrammarTasksTable,
    OgeGrammarTaskRow,
    $$OgeGrammarTasksTableFilterComposer,
    $$OgeGrammarTasksTableOrderingComposer,
    $$OgeGrammarTasksTableAnnotationComposer,
    $$OgeGrammarTasksTableCreateCompanionBuilder,
    $$OgeGrammarTasksTableUpdateCompanionBuilder,
    (
      OgeGrammarTaskRow,
      BaseReferences<_$AppDatabase, $OgeGrammarTasksTable, OgeGrammarTaskRow>
    ),
    OgeGrammarTaskRow,
    PrefetchHooks Function()>;
typedef $$OgeWordFormationTasksTableCreateCompanionBuilder
    = OgeWordFormationTasksCompanion Function({
  required String id,
  required String baseWord,
  required String sentenceBefore,
  required String sentenceAfter,
  required String correctAnswer,
  required String acceptableAnswersJson,
  required String partOfSpeech,
  required String affix,
  required String explanation,
  Value<String> cefrLevel,
  Value<bool> isCompleted,
  Value<int> rowid,
});
typedef $$OgeWordFormationTasksTableUpdateCompanionBuilder
    = OgeWordFormationTasksCompanion Function({
  Value<String> id,
  Value<String> baseWord,
  Value<String> sentenceBefore,
  Value<String> sentenceAfter,
  Value<String> correctAnswer,
  Value<String> acceptableAnswersJson,
  Value<String> partOfSpeech,
  Value<String> affix,
  Value<String> explanation,
  Value<String> cefrLevel,
  Value<bool> isCompleted,
  Value<int> rowid,
});

class $$OgeWordFormationTasksTableFilterComposer
    extends Composer<_$AppDatabase, $OgeWordFormationTasksTable> {
  $$OgeWordFormationTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseWord => $composableBuilder(
      column: $table.baseWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get affix => $composableBuilder(
      column: $table.affix, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cefrLevel => $composableBuilder(
      column: $table.cefrLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));
}

class $$OgeWordFormationTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $OgeWordFormationTasksTable> {
  $$OgeWordFormationTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseWord => $composableBuilder(
      column: $table.baseWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get affix => $composableBuilder(
      column: $table.affix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cefrLevel => $composableBuilder(
      column: $table.cefrLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));
}

class $$OgeWordFormationTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $OgeWordFormationTasksTable> {
  $$OgeWordFormationTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseWord =>
      $composableBuilder(column: $table.baseWord, builder: (column) => column);

  GeneratedColumn<String> get sentenceBefore => $composableBuilder(
      column: $table.sentenceBefore, builder: (column) => column);

  GeneratedColumn<String> get sentenceAfter => $composableBuilder(
      column: $table.sentenceAfter, builder: (column) => column);

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => column);

  GeneratedColumn<String> get acceptableAnswersJson => $composableBuilder(
      column: $table.acceptableAnswersJson, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get affix =>
      $composableBuilder(column: $table.affix, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<String> get cefrLevel =>
      $composableBuilder(column: $table.cefrLevel, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);
}

class $$OgeWordFormationTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OgeWordFormationTasksTable,
    OgeWordFormationTaskRow,
    $$OgeWordFormationTasksTableFilterComposer,
    $$OgeWordFormationTasksTableOrderingComposer,
    $$OgeWordFormationTasksTableAnnotationComposer,
    $$OgeWordFormationTasksTableCreateCompanionBuilder,
    $$OgeWordFormationTasksTableUpdateCompanionBuilder,
    (
      OgeWordFormationTaskRow,
      BaseReferences<_$AppDatabase, $OgeWordFormationTasksTable,
          OgeWordFormationTaskRow>
    ),
    OgeWordFormationTaskRow,
    PrefetchHooks Function()> {
  $$OgeWordFormationTasksTableTableManager(
      _$AppDatabase db, $OgeWordFormationTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OgeWordFormationTasksTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$OgeWordFormationTasksTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OgeWordFormationTasksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> baseWord = const Value.absent(),
            Value<String> sentenceBefore = const Value.absent(),
            Value<String> sentenceAfter = const Value.absent(),
            Value<String> correctAnswer = const Value.absent(),
            Value<String> acceptableAnswersJson = const Value.absent(),
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> affix = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<String> cefrLevel = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OgeWordFormationTasksCompanion(
            id: id,
            baseWord: baseWord,
            sentenceBefore: sentenceBefore,
            sentenceAfter: sentenceAfter,
            correctAnswer: correctAnswer,
            acceptableAnswersJson: acceptableAnswersJson,
            partOfSpeech: partOfSpeech,
            affix: affix,
            explanation: explanation,
            cefrLevel: cefrLevel,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String baseWord,
            required String sentenceBefore,
            required String sentenceAfter,
            required String correctAnswer,
            required String acceptableAnswersJson,
            required String partOfSpeech,
            required String affix,
            required String explanation,
            Value<String> cefrLevel = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OgeWordFormationTasksCompanion.insert(
            id: id,
            baseWord: baseWord,
            sentenceBefore: sentenceBefore,
            sentenceAfter: sentenceAfter,
            correctAnswer: correctAnswer,
            acceptableAnswersJson: acceptableAnswersJson,
            partOfSpeech: partOfSpeech,
            affix: affix,
            explanation: explanation,
            cefrLevel: cefrLevel,
            isCompleted: isCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$OgeWordFormationTasksTable,
                        OgeWordFormationTaskRow>(table),
                    BaseReferences<_$AppDatabase, $OgeWordFormationTasksTable,
                        OgeWordFormationTaskRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OgeWordFormationTasksTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $OgeWordFormationTasksTable,
        OgeWordFormationTaskRow,
        $$OgeWordFormationTasksTableFilterComposer,
        $$OgeWordFormationTasksTableOrderingComposer,
        $$OgeWordFormationTasksTableAnnotationComposer,
        $$OgeWordFormationTasksTableCreateCompanionBuilder,
        $$OgeWordFormationTasksTableUpdateCompanionBuilder,
        (
          OgeWordFormationTaskRow,
          BaseReferences<_$AppDatabase, $OgeWordFormationTasksTable,
              OgeWordFormationTaskRow>
        ),
        OgeWordFormationTaskRow,
        PrefetchHooks Function()>;
typedef $$IbInquiryUnitsTableCreateCompanionBuilder = IbInquiryUnitsCompanion
    Function({
  required String id,
  required String title,
  required String phase,
  required String globalContext,
  required String keyConcept,
  required String relatedConceptsJson,
  required String statementOfInquiry,
  required String inquiryQuestionsJson,
  required String criteriaTasksJson,
  Value<int> completedTasksCount,
  Value<int> rowid,
});
typedef $$IbInquiryUnitsTableUpdateCompanionBuilder = IbInquiryUnitsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> phase,
  Value<String> globalContext,
  Value<String> keyConcept,
  Value<String> relatedConceptsJson,
  Value<String> statementOfInquiry,
  Value<String> inquiryQuestionsJson,
  Value<String> criteriaTasksJson,
  Value<int> completedTasksCount,
  Value<int> rowid,
});

class $$IbInquiryUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $IbInquiryUnitsTable> {
  $$IbInquiryUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get globalContext => $composableBuilder(
      column: $table.globalContext, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keyConcept => $composableBuilder(
      column: $table.keyConcept, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedConceptsJson => $composableBuilder(
      column: $table.relatedConceptsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statementOfInquiry => $composableBuilder(
      column: $table.statementOfInquiry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inquiryQuestionsJson => $composableBuilder(
      column: $table.inquiryQuestionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get criteriaTasksJson => $composableBuilder(
      column: $table.criteriaTasksJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedTasksCount => $composableBuilder(
      column: $table.completedTasksCount,
      builder: (column) => ColumnFilters(column));
}

class $$IbInquiryUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $IbInquiryUnitsTable> {
  $$IbInquiryUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get globalContext => $composableBuilder(
      column: $table.globalContext,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keyConcept => $composableBuilder(
      column: $table.keyConcept, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedConceptsJson => $composableBuilder(
      column: $table.relatedConceptsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statementOfInquiry => $composableBuilder(
      column: $table.statementOfInquiry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inquiryQuestionsJson => $composableBuilder(
      column: $table.inquiryQuestionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get criteriaTasksJson => $composableBuilder(
      column: $table.criteriaTasksJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedTasksCount => $composableBuilder(
      column: $table.completedTasksCount,
      builder: (column) => ColumnOrderings(column));
}

class $$IbInquiryUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IbInquiryUnitsTable> {
  $$IbInquiryUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get globalContext => $composableBuilder(
      column: $table.globalContext, builder: (column) => column);

  GeneratedColumn<String> get keyConcept => $composableBuilder(
      column: $table.keyConcept, builder: (column) => column);

  GeneratedColumn<String> get relatedConceptsJson => $composableBuilder(
      column: $table.relatedConceptsJson, builder: (column) => column);

  GeneratedColumn<String> get statementOfInquiry => $composableBuilder(
      column: $table.statementOfInquiry, builder: (column) => column);

  GeneratedColumn<String> get inquiryQuestionsJson => $composableBuilder(
      column: $table.inquiryQuestionsJson, builder: (column) => column);

  GeneratedColumn<String> get criteriaTasksJson => $composableBuilder(
      column: $table.criteriaTasksJson, builder: (column) => column);

  GeneratedColumn<int> get completedTasksCount => $composableBuilder(
      column: $table.completedTasksCount, builder: (column) => column);
}

class $$IbInquiryUnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IbInquiryUnitsTable,
    IbInquiryUnitRow,
    $$IbInquiryUnitsTableFilterComposer,
    $$IbInquiryUnitsTableOrderingComposer,
    $$IbInquiryUnitsTableAnnotationComposer,
    $$IbInquiryUnitsTableCreateCompanionBuilder,
    $$IbInquiryUnitsTableUpdateCompanionBuilder,
    (
      IbInquiryUnitRow,
      BaseReferences<_$AppDatabase, $IbInquiryUnitsTable, IbInquiryUnitRow>
    ),
    IbInquiryUnitRow,
    PrefetchHooks Function()> {
  $$IbInquiryUnitsTableTableManager(
      _$AppDatabase db, $IbInquiryUnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IbInquiryUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IbInquiryUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IbInquiryUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> phase = const Value.absent(),
            Value<String> globalContext = const Value.absent(),
            Value<String> keyConcept = const Value.absent(),
            Value<String> relatedConceptsJson = const Value.absent(),
            Value<String> statementOfInquiry = const Value.absent(),
            Value<String> inquiryQuestionsJson = const Value.absent(),
            Value<String> criteriaTasksJson = const Value.absent(),
            Value<int> completedTasksCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IbInquiryUnitsCompanion(
            id: id,
            title: title,
            phase: phase,
            globalContext: globalContext,
            keyConcept: keyConcept,
            relatedConceptsJson: relatedConceptsJson,
            statementOfInquiry: statementOfInquiry,
            inquiryQuestionsJson: inquiryQuestionsJson,
            criteriaTasksJson: criteriaTasksJson,
            completedTasksCount: completedTasksCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String phase,
            required String globalContext,
            required String keyConcept,
            required String relatedConceptsJson,
            required String statementOfInquiry,
            required String inquiryQuestionsJson,
            required String criteriaTasksJson,
            Value<int> completedTasksCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IbInquiryUnitsCompanion.insert(
            id: id,
            title: title,
            phase: phase,
            globalContext: globalContext,
            keyConcept: keyConcept,
            relatedConceptsJson: relatedConceptsJson,
            statementOfInquiry: statementOfInquiry,
            inquiryQuestionsJson: inquiryQuestionsJson,
            criteriaTasksJson: criteriaTasksJson,
            completedTasksCount: completedTasksCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$IbInquiryUnitsTable, IbInquiryUnitRow>(table),
                    BaseReferences<_$AppDatabase, $IbInquiryUnitsTable,
                        IbInquiryUnitRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IbInquiryUnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IbInquiryUnitsTable,
    IbInquiryUnitRow,
    $$IbInquiryUnitsTableFilterComposer,
    $$IbInquiryUnitsTableOrderingComposer,
    $$IbInquiryUnitsTableAnnotationComposer,
    $$IbInquiryUnitsTableCreateCompanionBuilder,
    $$IbInquiryUnitsTableUpdateCompanionBuilder,
    (
      IbInquiryUnitRow,
      BaseReferences<_$AppDatabase, $IbInquiryUnitsTable, IbInquiryUnitRow>
    ),
    IbInquiryUnitRow,
    PrefetchHooks Function()>;
typedef $$SrsCardsTableCreateCompanionBuilder = SrsCardsCompanion Function({
  required String id,
  required String frontEnglish,
  required String backRussian,
  Value<String?> transcriptionIpa,
  Value<String> level,
  Value<String> category,
  Value<String?> exampleSentence,
  Value<String?> exampleTranslation,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  required DateTime dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});
typedef $$SrsCardsTableUpdateCompanionBuilder = SrsCardsCompanion Function({
  Value<String> id,
  Value<String> frontEnglish,
  Value<String> backRussian,
  Value<String?> transcriptionIpa,
  Value<String> level,
  Value<String> category,
  Value<String?> exampleSentence,
  Value<String?> exampleTranslation,
  Value<String> fsrsState,
  Value<double> stability,
  Value<double> difficulty,
  Value<int> reps,
  Value<int> lapses,
  Value<DateTime> dueAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});

class $$SrsCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));
}

class $$SrsCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fsrsState => $composableBuilder(
      column: $table.fsrsState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stability => $composableBuilder(
      column: $table.stability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lapses => $composableBuilder(
      column: $table.lapses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SrsCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get frontEnglish => $composableBuilder(
      column: $table.frontEnglish, builder: (column) => column);

  GeneratedColumn<String> get backRussian => $composableBuilder(
      column: $table.backRussian, builder: (column) => column);

  GeneratedColumn<String> get transcriptionIpa => $composableBuilder(
      column: $table.transcriptionIpa, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
      column: $table.exampleSentence, builder: (column) => column);

  GeneratedColumn<String> get exampleTranslation => $composableBuilder(
      column: $table.exampleTranslation, builder: (column) => column);

  GeneratedColumn<String> get fsrsState =>
      $composableBuilder(column: $table.fsrsState, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);
}

class $$SrsCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()> {
  $$SrsCardsTableTableManager(_$AppDatabase db, $SrsCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> frontEnglish = const Value.absent(),
            Value<String> backRussian = const Value.absent(),
            Value<String?> transcriptionIpa = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> exampleSentence = const Value.absent(),
            Value<String?> exampleTranslation = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion(
            id: id,
            frontEnglish: frontEnglish,
            backRussian: backRussian,
            transcriptionIpa: transcriptionIpa,
            level: level,
            category: category,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String frontEnglish,
            required String backRussian,
            Value<String?> transcriptionIpa = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> exampleSentence = const Value.absent(),
            Value<String?> exampleTranslation = const Value.absent(),
            Value<String> fsrsState = const Value.absent(),
            Value<double> stability = const Value.absent(),
            Value<double> difficulty = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> lapses = const Value.absent(),
            required DateTime dueAt,
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SrsCardsCompanion.insert(
            id: id,
            frontEnglish: frontEnglish,
            backRussian: backRussian,
            transcriptionIpa: transcriptionIpa,
            level: level,
            category: category,
            exampleSentence: exampleSentence,
            exampleTranslation: exampleTranslation,
            fsrsState: fsrsState,
            stability: stability,
            difficulty: difficulty,
            reps: reps,
            lapses: lapses,
            dueAt: dueAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SrsCardsTable, SrsCardRow>(table),
                    BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SrsCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsCardsTable,
    SrsCardRow,
    $$SrsCardsTableFilterComposer,
    $$SrsCardsTableOrderingComposer,
    $$SrsCardsTableAnnotationComposer,
    $$SrsCardsTableCreateCompanionBuilder,
    $$SrsCardsTableUpdateCompanionBuilder,
    (SrsCardRow, BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCardRow>),
    SrsCardRow,
    PrefetchHooks Function()>;
typedef $$StudyGoalsTableCreateCompanionBuilder = StudyGoalsCompanion Function({
  required String id,
  required String title,
  required String description,
  required String category,
  required int targetValue,
  required int currentValue,
  required String unit,
  required int deadlineDays,
  Value<bool> isPrimary,
  Value<int> rowid,
});
typedef $$StudyGoalsTableUpdateCompanionBuilder = StudyGoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> category,
  Value<int> targetValue,
  Value<int> currentValue,
  Value<String> unit,
  Value<int> deadlineDays,
  Value<bool> isPrimary,
  Value<int> rowid,
});

class $$StudyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deadlineDays => $composableBuilder(
      column: $table.deadlineDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnFilters(column));
}

class $$StudyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentValue => $composableBuilder(
      column: $table.currentValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deadlineDays => $composableBuilder(
      column: $table.deadlineDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
      column: $table.isPrimary, builder: (column) => ColumnOrderings(column));
}

class $$StudyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyGoalsTable> {
  $$StudyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<int> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get deadlineDays => $composableBuilder(
      column: $table.deadlineDays, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);
}

class $$StudyGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudyGoalsTable,
    StudyGoalRow,
    $$StudyGoalsTableFilterComposer,
    $$StudyGoalsTableOrderingComposer,
    $$StudyGoalsTableAnnotationComposer,
    $$StudyGoalsTableCreateCompanionBuilder,
    $$StudyGoalsTableUpdateCompanionBuilder,
    (
      StudyGoalRow,
      BaseReferences<_$AppDatabase, $StudyGoalsTable, StudyGoalRow>
    ),
    StudyGoalRow,
    PrefetchHooks Function()> {
  $$StudyGoalsTableTableManager(_$AppDatabase db, $StudyGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> targetValue = const Value.absent(),
            Value<int> currentValue = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> deadlineDays = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyGoalsCompanion(
            id: id,
            title: title,
            description: description,
            category: category,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadlineDays: deadlineDays,
            isPrimary: isPrimary,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String category,
            required int targetValue,
            required int currentValue,
            required String unit,
            required int deadlineDays,
            Value<bool> isPrimary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudyGoalsCompanion.insert(
            id: id,
            title: title,
            description: description,
            category: category,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadlineDays: deadlineDays,
            isPrimary: isPrimary,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StudyGoalsTable, StudyGoalRow>(table),
                    BaseReferences<_$AppDatabase, $StudyGoalsTable,
                        StudyGoalRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudyGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudyGoalsTable,
    StudyGoalRow,
    $$StudyGoalsTableFilterComposer,
    $$StudyGoalsTableOrderingComposer,
    $$StudyGoalsTableAnnotationComposer,
    $$StudyGoalsTableCreateCompanionBuilder,
    $$StudyGoalsTableUpdateCompanionBuilder,
    (
      StudyGoalRow,
      BaseReferences<_$AppDatabase, $StudyGoalsTable, StudyGoalRow>
    ),
    StudyGoalRow,
    PrefetchHooks Function()>;
typedef $$UserProgressTableTableCreateCompanionBuilder
    = UserProgressTableCompanion Function({
  required String id,
  Value<int> ogeScore,
  Value<int> grammarCompletedCount,
  Value<int> wordFormationCompletedCount,
  Value<int> ibCompletedTasksCount,
  Value<int> srsMasteredCount,
  Value<int> streakDays,
  Value<DateTime?> lastPracticeAt,
  Value<int> rowid,
});
typedef $$UserProgressTableTableUpdateCompanionBuilder
    = UserProgressTableCompanion Function({
  Value<String> id,
  Value<int> ogeScore,
  Value<int> grammarCompletedCount,
  Value<int> wordFormationCompletedCount,
  Value<int> ibCompletedTasksCount,
  Value<int> srsMasteredCount,
  Value<int> streakDays,
  Value<DateTime?> lastPracticeAt,
  Value<int> rowid,
});

class $$UserProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ogeScore => $composableBuilder(
      column: $table.ogeScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grammarCompletedCount => $composableBuilder(
      column: $table.grammarCompletedCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordFormationCompletedCount => $composableBuilder(
      column: $table.wordFormationCompletedCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ibCompletedTasksCount => $composableBuilder(
      column: $table.ibCompletedTasksCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get srsMasteredCount => $composableBuilder(
      column: $table.srsMasteredCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPracticeAt => $composableBuilder(
      column: $table.lastPracticeAt,
      builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ogeScore => $composableBuilder(
      column: $table.ogeScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grammarCompletedCount => $composableBuilder(
      column: $table.grammarCompletedCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordFormationCompletedCount => $composableBuilder(
      column: $table.wordFormationCompletedCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ibCompletedTasksCount => $composableBuilder(
      column: $table.ibCompletedTasksCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get srsMasteredCount => $composableBuilder(
      column: $table.srsMasteredCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPracticeAt => $composableBuilder(
      column: $table.lastPracticeAt,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ogeScore =>
      $composableBuilder(column: $table.ogeScore, builder: (column) => column);

  GeneratedColumn<int> get grammarCompletedCount => $composableBuilder(
      column: $table.grammarCompletedCount, builder: (column) => column);

  GeneratedColumn<int> get wordFormationCompletedCount => $composableBuilder(
      column: $table.wordFormationCompletedCount, builder: (column) => column);

  GeneratedColumn<int> get ibCompletedTasksCount => $composableBuilder(
      column: $table.ibCompletedTasksCount, builder: (column) => column);

  GeneratedColumn<int> get srsMasteredCount => $composableBuilder(
      column: $table.srsMasteredCount, builder: (column) => column);

  GeneratedColumn<int> get streakDays => $composableBuilder(
      column: $table.streakDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPracticeAt => $composableBuilder(
      column: $table.lastPracticeAt, builder: (column) => column);
}

class $$UserProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressRow,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTableTable, UserProgressRow>
    ),
    UserProgressRow,
    PrefetchHooks Function()> {
  $$UserProgressTableTableTableManager(
      _$AppDatabase db, $UserProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> ogeScore = const Value.absent(),
            Value<int> grammarCompletedCount = const Value.absent(),
            Value<int> wordFormationCompletedCount = const Value.absent(),
            Value<int> ibCompletedTasksCount = const Value.absent(),
            Value<int> srsMasteredCount = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<DateTime?> lastPracticeAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressTableCompanion(
            id: id,
            ogeScore: ogeScore,
            grammarCompletedCount: grammarCompletedCount,
            wordFormationCompletedCount: wordFormationCompletedCount,
            ibCompletedTasksCount: ibCompletedTasksCount,
            srsMasteredCount: srsMasteredCount,
            streakDays: streakDays,
            lastPracticeAt: lastPracticeAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> ogeScore = const Value.absent(),
            Value<int> grammarCompletedCount = const Value.absent(),
            Value<int> wordFormationCompletedCount = const Value.absent(),
            Value<int> ibCompletedTasksCount = const Value.absent(),
            Value<int> srsMasteredCount = const Value.absent(),
            Value<int> streakDays = const Value.absent(),
            Value<DateTime?> lastPracticeAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProgressTableCompanion.insert(
            id: id,
            ogeScore: ogeScore,
            grammarCompletedCount: grammarCompletedCount,
            wordFormationCompletedCount: wordFormationCompletedCount,
            ibCompletedTasksCount: ibCompletedTasksCount,
            srsMasteredCount: srsMasteredCount,
            streakDays: streakDays,
            lastPracticeAt: lastPracticeAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UserProgressTableTable, UserProgressRow>(
                        table),
                    BaseReferences<_$AppDatabase, $UserProgressTableTable,
                        UserProgressRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTableTable,
    UserProgressRow,
    $$UserProgressTableTableFilterComposer,
    $$UserProgressTableTableOrderingComposer,
    $$UserProgressTableTableAnnotationComposer,
    $$UserProgressTableTableCreateCompanionBuilder,
    $$UserProgressTableTableUpdateCompanionBuilder,
    (
      UserProgressRow,
      BaseReferences<_$AppDatabase, $UserProgressTableTable, UserProgressRow>
    ),
    UserProgressRow,
    PrefetchHooks Function()>;
typedef $$UserBadgesTableCreateCompanionBuilder = UserBadgesCompanion Function({
  required String id,
  required String title,
  required String description,
  required String icon,
  required String category,
  Value<bool> isUnlocked,
  Value<DateTime?> unlockedAt,
  Value<int> rowid,
});
typedef $$UserBadgesTableUpdateCompanionBuilder = UserBadgesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> icon,
  Value<String> category,
  Value<bool> isUnlocked,
  Value<DateTime?> unlockedAt,
  Value<int> rowid,
});

class $$UserBadgesTableFilterComposer
    extends Composer<_$AppDatabase, $UserBadgesTable> {
  $$UserBadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$UserBadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserBadgesTable> {
  $$UserBadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserBadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserBadgesTable> {
  $$UserBadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$UserBadgesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserBadgesTable,
    UserBadgeRow,
    $$UserBadgesTableFilterComposer,
    $$UserBadgesTableOrderingComposer,
    $$UserBadgesTableAnnotationComposer,
    $$UserBadgesTableCreateCompanionBuilder,
    $$UserBadgesTableUpdateCompanionBuilder,
    (
      UserBadgeRow,
      BaseReferences<_$AppDatabase, $UserBadgesTable, UserBadgeRow>
    ),
    UserBadgeRow,
    PrefetchHooks Function()> {
  $$UserBadgesTableTableManager(_$AppDatabase db, $UserBadgesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserBadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserBadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserBadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserBadgesCompanion(
            id: id,
            title: title,
            description: description,
            icon: icon,
            category: category,
            isUnlocked: isUnlocked,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            required String icon,
            required String category,
            Value<bool> isUnlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserBadgesCompanion.insert(
            id: id,
            title: title,
            description: description,
            icon: icon,
            category: category,
            isUnlocked: isUnlocked,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UserBadgesTable, UserBadgeRow>(table),
                    BaseReferences<_$AppDatabase, $UserBadgesTable,
                        UserBadgeRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserBadgesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserBadgesTable,
    UserBadgeRow,
    $$UserBadgesTableFilterComposer,
    $$UserBadgesTableOrderingComposer,
    $$UserBadgesTableAnnotationComposer,
    $$UserBadgesTableCreateCompanionBuilder,
    $$UserBadgesTableUpdateCompanionBuilder,
    (
      UserBadgeRow,
      BaseReferences<_$AppDatabase, $UserBadgesTable, UserBadgeRow>
    ),
    UserBadgeRow,
    PrefetchHooks Function()>;
typedef $$ExamAttemptsTableCreateCompanionBuilder = ExamAttemptsCompanion
    Function({
  required String id,
  required int scoreOutOf68,
  required int gradeMark,
  required int durationSeconds,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$ExamAttemptsTableUpdateCompanionBuilder = ExamAttemptsCompanion
    Function({
  Value<String> id,
  Value<int> scoreOutOf68,
  Value<int> gradeMark,
  Value<int> durationSeconds,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

class $$ExamAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scoreOutOf68 => $composableBuilder(
      column: $table.scoreOutOf68, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gradeMark => $composableBuilder(
      column: $table.gradeMark, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$ExamAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scoreOutOf68 => $composableBuilder(
      column: $table.scoreOutOf68,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gradeMark => $composableBuilder(
      column: $table.gradeMark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExamAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get scoreOutOf68 => $composableBuilder(
      column: $table.scoreOutOf68, builder: (column) => column);

  GeneratedColumn<int> get gradeMark =>
      $composableBuilder(column: $table.gradeMark, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$ExamAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamAttemptsTable,
    ExamAttemptRow,
    $$ExamAttemptsTableFilterComposer,
    $$ExamAttemptsTableOrderingComposer,
    $$ExamAttemptsTableAnnotationComposer,
    $$ExamAttemptsTableCreateCompanionBuilder,
    $$ExamAttemptsTableUpdateCompanionBuilder,
    (
      ExamAttemptRow,
      BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttemptRow>
    ),
    ExamAttemptRow,
    PrefetchHooks Function()> {
  $$ExamAttemptsTableTableManager(_$AppDatabase db, $ExamAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> scoreOutOf68 = const Value.absent(),
            Value<int> gradeMark = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamAttemptsCompanion(
            id: id,
            scoreOutOf68: scoreOutOf68,
            gradeMark: gradeMark,
            durationSeconds: durationSeconds,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int scoreOutOf68,
            required int gradeMark,
            required int durationSeconds,
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamAttemptsCompanion.insert(
            id: id,
            scoreOutOf68: scoreOutOf68,
            gradeMark: gradeMark,
            durationSeconds: durationSeconds,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ExamAttemptsTable, ExamAttemptRow>(table),
                    BaseReferences<_$AppDatabase, $ExamAttemptsTable,
                        ExamAttemptRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExamAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamAttemptsTable,
    ExamAttemptRow,
    $$ExamAttemptsTableFilterComposer,
    $$ExamAttemptsTableOrderingComposer,
    $$ExamAttemptsTableAnnotationComposer,
    $$ExamAttemptsTableCreateCompanionBuilder,
    $$ExamAttemptsTableUpdateCompanionBuilder,
    (
      ExamAttemptRow,
      BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttemptRow>
    ),
    ExamAttemptRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OgeGrammarTasksTableTableManager get ogeGrammarTasks =>
      $$OgeGrammarTasksTableTableManager(_db, _db.ogeGrammarTasks);
  $$OgeWordFormationTasksTableTableManager get ogeWordFormationTasks =>
      $$OgeWordFormationTasksTableTableManager(_db, _db.ogeWordFormationTasks);
  $$IbInquiryUnitsTableTableManager get ibInquiryUnits =>
      $$IbInquiryUnitsTableTableManager(_db, _db.ibInquiryUnits);
  $$SrsCardsTableTableManager get srsCards =>
      $$SrsCardsTableTableManager(_db, _db.srsCards);
  $$StudyGoalsTableTableManager get studyGoals =>
      $$StudyGoalsTableTableManager(_db, _db.studyGoals);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
  $$UserBadgesTableTableManager get userBadges =>
      $$UserBadgesTableTableManager(_db, _db.userBadges);
  $$ExamAttemptsTableTableManager get examAttempts =>
      $$ExamAttemptsTableTableManager(_db, _db.examAttempts);
}
