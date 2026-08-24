import 'package:payments_sdk/src/utils/payfast/enums/recurring_payment_types.dart';
import 'package:payments_sdk/src/utils/payfast/models/billing_types/recurring_billing_types/subscription_payment.dart';
import 'package:payments_sdk/src/utils/payfast/models/billing_types/recurring_billing_types/tokenization_billing.dart';

class RecurringBilling {
  SubscriptionPayment? subscriptionPayment;
  TokenizationBilling? tokenizationBilling;

  RecurringPaymentType recurringPaymentType;

  RecurringBilling({required this.recurringPaymentType});
}
