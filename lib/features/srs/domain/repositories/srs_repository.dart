import '../../../../core/result/result.dart';
import '../entities/srs_card_entity.dart';

abstract interface class SrsRepository {
  Future<Result<List<SrsCardEntity>>> getAllCards();
  Future<Result<List<SrsCardEntity>>> getDueCards();
  Future<Result<void>> rateCard({
    required String cardId,
    required int rating, // 1: Again, 2: Hard, 3: Good, 4: Easy
  });
}
