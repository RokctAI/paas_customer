import 'package:paas_customer/infrastructure/models/models.dart';
import 'package:paas_customer/domain/handlers/handlers.dart';

abstract class BlogsRepositoryFacade {
  Future<ApiResult<BlogsPaginateResponse>> getBlogs(int page, String type);

  Future<ApiResult<BlogDetailsResponse>> getBlogDetails(String uuid);
}
