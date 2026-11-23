import 'package:equatable/equatable.dart';

class MinimalPairEntity extends Equatable {
  final String id;
  final String wordA;
  final String wordB;
  final String ipaA;
  final String ipaB;
  final String meaningA;
  final String meaningB;
  final String soundFocus;
  final String tip;

  const MinimalPairEntity({
    required this.id,
    required this.wordA,
    required this.wordB,
    required this.ipaA,
    required this.ipaB,
    required this.meaningA,
    required this.meaningB,
    required this.soundFocus,
    required this.tip,
  });

  @override
  List<Object?> get props => [
        id,
        wordA,
        wordB,
        ipaA,
        ipaB,
        meaningA,
        meaningB,
        soundFocus,
        tip,
      ];
}
