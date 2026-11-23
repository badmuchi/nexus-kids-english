import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/ib_repository.dart';
import 'ib_event.dart';
import 'ib_state.dart';

class IbBloc extends Bloc<IbEvent, IbState> {
  final IbRepository _repository;

  IbBloc({required IbRepository repository})
      : _repository = repository,
        super(const IbInitial()) {
    on<LoadIbUnitsEvent>(_onLoadUnits);
    on<CompleteIbTaskEvent>(_onCompleteTask);
  }

  Future<void> _onLoadUnits(LoadIbUnitsEvent event, Emitter<IbState> emit) async {
    emit(const IbLoading());
    final result = await _repository.getIbUnits();
    switch (result) {
      case Success(value: final units):
        emit(IbLoaded(units));
      case Failure(error: final err):
        emit(IbErrorState(err.toString()));
    }
  }

  Future<void> _onCompleteTask(CompleteIbTaskEvent event, Emitter<IbState> emit) async {
    await _repository.markTaskCompleted(event.unitId);
    add(const LoadIbUnitsEvent());
  }
}
