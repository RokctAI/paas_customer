// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/*

import 'package:payments_sdk/src/common/utils/payfast/enums/frequency_cycle_period.dart';
import 'package:payments_sdk/src/common/utils/payfast/enums/payment_type.dart';
import 'package:payments_sdk/src/common/utils/payfast/enums/recurring_payment_types.dart';
import 'package:payments_sdk/src/common/utils/payfast/models/billing_types/recurring_billing.dart';
import 'package:payments_sdk/src/common/utils/payfast/models/billing_types/recurring_billing_types/subscription_payment.dart';
import 'package:payments_sdk/src/common/utils/payfast/models/billing_types/recurring_billing_types/tokenization_billing.dart';
import 'package:payments_sdk/src/common/utils/payfast/models/billing_types/simple_billing.dart';
import 'package:payments_sdk/src/common/utils/payfast/models/merchant_details.dart';
import 'signature_service.dart';

class Payfast {
  String passphrase;
  PaymentType paymentType;
  bool production;

  RecurringBilling? recurringBilling;
  SimpleBilling? simpleBilling;
  MerchantDetails merchantDetails;

  // Customer details
  String? emailAddress;
  String? cellNumber;
  String? nameFirst;
  String? nameLast;

  Payfast({
    required this.passphrase,
    required this.paymentType,
    required this.production,
    required this.merchantDetails,
    this.emailAddress,
    this.cellNumber,
    this.nameFirst,
    this.nameLast,
  });

  String generateURL() {
    Map<String, dynamic> queryParameters = {};

    // Simple Payment
    if (paymentType == PaymentType.simplePayment) {
      Map<String, dynamic> simpleQueryParameters = {
        ...merchantDetails.toMap(),
        'amount': simpleBilling?.amount,
        'item_name': simpleBilling?.itemName,
      };

      // Add customer details if provided
      if (emailAddress != null && emailAddress!.isNotEmpty) {
        simpleQueryParameters['email_address'] = emailAddress;
      }

      if (cellNumber != null && cellNumber!.isNotEmpty) {
        simpleQueryParameters['cell_number'] = cellNumber;
      }

      if (nameFirst != null && nameFirst!.isNotEmpty) {
        simpleQueryParameters['name_first'] = nameFirst;
      }

      if (nameLast != null && nameLast!.isNotEmpty) {
        simpleQueryParameters['name_last'] = nameLast;
      }

      queryParameters = simpleQueryParameters;
    }
    // Recurring Billing
    else if (paymentType == PaymentType.recurringBilling) {
      // Subscription
      if (recurringBilling?.recurringPaymentType == RecurringPaymentType.subscription) {
        Map<String, dynamic> recurringSubscriptionQueryParameters = {
          ...merchantDetails.toMap(),
          'amount': recurringBilling?.subscriptionPayment?.amount,
          'item_name': recurringBilling?.subscriptionPayment?.itemName,
          'subscription_type': recurringBilling?.subscriptionPayment?.subscriptionsType,
          'billing_date': recurringBilling?.subscriptionPayment?.billingDate,
          'recurring_amount': recurringBilling?.subscriptionPayment?.recurringAmount,
          'frequency': recurringBilling?.subscriptionPayment?.frequency,
          'cycles': recurringBilling?.subscriptionPayment?.cycles,
        };

        // Add customer details if provided
        if (emailAddress != null && emailAddress!.isNotEmpty) {
          recurringSubscriptionQueryParameters['email_address'] = emailAddress;
        }

        if (cellNumber != null && cellNumber!.isNotEmpty) {
          recurringSubscriptionQueryParameters['cell_number'] = cellNumber;
        }

        if (nameFirst != null && nameFirst!.isNotEmpty) {
          recurringSubscriptionQueryParameters['name_first'] = nameFirst;
        }

        if (nameLast != null && nameLast!.isNotEmpty) {
          recurringSubscriptionQueryParameters['name_last'] = nameLast;
        }

        queryParameters = recurringSubscriptionQueryParameters;
      }
      // Tokenization
      else if (recurringBilling?.recurringPaymentType == RecurringPaymentType.tokenization) {
        Map<String, dynamic> recurringTokenizationQueryParameters = {
          ...merchantDetails.toMap(),
          'amount': '250',
          'item_name': 'Netflix',
          'subscription_type': recurringBilling?.tokenizationBilling?.subscriptionType,
        };

        // Add customer details if provided
        if (emailAddress != null && emailAddress!.isNotEmpty) {
          recurringTokenizationQueryParameters['email_address'] = emailAddress;
        }

        if (cellNumber != null && cellNumber!.isNotEmpty) {
          recurringTokenizationQueryParameters['cell_number'] = cellNumber;
        }

        if (nameFirst != null && nameFirst!.isNotEmpty) {
          recurringTokenizationQueryParameters['name_first'] = nameFirst;
        }

        if (nameLast != null && nameLast!.isNotEmpty) {
          recurringTokenizationQueryParameters['name_last'] = nameLast;
        }

        queryParameters = recurringTokenizationQueryParameters;
      } else {
        throw Exception("Payment type not selected");
      }
    }

    // Calculate signature with all parameters including customer details
    String signature = SignatureService.createSignature(queryParameters, passphrase);

    return Uri.decodeComponent(
      Uri(
        scheme: 'https',
        host: '${production ? 'payfast' : 'sandbox.payfast'}.co.za',
        path: '/eng/process',
        queryParameters: {
          ...queryParameters,
          'signature': signature,
        },
      ).toString(),
    );
  }

  void createSimplePayment({
    required String amount,
    required String itemName,
  }) {
    simpleBilling = SimpleBilling(
      amount: amount,
      itemName: itemName,
    );
  }

  void setRecurringBillingType(RecurringPaymentType recurringPaymentType) {
    recurringBilling =
        RecurringBilling(recurringPaymentType: recurringPaymentType);
  }

  void setupRecurringBillingSubscription({
    required int amount,
    required String itemName,
    required String billingDate,
    required int cycles,
    required FrequencyCyclePeriod cyclePeriod,
    required int recurringAmount,
  }) {
    recurringBilling!.subscriptionPayment = SubscriptionPayment(
      amount: amount.toString(),
      itemName: itemName,
      billingDate: billingDate,
      recurringAmount: recurringAmount.toString(),
      frequency: (cyclePeriod.index + 3).toString(),
      cycles: cycles.toString(),
    );
  }

  void setupRecurringBillingTokenization([
    int? amount,
    String? itemName,
  ]) {
    recurringBilling!.tokenizationBilling = TokenizationBilling(
      amount?.toString(),
      itemName,
    );
  }

  void chargeTokenization() {
    Map<String, dynamic> recurringTokenizationQueryParameters = {
      'token': const String.fromEnvironment('PAYFAST_TOKEN'),
      'merchant-id': const String.fromEnvironment('PAYFAST_MERCHANT_ID'),
      'version': 'v1',
      'timestamp': '2022-07-25',
      'amount': '444',
      'item_name': 'Netflix',
    };

    Map<String, dynamic> signatureEntry = {
      'signature': SignatureService.createSignature(
          recurringTokenizationQueryParameters, const String.fromEnvironment('PAYFAST_PASSPHRASE')),
    };

    recurringTokenizationQueryParameters.addEntries(signatureEntry.entries);
  }
}*/
