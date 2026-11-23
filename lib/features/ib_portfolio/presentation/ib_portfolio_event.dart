import 'package:equatable/equatable.dart';

abstract class IbPortfolioEvent extends Equatable {
  const IbPortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadIbPortfolio extends IbPortfolioEvent {
  const LoadIbPortfolio();
}

class AddIbPortfolioSubmission extends IbPortfolioEvent {
  final String unitId;
  final String unitTitle;
  final String criterion;
  final String taskTitle;
  final String content;
  final int scoreOutOf8;

  const AddIbPortfolioSubmission({
    required this.unitId,
    required this.unitTitle,
    required this.criterion,
    required this.taskTitle,
    required this.content,
    required this.scoreOutOf8,
  });

  @override
  List<Object?> get props => [
        unitId,
        unitTitle,
        criterion,
        taskTitle,
        content,
        scoreOutOf8,
      ];
}
