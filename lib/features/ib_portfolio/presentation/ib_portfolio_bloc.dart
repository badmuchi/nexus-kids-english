import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/entities/ib_portfolio_entity.dart';
import '../domain/repositories/ib_portfolio_repository.dart';
import 'ib_portfolio_event.dart';
import 'ib_portfolio_state.dart';

class IbPortfolioBloc extends Bloc<IbPortfolioEvent, IbPortfolioState> {
  final IbPortfolioRepository _repository;

  IbPortfolioBloc({required IbPortfolioRepository repository})
      : _repository = repository,
        super(const IbPortfolioInitial()) {
    on<LoadIbPortfolio>(_onLoadIbPortfolio);
    on<AddIbPortfolioSubmission>(_onAddIbPortfolioSubmission);
  }

  Future<void> _onLoadIbPortfolio(
    LoadIbPortfolio event,
    Emitter<IbPortfolioState> emit,
  ) async {
    emit(const IbPortfolioLoading());
    final itemsResult = await _repository.getAllPortfolioItems();
    final summaryResult = await _repository.getScoreSummary();

    switch ((itemsResult, summaryResult)) {
      case (
          Success(value: final List<IbPortfolioEntity> items),
          Success(value: final IbScoreSummary summary),
        ):
        emit(IbPortfolioLoaded(items: items, summary: summary));
      default:
        emit(const IbPortfolioError('Failed to load IB portfolio'));
    }
  }

  Future<void> _onAddIbPortfolioSubmission(
    AddIbPortfolioSubmission event,
    Emitter<IbPortfolioState> emit,
  ) async {
    final addResult = await _repository.addPortfolioItem(
      id: 'ib_port_${DateTime.now().millisecondsSinceEpoch}',
      unitId: event.unitId,
      unitTitle: event.unitTitle,
      criterion: event.criterion,
      taskTitle: event.taskTitle,
      content: event.content,
      scoreOutOf8: event.scoreOutOf8,
    );

    switch (addResult) {
      case Success():
        add(const LoadIbPortfolio());
      case Failure(error: final err):
        emit(IbPortfolioError(err.toString()));
    }
  }
}
