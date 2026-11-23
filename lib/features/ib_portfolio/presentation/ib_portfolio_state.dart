import 'package:equatable/equatable.dart';
import '../domain/entities/ib_portfolio_entity.dart';

abstract class IbPortfolioState extends Equatable {
  const IbPortfolioState();

  @override
  List<Object?> get props => [];
}

class IbPortfolioInitial extends IbPortfolioState {
  const IbPortfolioInitial();
}

class IbPortfolioLoading extends IbPortfolioState {
  const IbPortfolioLoading();
}

class IbPortfolioLoaded extends IbPortfolioState {
  final List<IbPortfolioEntity> items;
  final IbScoreSummary summary;

  const IbPortfolioLoaded({
    required this.items,
    required this.summary,
  });

  @override
  List<Object?> get props => [items, summary];
}

class IbPortfolioError extends IbPortfolioState {
  final String message;

  const IbPortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
