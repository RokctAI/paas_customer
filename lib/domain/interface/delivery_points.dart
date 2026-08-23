import 'package:paas_customer/domain/handlers/api_result.dart';
import 'package:paas_customer/infrastructure/models/data/delivery_point_data.dart';

abstract class DeliveryPointsRepositoryFacade {
  Future<ApiResult<List<DeliveryPointData>>> getDeliveryPoints({
    required double latitude,
    required double longitude,
  });

  Future<ApiResult<List<DeliveryPointData>>> getAllDeliveryPoints();
}
