import 'package:equatable/equatable.dart';

class IrregularVerbEntity extends Equatable {
  final String id;
  final String v1;
  final String v2;
  final String v3;
  final String translation;
  final String rhymeGroup;
  final String exampleSentence;

  const IrregularVerbEntity({
    required this.id,
    required this.v1,
    required this.v2,
    required this.v3,
    required this.translation,
    required this.rhymeGroup,
    required this.exampleSentence,
  });

  String get formsTrio => '$v1 — $v2 — $v3';

  @override
  List<Object?> get props => [
        id,
        v1,
        v2,
        v3,
        translation,
        rhymeGroup,
        exampleSentence,
      ];
}
