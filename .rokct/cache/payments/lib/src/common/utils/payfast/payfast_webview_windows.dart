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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';

import 'payfast_completion.dart';

/// Windows variant of the PayFast payment WebView.
///
/// `webview_flutter` has no Windows implementation, so this widget uses
/// `flutter_inappwebview` (WebView2-based on Windows) with the same public
/// surface and the same redirect-interception / token-capture behavior as
/// [PayFastWebView] — the shared logic lives in `payfast_completion.dart`.
///
/// Before rendering, it checks that the Microsoft Edge WebView2 Runtime is
/// available; if not, it shows an install prompt with a retry instead of
/// crashing.
class PayFastWebViewWindows extends StatefulWidget {
  final String url;
  final Function(bool)? onComplete;
  final Function(String, Map<String, String>)? onTokenCaptured;

  const PayFastWebViewWindows({
    super.key,
    required this.url,
    this.onComplete,
    this.onTokenCaptured,
  });

  @override
  State<PayFastWebViewWindows> createState() => _PayFastWebViewWindowsState();
}

class _PayFastWebViewWindowsState extends State<PayFastWebViewWindows> {
  /// Microsoft's consumer download page for the WebView2 Evergreen runtime.
  static const String _webView2InstallerUrl =
      'https://developer.microsoft.com/en-us/microsoft-edge/webview2/consumer/';

  bool isLoading = true;
  bool isPaymentComplete = false;

  /// `null` while the availability check is running.
  bool? _webView2Available;

  @override
  void initState() {
    super.initState();
    _checkWebView2Availability();
  }

  Future<void> _checkWebView2Availability() async {
    try {
      final version = await WebViewEnvironment.getAvailableVersion();
      debugPrint('PayFast WebView2 runtime version: $version');
      if (!mounted) return;
      setState(() {
        _webView2Available = version != null;
      });
    } catch (e) {
      debugPrint('PayFast WebView2 availability check failed: $e');
      if (!mounted) return;
      setState(() {
        _webView2Available = false;
      });
    }
  }

  Future<void> _openWebView2Installer() async {
    final launched = await launchUrl(
      Uri.parse(_webView2InstallerUrl),
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      if (!mounted) return;
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Could not open $_webView2InstallerUrl',
      );
    }
  }

  // Check if the URL indicates payment completion (success or failure).
  // Same behavior as the mobile PayFastWebView — shared logic in
  // payfast_completion.dart.
  bool _checkForPaymentCompletion(String url) {
    // Don't process if already detected payment completion
    if (isPaymentComplete) return false;

    final result = evaluatePayFastUrl(url);
    if (!result.isCompletion) return false;

    isPaymentComplete = true;

    return handlePayFastCompletion(
      context: context,
      isMounted: () => mounted,
      result: result,
      onComplete: widget.onComplete,
      onTokenCaptured: widget.onTokenCaptured,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.cardDark,
        elevation: 0,
        title: Text(
          AppHelpers.getTranslation(TrKeys.checkout),
          style: AppStyle.interNormal(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyle.black),
          onPressed: () {
            // Confirm before closing the payment
            AppHelpers.showAlertDialog(
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.areYouSure),
                    style: AppStyle.interSemi(size: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  CustomButton(
                    background: AppStyle.red,
                    textColor: AppStyle.white,
                    title: AppHelpers.getTranslation(TrKeys.cancel),
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close WebView

                      // Inform parent about cancellation
                      if (widget.onComplete != null) {
                        widget.onComplete!(false);
                      }
                    },
                  ),
                  16.verticalSpace,
                  CustomButton(
                    borderColor: AppStyle.black,
                    background: AppStyle.transparent,
                    title: AppHelpers.getTranslation(TrKeys.stay),
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context); // Just close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Availability check still running
    if (_webView2Available == null) {
      return _buildLoadingIndicator();
    }

    // WebView2 runtime missing — show install prompt instead of crashing
    if (_webView2Available == false) {
      return _buildWebView2MissingView();
    }

    return Stack(
      children: [
        // The WebView
        AnimatedOpacity(
          opacity: isLoading ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';
              debugPrint('PayFast WebView (Windows) navigation: $url');

              // Check for success or cancel URLs
              if (_checkForPaymentCompletion(url)) {
                return NavigationActionPolicy.CANCEL;
              }

              // Allow normal navigation
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
              debugPrint('PayFast WebView (Windows) finished loading: $url');

              // Check for success or return URLs
              if (url != null) {
                _checkForPaymentCompletion(url.toString());
              }
            },
            onReceivedError: (controller, request, error) {
              debugPrint(
                'PayFast WebView (Windows) error: ${error.description}',
              );

              // Show error message for main frame errors
              if (request.isForMainFrame ?? true) {
                if (!mounted) return;
                AppHelpers.showCheckTopSnackBarInfo(
                  context,
                  'Payment error: ${error.description}',
                );
              }
            },
            onReceivedHttpError: (controller, request, errorResponse) {
              final statusCode = errorResponse.statusCode ?? 0;
              debugPrint('PayFast WebView (Windows) HTTP error: $statusCode');

              // Show error message for serious main frame errors
              if (statusCode >= 400 && (request.isForMainFrame ?? false)) {
                if (!mounted) return;
                AppHelpers.showCheckTopSnackBarInfo(
                  context,
                  'Payment error: HTTP $statusCode',
                );
              }
            },
          ),
        ),

        // Loading indicator
        if (isLoading) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppStyle.primary),
          16.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.loading),
            style: AppStyle.interSemi(size: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildWebView2MissingView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.travel_explore,
                size: 48,
                color: AppStyle.textGrey,
              ),
              16.verticalSpace,
              Text(
                'Microsoft Edge WebView2 Runtime is required to complete '
                'payments on Windows.',
                style: AppStyle.interSemi(size: 16.sp),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                'Install the runtime, then tap Retry to continue with your '
                'payment.',
                style: AppStyle.interNormal(
                  size: 14.sp,
                  color: AppStyle.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              CustomButton(
                title: 'Install WebView2 Runtime',
                onPressed: _openWebView2Installer,
              ),
              12.verticalSpace,
              CustomButton(
                borderColor: AppStyle.black,
                background: AppStyle.transparent,
                title: 'Retry',
                onPressed: () {
                  setState(() {
                    _webView2Available = null;
                  });
                  _checkWebView2Availability();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
