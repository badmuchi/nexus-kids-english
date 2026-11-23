import 'package:equatable/equatable.dart';
import '../domain/entities/irregular_verb_entity.dart';

sealed class VerbsState extends Equatable {
  const VerbsState();

  @override
  List<Object?> get props => [];
}

final class VerbsInitial extends VerbsState {
  const VerbsInitial();
}

final class VerbsLoading extends VerbsState {
  const VerbsLoading();
}

final class VerbsLoaded extends VerbsState {
  final List<IrregularVerbEntity> allVerbs;
  final List<IrregularVerbEntity> displayedVerbs;
  final List<String> rhymeGroups;
  final String selectedGroup;

  const VerbsLoaded({
    required this.allVerbs,
    required this.displayedVerbs,
    required this.rhymeGroups,
    this.selectedGroup = 'Все',
  });

  VerbsLoaded copyWith({
    List<IrregularVerbEntity>? allVerbs,
    List<IrregularVerbEntity>? displayedVerbs,
    List<String>? rhymeGroups,
    String? selectedGroup,
  }) {
    return VerbsLoaded(
      allVerbs: allVerbs ?? this.allVerbs,
      displayedVerbs: displayedVerbs ?? this.displayedVerbs,
      rhymeGroups: rhymeGroups ?? this.rhymeGroups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }

  @override
  List<Object?> get props => [allVerbs, displayedVerbs, rhymeGroups, selectedGroup];
}

final class VerbsErrorState extends VerbsState {
  final String message;
  const VerbsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
