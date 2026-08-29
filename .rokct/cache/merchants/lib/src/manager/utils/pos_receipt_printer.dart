// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
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

import 'package:flutter/foundation.dart';

/// One printed receipt line.
class PosReceiptLine {
  const PosReceiptLine({
    required this.title,
    required this.quantity,
    required this.lineTotal,
  });

  final String title;
  final double quantity;
  final double lineTotal;
}

/// The checkout's receipt-printing seam.
///
/// "Print Receipt & Finish" is ATOMIC: the checkout awaits [print] and
/// only records the finish when it returns — a throwing handler leaves the
/// sale open (the retired Spazafy checkout printed after recording, so a
/// dead printer silently ate receipts). The default handler is a debug
/// no-op; a composed app with printing hardware (58mm bluetooth thermal,
/// per the old Quick Receipt app) installs its own via [handler].
class PosReceiptPrinter {
  PosReceiptPrinter._();

  /// Composed-app seam: install the real hardware printer here (di_hook /
  /// boot_hook territory). Tests install throwing/recording fakes.
  static Future<void> Function(
    String orderId,
    List<PosReceiptLine> lines,
    double total,
  )? handler;

  static Future<void> print(
    String orderId,
    List<PosReceiptLine> lines,
    double total,
  ) async {
    final h = handler;
    if (h != null) {
      await h(orderId, lines, total);
      return;
    }
    debugPrint(
      '==> POS receipt (no printer installed): $orderId, '
      '${lines.length} lines, total $total',
    );
  }
}
