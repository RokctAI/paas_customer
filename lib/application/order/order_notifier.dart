import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/infrastructure/models/data/addons_data.dart';
import 'package:foodyman/infrastructure/models/data/order_active_model.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/cart_request.dart';
import 'package:intl/intl.dart';
import '../../presentation/app_assets.dart';
import 'order_state.dart';

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() => const OrderState();
  final ImageCropperForMarker imageCropper = ImageCropperForMarker();

  void setAddressInfo({
    String? office,
    String? house,
    String? floor,
    String? note,
  }) {
    state = state.copyWith(
      office: office ?? state.office,
      house: house ?? state.house,
      floor: floor ?? state.floor,
      note: note ?? state.note,
    );
  }

  void setUser({String? username, String? phone}) {
    state = state.copyWith(
      username: username ?? state.office,
      phoneNumber: phone ?? state.house,
    );
  }

  Future<void> fetchDriver(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (state.orderData?.deliveryMan?.id == null) {
        return;
      }
      final response = await ordersRepository.getDriverLocation(
        state.orderData?.deliveryMan?.id ?? 0,
      );
      response.when(
        success: (data) async {
          Map<MarkerId, Marker> list = Map.from(state.markers);
          list.addAll({
            const MarkerId("Driver"): Marker(
              markerId: const MarkerId("Driver"),
              position: LatLng(
                data.latitude ?? AppConstants.demoLatitude,
                data.longitude ?? AppConstants.demoLongitude,
              ),
              icon: await imageCropper.resizeAndCircle(
                state.orderData?.deliveryMan?.img ?? "",
                120,
              ),
            ),
          });
          state = state.copyWith(markers: list);
        },
        failure: (failure, status) {
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void checkBox(bool value) {
    state = state.copyWith(sendOtherUser: value);
  }

  void changeActive(bool isChange) {
    state = state.copyWith(isActive: isChange);
  }

  void setPromoCode(String? promoCode) {
    state = state.copyWith(promoCode: promoCode);
  }

  void resetState() {
    state = state.copyWith(
      orderData: null,
      selectDate: null,
      isButtonLoading: false,
    );
  }

  void changeTabIndex(int index) {
    state = state.copyWith(tabIndex: index);
  }

  void setTimeAndDay(TimeOfDay timeOfDay, DateTime day) {
    state = state.copyWith(selectTime: timeOfDay, selectDate: day);
  }

  void checkWorkingDay() {
    if (!(state.shopData?.open ?? false)) return;
    List<String> todayTimes = getTimes(-1);
    List<List<String>> dailyTimes = [];
    for (int i = 0; i < 6; i++) {
      dailyTimes.add(getTimes(i));
    }

    state = state.copyWith(dailyTimes: dailyTimes, todayTimes: todayTimes);
  }

  List<String> getTimes(int i) {
    debugPrint("getTimes $i");
    final days = state.shopData?.shopWorkingDays;
    List<ShopClosedDate> closedDays = state.shopData?.shopClosedDate ?? [];
    DateTime now = DateTime.now().add(Duration(days: i + 1));
    if (closedDays.any(
      (e) => e.day?.withoutTime.compareTo(now.withoutTime) == 0,
    )) {
      return [];
    }
    List<String> times = [];
    final yesterday = DateFormat(
      "EEEE",
    ).format(now.subtract(const Duration(days: 1))).toLowerCase();
    final today = DateFormat("EEEE").format(now).toLowerCase();
    TimeOfDay deliveryTime = TimeOfDay(
      hour: state.shopData?.deliveryTime?.type == 'hour'
          ? (int.tryParse(state.shopData?.deliveryTime?.to ?? '') ?? 0)
          : 0,
      minute: state.shopData?.deliveryTime?.type == 'minute'
          ? (int.tryParse(state.shopData?.deliveryTime?.to ?? '') ?? 0)
          : 0,
    );
    debugPrint("today $today");
    debugPrint("yesterday $yesterday");
    debugPrint("deliveryTime $deliveryTime");
    days?.forEach((element) {
      if (element.disabled ?? false) return;
      if (element.day?.toLowerCase() == yesterday) {
        if (AppHelpers.checkYesterday(element.from, element.to) &&
            yesterday != 'sunday') {
          TimeOfDay time = i == -1
              ? TimeOfDay.now()
              : const TimeOfDay(hour: 0, minute: 0);
          TimeOfDay time2 = time.plusMinutes(
            minute: deliveryTime.hour * 60 + deliveryTime.minute,
          );
          for (int i = time.hour; i < element.to.toTimeOfDay.hour; i++) {
            times.add(
              "${time.hour}:${time.minute} - ${time2.hour}:${time2.minute}",
            );
            time = time.plusMinutes(minute: AppConstants.scheduleInterval);
            time2 = time2.plusMinutes(minute: AppConstants.scheduleInterval);
          }
        }
      }
      if (element.day?.toLowerCase() == today) {
        if (today == "monday") {
          if (AppHelpers.checkYesterday(element.from, element.to)) {
            TimeOfDay time = i == -1
                ? TimeOfDay.now()
                : const TimeOfDay(hour: 0, minute: 0);
            TimeOfDay time2 = time.plusMinutes(
              minute: deliveryTime.hour * 60 + deliveryTime.minute,
            );
            for (num i = time.hour; i < element.to.toTimeOfDay.hour; i) {
              times.add(
                "${time.hour}:${time.minute} - ${time2.hour}:${time2.minute}",
              );
              time = time.plusMinutes(minute: AppConstants.scheduleInterval);
              time2 = time2.plusMinutes(minute: AppConstants.scheduleInterval);
              i += AppConstants.scheduleInterval / 60;
            }
          }
        }
        if (AppHelpers.checkYesterday(element.from, element.to)) {
          TimeOfDay time = i == -1
              ? TimeOfDay.now().hour > element.from.toTimeOfDay.hour &&
                        TimeOfDay.now().minute > element.from.toTimeOfDay.minute
                    ? TimeOfDay.now()
                    : element.from.toTimeOfDay
              : element.from.toTimeOfDay;
          TimeOfDay time2 = time.plusMinutes(
            minute: deliveryTime.hour * 60 + deliveryTime.minute,
          );
          for (num i = time.hour; i < 24; i) {
            times.add(
              "${time.hour}:${time.minute} - ${time2.hour}:${time2.minute}",
            );
            time = time.plusMinutes(minute: AppConstants.scheduleInterval);
            time2 = time2.plusMinutes(minute: AppConstants.scheduleInterval);
            i += AppConstants.scheduleInterval / 60;
          }
        } else {
          TimeOfDay time = i == -1
              ? TimeOfDay.now().hour > element.from.toTimeOfDay.hour &&
                        TimeOfDay.now().minute > element.from.toTimeOfDay.minute
                    ? TimeOfDay.now()
                    : element.from.toTimeOfDay
              : element.from.toTimeOfDay;
          TimeOfDay time2 = time.plusMinutes(
            minute: deliveryTime.hour * 60 + deliveryTime.minute,
          );
          for (num i = time.hour; i < element.to.toTimeOfDay.hour; i) {
            times.add(
              "${time.hour}:${time.minute} - ${time2.hour}:${time2.minute}",
            );
            time = time.plusMinutes(minute: AppConstants.scheduleInterval);
            time2 = time2.plusMinutes(minute: AppConstants.scheduleInterval);
            if (time2.hour == element.to.toTimeOfDay.hour &&
                time2.minute >= element.to.toTimeOfDay.minute) {
              break;
            }
            i += AppConstants.scheduleInterval / 60;
          }
        }
      }
    });
    if (state.selectDate == null && times.isNotEmpty) {
      state = state.copyWith(
        selectTime: times.first.toNextTime,
        selectDate: now,
      );
    }
    return times;
  }

  void changeBranch(int index) {
    state = state.copyWith(branchIndex: index);
  }

  Future<void> fetchShop(BuildContext context, String uuid) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await shopsRepository.getSingleShop(uuid: uuid);
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, shopData: data.data);
          checkWorkingDay();
          Set<Marker> list = {};
          list.add(
            Marker(
              markerId: const MarkerId("Shop"),
              position: LatLng(
                data.data?.location?.latitude ?? AppConstants.demoLatitude,
                data.data?.location?.longitude ?? AppConstants.demoLongitude,
              ),
              icon: await imageCropper.resizeAndCircle(data.data?.logoImg ?? "", 120),
            ),
          );
          state = state.copyWith(shopMarkers: list);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchShopBranch(BuildContext context, int shopId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await shopsRepository.getShopBranch(uuid: shopId);
      response.when(
        success: (data) async {
          state = state.copyWith(branches: data.data);
        },
        failure: (failure, status) {},
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> getCalculate({
    required BuildContext context,
    required int cartId,
    required double long,
    required double lat,
    required DeliveryTypeEnum type,
    bool isLoading = true,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isLoading) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(isButtonLoading: true);
      }
      final response = await ordersRepository.getCalculate(
        cartId: cartId,
        lat: lat,
        long: long,
        type: type,
        coupon: state.promoCode,
      );
      response.when(
        success: (data) async {
          if (isLoading) {
            state = state.copyWith(isLoading: false, calculateData: data);
          } else {
            state = state.copyWith(isButtonLoading: false, calculateData: data);
          }
        },
        failure: (failure, status) {
          if (isLoading) {
            state = state.copyWith(isLoading: false);
          } else {
            state = state.copyWith(isButtonLoading: false);
          }
          AppHelpers.showCheckTopSnackBar(context, failure);
          if (status == 401) {
            context.router.popUntilRoot();
            context.replaceRoute(const LoginRoute());
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void setNotes({required int stockId, required String note}) {
    if (stockId <= 0 || note.trim().isEmpty) {
      return;
    }

    List<ProductNote> list = List.from(state.notes);
    bool isAdd = true;
    int existingIndex = -1;

    for (int i = 0; i < list.length; i++) {
      if (list[i].stockId == stockId) {
        existingIndex = i;
        isAdd = false;
        break;
      }
    }

    if (isAdd) {
      list.add(ProductNote(stockId: stockId, comment: note.trim()));
    } else {
      list[existingIndex] = ProductNote(stockId: stockId, comment: note.trim());
    }

    state = state.copyWith(notes: list);
  }

  Future<void> sendTips({
    required BuildContext context,
    required num? price,
    required PaymentData payment,
    VoidCallback? onSuccess,
    ValueChanged<String>? onWebview,
  }) async {
    final num wallet = LocalStorage.getWalletData()?.price ?? 0;
    if (payment.tag == "wallet" && wallet < (price ?? 0)) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.notEnoughMoney),
      );
      state = state.copyWith(isButtonLoading: false);
      return;
    }
    if (payment.tag?.toLowerCase() != "cash") {
      final res = await ordersRepository.tipProcess(
        state.orderData?.id,
        payment.tag ?? '',
        payment.id,
        price,
      );
      res.when(
        success: (key) {
          onSuccess?.call();
          if (payment.tag?.toLowerCase() != 'wallet') {
            onWebview?.call(key);
          }
        },
        failure: (e, s) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, e);
          }
        },
      );
    }
  }

  Future createOrder({
    required BuildContext context,
    required OrderBodyData data,
    required PaymentData payment,
    VoidCallback? onSuccess,
    Function(String, bool)? onWebview,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      if (data.deliveryType == DeliveryTypeEnum.delivery) {
        final res = await shopsRepository.checkDriverZone(
          LatLng(data.location.latitude ?? 0, data.location.longitude ?? 0),
          shopId: data.shopId,
        );
        res.when(
          success: (s) async {
            final num wallet = LocalStorage.getWalletData()?.price ?? 0;
            if (payment.tag == "wallet" &&
                wallet < (state.calculateData?.totalPrice ?? 0)) {
              AppHelpers.showCheckTopSnackBarInfo(
                context,
                AppHelpers.getTranslation(TrKeys.notEnoughMoney),
              );
              state = state.copyWith(isButtonLoading: false);
              return;
            }
            if (payment.tag != "cash" && payment.tag != "wallet") {
              final res = await ordersRepository.process(
                data,
                payment.tag ?? '',
              );
              res.when(
                success: (key) {
                  onWebview?.call(key, payment.tag == 'pay-fast');
                },
                failure: (e, s) {
                  state = state.copyWith(isButtonLoading: false);
                  if (context.mounted) {
                    AppHelpers.showCheckTopSnackBar(context, e);
                  }
                },
              );
              return;
            }
            final response = await ordersRepository.createOrder(data);
            response.when(
              success: (data) async {
                state = state.copyWith(
                  orderData: data,
                  isButtonLoading: false,
                  isMapLoading: true,
                );
                final LatLng shopLatLng = LatLng(
                  data.shop?.location?.latitude ?? AppConstants.demoLatitude,
                  data.shop?.location?.longitude ?? AppConstants.demoLongitude,
                );
                final LatLng userLatLng = LatLng(
                  data.location?.latitude ?? AppConstants.demoLatitude,
                  data.location?.longitude ?? AppConstants.demoLongitude,
                );
                Map<MarkerId, Marker> list = {
                  const MarkerId("Shop"): Marker(
                    markerId: const MarkerId("Shop"),
                    position: shopLatLng,
                    icon: await getResizedMarker(Assets.imagesMarker, 90),
                  ),
                  const MarkerId("User"): Marker(
                    markerId: const MarkerId("User"),
                    position: userLatLng,
                    icon: await getResizedMarker(Assets.userMarker, 100),
                  ),
                };
                state = state.copyWith(markers: list, isMapLoading: false);
                if (context.mounted) {
                  getRoutingAll(
                    context: context,
                    start: shopLatLng,
                    end: userLatLng,
                  );
                }
              },
              failure: (failure, status) {
                state = state.copyWith(isButtonLoading: false);
                if (context.mounted) {
                  AppHelpers.showCheckTopSnackBar(context, failure);
                }
              },
            );
          },
          failure: (failure, e) {
            state = state.copyWith(isButtonLoading: false);
            if (context.mounted) {
              AppHelpers.showCheckTopSnackBar(context, failure);
            }
          },
        );
        return;
      }

      final num wallet = LocalStorage.getWalletData()?.price ?? 0;
      if (payment.tag == "wallet" &&
          wallet < (state.calculateData?.totalPrice ?? 0)) {
        if (context.mounted) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            AppHelpers.getTranslation(TrKeys.notEnoughMoney),
          );
        }
        state = state.copyWith(isButtonLoading: false);
        return;
      }
      if (payment.tag != "cash" && payment.tag != "wallet") {
        final res = await ordersRepository.process(
          data,
          payment.tag ?? "stripe",
        );
        res.when(
          success: (key) {
            onWebview?.call(key, payment.tag == 'pay-fast');
          },
          failure: (e, s) {
            state = state.copyWith(isButtonLoading: false);
            if (context.mounted) {
              AppHelpers.showCheckTopSnackBar(context, e);
            }
          },
        );
        return;
      }

      ///eref@fsdf.ff
      ///4242424242424242
      ///04/44
      final response = await ordersRepository.createOrder(data);
      response.when(
        success: (data) async {
          state = state.copyWith(
            orderData: data,
            isButtonLoading: false,
            isMapLoading: true,
          );
          final LatLng shopLatLng = LatLng(
            data.shop?.location?.latitude ?? AppConstants.demoLatitude,
            data.shop?.location?.longitude ?? AppConstants.demoLongitude,
          );
          final LatLng userLatLng = LatLng(
            data.location?.latitude ?? AppConstants.demoLatitude,
            data.location?.longitude ?? AppConstants.demoLongitude,
          );
          Map<MarkerId, Marker> list = {
            const MarkerId("Shop"): Marker(
              markerId: const MarkerId("Shop"),
              position: shopLatLng,
              icon: await getResizedMarker(Assets.imagesMarker, 90),
            ),
            const MarkerId("User"): Marker(
              markerId: const MarkerId("User"),
              position: userLatLng,
              icon: await getResizedMarker(Assets.userMarker, 100),
            ),
          };
          state = state.copyWith(markers: list, isMapLoading: false);
          if (context.mounted) {
            getRoutingAll(context: context, start: shopLatLng, end: userLatLng);
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void repeatOrder({
    required BuildContext context,
    required int shopId,
    required VoidCallback onSuccess,
    List<OrderProduct>? listOfProduct,
  }) async {
    state = state.copyWith(isCheckShopOrder: false);
    if (shopId == 0) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        state = state.copyWith(isAddLoading: true);
        List<CartRequest> list = [];
        listOfProduct?.forEach((element) {
          for (Addons addon in element.addons ?? []) {
            list.add(
              CartRequest(
                stockId: addon.stocks?.id,
                quantity: addon.quantity,
                parentId: element.stock?.id ?? 0,
              ),
            );
          }
          list.add(
            CartRequest(
              stockId: element.stock?.id ?? 0,
              quantity: element.quantity ?? 0,
            ),
          );
        });
        final response = await cartRepository.insertCart(
          cart: CartRequest(
            shopId: state.orderData?.shop?.id ?? 0,
            carts: list,
          ),
        );
        response.when(
          success: (data) {
            state = state.copyWith(isAddLoading: false);
            onSuccess();
          },
          failure: (failure, status) {
            state = state.copyWith(isAddLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      } else {
        if (context.mounted) {
          AppHelpers.showNoConnectionSnackBar(context);
        }
      }
    } else {
      state = state.copyWith(isCheckShopOrder: true);
    }
  }

  Future<BitmapDescriptor> getResizedMarker(String assetPath, int width) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> showOrder(
    BuildContext context,
    num orderId,
    bool isRefresh,
  ) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (!isRefresh) {
        state = state.copyWith(isLoading: true, isMapLoading: true);
      }
      final response = await ordersRepository.getSingleOrder(orderId);
      response.when(
        success: (data) async {
          if (!isRefresh) {
            state = state.copyWith(orderData: data, isLoading: false);
            final LatLng shopLatLng = LatLng(
              data.shop?.location?.latitude ?? AppConstants.demoLatitude,
              data.shop?.location?.longitude ?? AppConstants.demoLongitude,
            );
            final LatLng userLatLng = LatLng(
              data.location?.latitude ?? AppConstants.demoLatitude,
              data.location?.longitude ?? AppConstants.demoLongitude,
            );
            Map<MarkerId, Marker> list = Map.from(state.markers);
            list.addAll({
              const MarkerId("Shop"): Marker(
                markerId: const MarkerId("Shop"),
                position: shopLatLng,
                icon: await getResizedMarker(Assets.imagesMarker, 90),
              ),
              const MarkerId("User"): Marker(
                markerId: const MarkerId("User"),
                position: userLatLng,
                icon: await getResizedMarker(Assets.userMarker, 100),
              ),
            });

            state = state.copyWith(markers: list, isMapLoading: false);
            if (context.mounted) {
              fetchDriver(context);
              getRoutingAll(
                context: context,
                start: shopLatLng,
                end: userLatLng,
              );
            }
          } else {
            state = state.copyWith(orderData: data);
            Map<MarkerId, Marker> list = Map.from(state.markers);
            list.addAll({
              const MarkerId("Shop"): Marker(
                markerId: const MarkerId("Shop"),
                position: LatLng(
                  data.shop?.location?.latitude ?? AppConstants.demoLatitude,
                  data.shop?.location?.longitude ?? AppConstants.demoLongitude,
                ),
                icon: await getResizedMarker(Assets.imagesMarker, 90),
              ),
              const MarkerId("User"): Marker(
                markerId: const MarkerId("User"),
                position: LatLng(
                  data.location?.latitude ?? AppConstants.demoLatitude,
                  data.location?.longitude ?? AppConstants.demoLongitude,
                ),
                icon: await getResizedMarker(Assets.userMarker, 100),
              ),
            });
            state = state.copyWith(markers: list);
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            state = state.copyWith(isLoading: false);
          }
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> cancelOrder(
    BuildContext context,
    num orderId,
    VoidCallback onSuccess,
  ) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await ordersRepository.cancelOrder(orderId);
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          onSuccess.call();
          context.maybePop(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> refundOrder(BuildContext context, String title) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await ordersRepository.refundOrder(
        state.orderData?.id ?? 0,
        title,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          AppHelpers.showCheckTopSnackBarDone(
            context,
            AppHelpers.getTranslation(TrKeys.successfully),
          );
          context.maybePop(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> addReview(
    BuildContext context,
    String comment,
    double rating,
  ) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await ordersRepository.addReview(
        state.orderData?.id ?? 0,
        rating: rating,
        comment: comment,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          context.maybePop(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
  }) async {
    if (await AppConnectivity.connectivity()) {
      state = state.copyWith(polylineCoordinates: []);
      final response = await drawRepository.getRouting(start: start, end: end);
      response.when(
        success: (data) {
          List<LatLng> list = [];
          List ls = data.features[0].geometry.coordinates;
          for (int i = 0; i < ls.length; i++) {
            list.add(LatLng(ls[i][1], ls[i][0]));
          }
          state = state.copyWith(polylineCoordinates: list);
        },
        failure: (failure, status) {
          state = state.copyWith(polylineCoordinates: []);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> driverLocationUpdatedEvent(double lat, double lng) async {
    Set<Marker> markers = Set.from(state.shopMarkers);
    markers.removeWhere((e) => e.markerId.value == 'Deliveryman');
    markers.add(
      Marker(
        markerId: MarkerId('Deliveryman'),
        position: LatLng(lat, lng),
        icon: await imageCropper.resizeAndCircle(
          state.orderData?.deliveryMan?.img ?? "",
          120,
        ),
      ),
    );
    debugPrint('driverLocationUpdatedEvent: $lat, $lng');
    state = state.copyWith(shopMarkers: markers);
  }

  void orderUpdatedEvent(OrderActiveModel data) {
    state = state.copyWith(
      orderData: state.orderData?.copyWith(
        orderStatusesData: data.orderStatusesData,
        status: data.status,
      ),
    );
  }
}
