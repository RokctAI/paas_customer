import 'package:auth_sdk/src/presentation/pages/auth/phone_verify.dart';
import 'package:auth_sdk/src/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:comms_sdk/src/presentation/pages/chat/chat/chat_page.dart';
import 'package:comms_sdk/src/presentation/pages/setting/language_page.dart';
import 'package:corporate_sdk/src/presentation/pages/policy_term/policy_page.dart';
import 'package:corporate_sdk/src/presentation/pages/policy_term/term_page.dart';
import 'package:delivery_sdk/src/presentation/pages/become_driver/become_driver.dart';
import 'package:merchants_sdk/src/presentation/pages/shop/cart/widgets/cart_clear_dialog.dart';
import 'package:merchants_sdk/src/presentation/pages/shop/cart/widgets/cart_order_item.dart';
import 'package:merchants_sdk/src/presentation/pages/shop/widgets/bonus_screen.dart';
import 'package:onboarding_sdk/src/presentation/pages/intro/intro_page.dart';
import 'package:orders_sdk/src/presentation/pages/order/order_type/widgets/order_map.dart';
import 'package:payments_sdk/src/presentation/pages/cards/payment_card.dart';
import 'package:payments_sdk/src/presentation/pages/cards/payment_screen.dart';
import 'package:payments_sdk/src/utils/payfast/payfast_webview.dart';
import 'package:polaris_sdk/src/presentation/pages/loans/loan_screen.dart';
import 'package:products_sdk/src/presentation/pages/product/product_page.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:base_sdk/src/models/data/bonus_data.dart';
import 'package:base_sdk/src/models/data/cart_data.dart';
import 'package:base_sdk/src/models/data/order_active_model.dart';
import 'package:base_sdk/src/models/data/order_body_data.dart';
import 'package:base_sdk/src/models/data/product_data.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:base_sdk/src/navigation/embedded_widgets.dart';
import 'package:flutter/widgets.dart';

/// Host-side implementation of [EmbeddedWidgets] over the installed SDKs.
class EmbeddedWidgetsImpl implements EmbeddedWidgets {
  @override
  Widget becomeDriverPage() => BecomeDriverPage();
  @override
  Widget bonusScreen({required BonusModel? bonus}) => BonusScreen(bonus: bonus);
  @override
  Widget cartClearDialog({required VoidCallback cancel, required VoidCallback clear, bool? isLoading}) => CartClearDialog(cancel: cancel, clear: clear, isLoading: isLoading ?? false);
  @override
  Widget cartOrderItem({required VoidCallback add, required VoidCallback remove, required CartDetail? cart, bool? isActive, Detail? cartTwo, bool? isOwn, String? symbol, bool? isAddComment}) => CartOrderItem(add: add, remove: remove, cart: cart, isActive: isActive ?? true, cartTwo: cartTwo, isOwn: isOwn ?? true, symbol: symbol, isAddComment: isAddComment ?? false);
  @override
  Widget chatPage({required String roleId, required String name}) => ChatPage(roleId: roleId, name: name);
  @override
  Widget introPage() => IntroPage();
  @override
  Widget languageScreen({required VoidCallback onSave}) => LanguageScreen(onSave: onSave);
  @override
  Widget loanScreen() => LoanScreen();
  @override
  Widget orderMap({required dynamic markers, required dynamic latLng, required dynamic polylineCoordinates, required bool isLoading}) => OrderMap(markers: markers, latLng: latLng, polylineCoordinates: polylineCoordinates, isLoading: isLoading);
  @override
  Widget payFastWebView({required String url, Function(bool)? onComplete, Function(String, Map<String, String>)? onTokenCaptured, dynamic preloadedController}) => PayFastWebView(url: url, onComplete: onComplete, onTokenCaptured: onTokenCaptured, preloadedController: preloadedController);
  @override
  Widget paymentScreen({OrderBodyData? orderData, required Function(bool) onPaymentComplete, ScrollController? scrollController, bool? tokenizeOnly}) => PaymentScreen(orderData: orderData, onPaymentComplete: onPaymentComplete, scrollController: scrollController, tokenizeOnly: tokenizeOnly ?? false);
  @override
  Widget phoneVerify() => PhoneVerify();
  @override
  Widget policyPage() => PolicyPage();
  @override
  Widget productScreen({String? productId, ProductData? data, String? cartId, required ScrollController controller}) => ProductScreen(productId: productId, data: data, cartId: cartId, controller: controller);
  @override
  Widget resetPasswordPage() => ResetPasswordPage();
  @override
  Widget savedCardsWidget({required Function(SavedCardModel?) onCardSelected, SavedCardModel? initialSelectedCard, bool? hideManagement}) => SavedCardsWidget(onCardSelected: onCardSelected, initialSelectedCard: initialSelectedCard, hideManagement: hideManagement ?? false);
  @override
  Widget termPage() => TermPage();
  @override
  void preloadPayFastWebView(BuildContext context, String paymentUrl) =>
      PayFastWebViewPreloader.preloadPayFastWebView(context, paymentUrl);
}
