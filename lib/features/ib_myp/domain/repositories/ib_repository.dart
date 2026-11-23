import '../../../../core/result/result.dart';
import '../entities/ib_unit_entity.dart';

abstract interface class IbRepository {
  Future<Result<List<IbInquiryUnitEntity>>> getIbUnits();
  Future<Result<void>> markTaskCompleted(String unitId);
}
