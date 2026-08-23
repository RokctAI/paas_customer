import 'package:paas_customer/infrastructure/models/models.dart';
import 'package:paas_customer/domain/handlers/handlers.dart';

abstract class CurrenciesRepositoryFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
