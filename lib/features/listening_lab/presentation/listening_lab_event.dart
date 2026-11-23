import 'package:equatable/equatable.dart';

sealed class ListeningLabEvent extends Equatable {
  const ListeningLabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMinimalPairsEvent extends ListeningLabEvent {
  const LoadMinimalPairsEvent();
}

final class SelectPairChoiceEvent extends ListeningLabEvent {
  final String chosenWord;
  const SelectPairChoiceEvent(this.chosenWord);

  @override
  List<Object?> get props => [chosenWord];
}

final class NextPairEvent extends ListeningLabEvent {
  const NextPairEvent();
}
