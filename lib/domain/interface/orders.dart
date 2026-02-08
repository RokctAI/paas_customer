import 'package:flutter/material.dart';
import 'package:foodyman/infrastructure/models/data/order_active_model.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/enums.dart';

import 'package:foodyman/domain/handlers/handlers.dart';


abstract class OrdersRepositoryFacade {
  Future<ApiResult<GetCalculateModel>> getCalculate(
      {required int cartId,
      required double lat,
      required double long,
      required DeliveryTypeEnum type,
      String? coupon});

  Future<ApiResult<OrderActiveModel>> createOrder(OrderBodyData orderBody);

  Future<ApiResult> createAutoOrder({
    required String from,
    required int orderId,
    String? to,
    String? cronPattern,
    String? paymentMethod,
    String? savedCardId,
  });

  Future<ApiResult> pauseAutoOrder(int autoOrderId);

  Future<ApiResult> resumeAutoOrder(int autoOrderId);

  Future<ApiResult> deleteAutoOrder(int orderId);

  Future<ApiResult<void>> createRepeatingOrder({
    required int orderId,
    required String startDate,
    required String cronPattern,
    String? endDate,
  });

  Future<ApiResult<void>> deleteRepeatingOrder({
    required String repeatingOrderId,
  });

  Future<ApiResult<OrderPaginateResponse>> getCompletedOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getHistoryOrders(int page);

  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page);

  Future<ApiResult<OrderActiveModel>> getSingleOrder(num orderId);

  Future<ApiResult<LocalLocation>> getDriverLocation(int deliveryId);

  Future<ApiResult<void>> cancelOrder(num orderId);

  Future<ApiResult<void>> refundOrder(num orderId, String title);

  Future<ApiResult<void>> addReview(
    num orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<String>> process(
      OrderBodyData orderBody,
      String name,
      {BuildContext? context, bool forceCardPayment = false, bool enableTokenization = false}
      );

  Future<ApiResult<String>> tipProcess({
    required int orderId,
    required double tip,
  });

  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required int shopId,
  });

  Future<ApiResult<CashbackModel>> checkCashback({
    required int shopId,
    required double amount,
  });




}
