import 'package:paas_customer/infrastructure/models/models.dart';
import 'package:paas_customer/infrastructure/services/enums.dart';
import 'package:paas_customer/domain/handlers/handlers.dart';

abstract class GalleryRepositoryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String file,
    UploadType uploadType,
  );

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );
}
