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

// compliance-ignore-file: obs-flutter-trace (no HTTP in this file: pure MD5 signature computation; flagged only because its path contains 'services')
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class SignatureService {
  /// Creates a PayFast-compatible signature for payment parameters
  ///
  /// This method strictly follows PayFast's signature generation requirements:
  /// 1. Sort all parameters alphabetically by key name
  /// 2. Concatenate all parameter key-value pairs with & between each pair
  /// 3. Append the passphrase with a leading &
  /// 4. Generate an MD5 hash of the resulting string
  static String createSignature(
    Map<String, dynamic> queryParameters,
    String passphrase,
  ) {
    // Create a copy of the parameters to avoid modifying the original
    final params = Map<String, String>.from(
      queryParameters.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      ),
    );

    // Filter out empty strings
    params.removeWhere((key, value) => value.isEmpty);

    // Sort keys alphabetically
    final sortedKeys = params.keys.toList()..sort();

    // Build parameter string
    final parameterString = sortedKeys.map((key) {
      final value = params[key]!;
      return '$key=$value';
    }).join('&');

    // Add passphrase
    final signatureString = passphrase.isNotEmpty
        ? '$parameterString&passphrase=$passphrase'
        : parameterString;

    // Generate MD5 hash
    return crypto.md5.convert(utf8.encode(signatureString)).toString();
  }
}
