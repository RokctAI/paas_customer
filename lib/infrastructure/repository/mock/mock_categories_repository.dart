import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/categories.dart';
import 'package:foodyman/infrastructure/models/data/category_data.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/response/categories_paginate_response.dart';

class MockCategoriesRepository implements CategoriesRepositoryFacade {
  final CategoryData _demoCategory = CategoryData(
    id: 1,
    uuid: "demo_cat_1",
    keywords: "burger, fast food",
    parentId: 0,
    type: "main",
    img: "https://via.placeholder.com/150",
    active: true,
    slug: "burgers",
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
    translation: Translation(
      title: "Burgers",
      description: "Delicious burgers",
      lang: "en",
    ),
    locales: [],
    shops: [],
    children: [],
  );

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories({required int page}) async {
    return ApiResult.success(
      data: CategoriesPaginateResponse(
        data: [_demoCategory, _demoCategory.copyWith(id: 2, uuid: "demo_cat_2", translation: Translation(title: "Pizza"))],
      ),
    );
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop({required String shopId}) async {
    return ApiResult.success(
      data: CategoriesPaginateResponse(
        data: [_demoCategory, _demoCategory.copyWith(id: 2, uuid: "demo_cat_2", translation: Translation(title: "Drinks"))],
      ),
    );
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> searchCategories({required String text}) async {
    return ApiResult.success(
      data: CategoriesPaginateResponse(
        data: [_demoCategory],
      ),
    );
  }
}
