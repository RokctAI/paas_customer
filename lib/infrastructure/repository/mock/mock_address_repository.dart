import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/address.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_information.dart';
import 'package:foodyman/infrastructure/models/data/local_address_data.dart';
import 'package:foodyman/infrastructure/models/response/addresses_response.dart';
import 'package:foodyman/infrastructure/models/response/single_address_response.dart';

class MockAddressRepository implements AddressRepositoryFacade {
  final AddressNewModel _demoAddress = AddressNewModel(
    id: "1",
    title: "Home",
    address: AddressInformation(
      address: "123 Demo St",
      house: "123",
      floor: "1",
    ),
    active: true,
    location: [37.7749, -122.4194],
  );

  @override
  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  ) async {
    return ApiResult.success(
      data: SingleAddressResponse(
        data: _demoAddress.copyWith(
          title: address.title,
          address: AddressInformation(address: address.address),
          location: address.location != null
              ? [
                  address.location!.latitude ?? 0.0,
                  address.location!.longitude ?? 0.0,
                ]
              : null,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<void>> deleteAddress(int addressId) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<AddressesResponse>> getUserAddresses() async {
    return ApiResult.success(
      data: AddressesResponse(
        data: [
          _demoAddress,
          _demoAddress.copyWith(
            id: "2",
            title: "Work",
            address: AddressInformation(address: "456 Office Blvd"),
          ),
        ],
      ),
    );
  }
}
