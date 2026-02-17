import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/auth.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_information.dart';

class MockAuthRepository implements AuthRepositoryFacade {

  final UserModel _demoUser = UserModel(
    id: "1",
    uuid: "demo_uuid",
    firstname: "Demo",
    lastname: "User",
    email: "demo@example.com",
    phone: "+1234567890",
    role: "customer",
    active: true,
    img: "https://via.placeholder.com/150",
    addresses: [
        AddressNewModel(
            active: true,
            address: AddressInformation(address: "123 Demo St"),
            id: "1",
            location: [37.7749, -122.4194],
            title: "Home"
        )
    ]
  );


  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirm({required String verifyCode, required String email}) async {
    return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: _demoUser,
      ),
    );
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({required String phone}) async {
    return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: _demoUser.copyWith(phone: phone),
      ),
    );
  }

  @override
  Future<ApiResult<RegisterResponse>> forgotPassword({required String email}) async {
      return ApiResult.success(
      data: RegisterResponse(
        verifyId: "demo_verify_id",
        phone: "1234567890",
      ),
    );
  }

  @override
  Future<ApiResult<LoginResponse>> login({required String email, required String password}) async {
    return ApiResult.success(
      data: LoginResponse(
        data: LoginData(
          accessToken: "demo_access_token",
          tokenType: "Bearer",
          user: _demoUser.copyWith(email: email),
        ),
      ),
    );
  }

  @override
  Future<ApiResult<LoginResponse>> loginWithGoogle({required String email, required String displayName, required String id, required String avatar}) async {
     return ApiResult.success(
      data: LoginResponse(
        data: LoginData(
          accessToken: "demo_google_token",
          tokenType: "Bearer",
          user: _demoUser.copyWith(email: email, firstname: displayName, img: avatar),
        ),
      ),
    );
  }

  @override
  Future<ApiResult<RegisterResponse>> sendOtp({required String phone}) async {
     return ApiResult.success(
      data: RegisterResponse(
        verifyId: "demo_verify_id",
        phone: phone,
      ),
    );
  }

  @override
  Future<ApiResult> sigUp({required String email}) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithData({required UserModel user}) async {
      return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: user,
      ),
    );
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithPhone({required UserModel user}) async {
      return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: user,
      ),
    );
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({required String verifyCode}) async {
      return ApiResult.success(
      data: VerifyPhoneResponse(
        token: "demo_token",
        user: _demoUser,
      ),
    );
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({required String verifyCode, required String verifyId}) async {
      return ApiResult.success(
      data: VerifyPhoneResponse(
        token: "demo_token",
        user: _demoUser,
      ),
    );
  }
}
