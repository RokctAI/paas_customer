// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

class MerchantDetails {
  String merchantId;
  String merchantKey;
  String? returnUrl;
  String? cancelUrl;
  String? notifyUrl;
  String? paymentId;

  MerchantDetails({
    required this.merchantId,
    required this.merchantKey,
    this.returnUrl,
    this.cancelUrl,
    this.notifyUrl,
    this.paymentId,
  });

  Map<String, dynamic> toMap() {
    return {
      "merchant_id": merchantId,
      "merchant_key": merchantKey,
      if (returnUrl != null) "return_url": returnUrl,
      if (cancelUrl != null) "cancel_url": cancelUrl,
      if (notifyUrl != null) "notify_url": notifyUrl,
      if (paymentId != null) "m_payment_id": paymentId,
    };
  }
}
