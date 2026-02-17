import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/auth.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/response/login_response.dart';
import 'package:foodyman/infrastructure/models/response/register_response.dart';
import 'package:foodyman/infrastructure/models/response/verify_phone_response.dart';
import 'package:foodyman/infrastructure/models/data/user_data.dart';

class MockAuthRepository implements AuthRepositoryFacade {
  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirm({required String verifyCode, required String email}) async {
    return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: UserModel(email: email, firstname: "Demo", lastname: "User"),
      ),
    );
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({required String phone}) async {
    return ApiResult.success(
      data: VerifyData(
        token: "demo_token",
        user: UserModel(phone: phone, firstname: "Demo", lastname: "User"),
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
          user: UserModel(
            id: 1,
            uuid: "demo_uuid",
            firstname: "Demo",
            lastname: "User",
            email: email,
            phone: "+1234567890",
            role: "customer",
            active: 1,
            img: "https://via.placeholder.com/150",
            addresses: [
                AddressModel(
                    active: true,
                    address: "123 Demo St",
                    id: 1,
                    location: [LocationModel(latitude: 37.7749, longitude: -122.4194)],
                    title: "Home"
                )
            ]
          ),
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
          user: UserModel(
            id: 1,
            uuid: "demo_uuid",
            firstname: displayName,
            lastname: "",
            email: email,
            img: avatar,
            role: "customer",
             addresses: [
                AddressModel(
                    active: true,
                    address: "123 Demo St",
                    id: 1,
                    location: [LocationModel(latitude: 37.7749, longitude: -122.4194)],
                    title: "Home"
                )
            ]
          ),
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
        user: UserModel(id: 1, firstname: "Demo"),
      ),
    );
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({required String verifyCode, required String verifyId}) async {
      return ApiResult.success(
      data: VerifyPhoneResponse(
        token: "demo_token",
        user: UserModel(id: 1, firstname: "Demo"),
      ),
    );
  }
}
