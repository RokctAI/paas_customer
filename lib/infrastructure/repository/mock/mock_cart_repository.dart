import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/cart.dart';
import 'package:foodyman/infrastructure/models/data/cart_data.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/models/request/cart_request.dart';

class MockCartRepository implements CartRepositoryFacade {
  final UserCart _demoUserCart = UserCart(
    id: "1",
    cartId: "1",
    userId: "1",
    status: true,
    name: "Demo Cart",
    uuid: "demo_cart_uuid",
    cartDetails: [
      CartDetail(
        id: "101",
        quantity: 2,
        price: 150,
        bonus: false,
        stock: Stocks(
            id: 1,
            price: 150,
        ),
      )
    ],
  );


  @override
  Future<ApiResult<CartModel>> calculateCart({required int cartId}) async {
      return ApiResult.success(
      data: CartModel(
        data: Cart(
             id: "1",
             totalPrice: 300,
             userCarts: [_demoUserCart]
        )
      ),
    );
     // Note: Real implementation might return a CartCalculateResponse or similar, 
     // but the interface return type is CartModel.
  }

  @override
  Future<ApiResult<CartModel>> deleteCart({required int cartId}) async {
      return ApiResult.success(
      data: CartModel(
        data: Cart(id: "1", userCarts: [])
      ),
    );
  }

  @override
  Future<ApiResult<CartModel>> deleteCartItem({required int cartId, required int cartDetailId}) async {
       return ApiResult.success(
      data: CartModel(
        data: Cart(id: "1", userCarts: [_demoUserCart.copyWith(cartDetails: [])])
      ),
    );
  }

  @override
  Future<ApiResult<CartModel>> getCart({required int cartId}) async {
    return ApiResult.success(
      data: CartModel(
        data: Cart(
            id: "1",
            totalPrice: 300,
            userCarts: [_demoUserCart]
        )
      ),
    );
  }

  @override
  Future<ApiResult<CartModel>> insertCart({required CartRequest cart}) async {
      return ApiResult.success(
      data: CartModel(
        data: Cart(
            id: "1",
            totalPrice: 150,
            userCarts: [_demoUserCart] // Simplified for mock
        )
      ),
    );
  }

  @override
  Future<ApiResult<CartModel>> openCart({required int cartId}) async {
      return getCart(cartId: cartId);
  }
}
