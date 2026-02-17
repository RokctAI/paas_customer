import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/cart.dart';
import 'package:foodyman/infrastructure/models/data/cart_data.dart';
import 'package:foodyman/infrastructure/models/data/cart_product_data.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/request/cart_request.dart';
import 'package:foodyman/infrastructure/models/data/cart_detail_data.dart';

class MockCartRepository implements CartRepositoryFacade {
  final CartModel _demoCart = CartModel(
    id: "demo_cart_1",
    shopId: "demo_shop_1",
    status: true,
    totalPrice: 45.0,
    userCarts: [
      CartDetail(
         uuid: "demo_user_cart_1",
         userId: 1,
         cartDetails: [
            CartProductData(
                quantity: 2,
                price: 15.0,
                discount: 0,
                stocks: ProductData(
                    id: "demo_product_1",
                    price: 15.0,
                    translation: Translation(title: "Demo Burger"),
                    img: "https://via.placeholder.com/150",
                    tax: 1.5
                )
            ),
             CartProductData(
                quantity: 1,
                price: 15.0,
                discount: 0,
                stocks: ProductData(
                    id: "demo_product_2",
                    price: 15.0,
                    translation: Translation(title: "Cheese Burger"),
                     img: "https://via.placeholder.com/150",
                     tax: 1.5
                )
            )
         ],
         status: true,
         name: "Demo User"
      )
    ],
  );

  @override
  Future<ApiResult<dynamic>> changeStatus({required String? userUuid, required String? cartId}) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<CartModel>> createAndCart({required CartRequest cart}) async {
     return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> createCart({required CartRequest cart}) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> deleteCart({required String cartId}) async {
     return ApiResult.success(data: _demoCart.copyWith(userCarts: []));
  }

  @override
  Future<ApiResult<dynamic>> deleteUser({required String cartId, required String userId}) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<CartModel>> getCart(String shopId) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> getCartInGroup(String? cartId, String? shopId, String? cartUuid) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> insertCart({required CartRequest cart}) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> insertCartWithGroup({required CartRequest cart}) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<CartModel>> removeProductCart({required String cartDetailId, List<String> listOfId}) async {
    return ApiResult.success(data: _demoCart);
  }

  @override
  Future<ApiResult<dynamic>> startGroupOrder({required String cartId}) async {
    return ApiResult.success(data: null);
  }
}
