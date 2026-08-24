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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';

import 'payfast_completion.dart';

// Provider for preloaded WebView state
final payFastWebViewProvider = StateProvider<PayFastWebViewState?>(
  (ref) => null,
);

// State class for tracking preloaded WebView
class PayFastWebViewState {
  final WebViewController controller;
  final String url;
  final bool isReady;

  PayFastWebViewState({
    required this.controller,
    required this.url,
    this.isReady = false,
  });

  PayFastWebViewState copyWith({
    WebViewController? controller,
    String? url,
    bool? isReady,
  }) {
    return PayFastWebViewState(
      controller: controller ?? this.controller,
      url: url ?? this.url,
      isReady: isReady ?? this.isReady,
    );
  }
}

/// Enhanced WebView specifically for PayFast payments with token capture
class PayFastWebView extends StatefulWidget {
  final String url;
  final Function(bool)? onComplete;
  final Function(String, Map<String, String>)? onTokenCaptured;
  final WebViewController? preloadedController;

  const PayFastWebView({
    super.key,
    required this.url,
    this.onComplete,
    this.onTokenCaptured,
    this.preloadedController,
  });

  @override
  State<PayFastWebView> createState() => _PayFastWebViewState();
}

class _PayFastWebViewState extends State<PayFastWebView> {
  late WebViewController controller;
  bool isLoading = true;
  bool isPaymentComplete = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();

    // Only initialize non-theme dependent aspects of the controller
    if (widget.preloadedController != null) {
      controller = widget.preloadedController!;
      _isControllerInitialized = true;

      // Check if already loaded
      controller.currentUrl().then((currentUrl) {
        if (currentUrl == widget.url) {
          setState(() {
            isLoading = false;
          });
        } else {
          // Load the URL if it's different
          controller.loadRequest(Uri.parse(widget.url));
        }
      });

      // Setup navigation delegate
      _setupNavigationDelegate();
    } else {
      // Initialize with non-theme dependent settings
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      // Rest of initialization will happen in didChangeDependencies
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Don't re-initialize if already done (avoid infinite loops)
    if (!_isControllerInitialized) {
      // Now we can safely access Theme
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

      // Setup navigation delegate
      _setupNavigationDelegate();

      // Load the URL
      controller.loadRequest(Uri.parse(widget.url));

      _isControllerInitialized = true;
    }
  }

  void _setupNavigationDelegate() {
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          debugPrint('PayFast WebView started loading: $url');
        },
        onPageFinished: (String url) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          debugPrint('PayFast WebView finished loading: $url');

          // Check for success or return URLs
          _checkForPaymentCompletion(url);
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('PayFast WebView error: ${error.description}');

          // Show error message for serious errors
          if (error.errorCode >= 400) {
            if (!mounted) return;
            AppHelpers.showCheckTopSnackBarInfo(
              context,
              'Payment error: ${error.description}',
            );
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          debugPrint('PayFast WebView navigation: ${request.url}');

          // Check for success or cancel URLs
          if (_checkForPaymentCompletion(request.url)) {
            return NavigationDecision.prevent;
          }

          // Allow normal navigation
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  // Check if the URL indicates payment completion (success or failure).
  // Shared logic lives in payfast_completion.dart so the Windows variant
  // (payfast_webview_windows.dart) behaves identically.
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
      body: Stack(
        children: [
          // The WebView
          AnimatedOpacity(
            opacity: isLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: controller),
          ),

          // Loading indicator
          if (isLoading)
            Center(
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
            ),
        ],
      ),
    );
  }
}

/// Utility class for preloading PayFast WebView
class PayFastWebViewPreloader {
  /// Preloads a WebView with the given PayFast URL
  static void preloadPayFastWebView(BuildContext context, String url) {
    // webview_flutter has no Windows implementation — the Windows payment
    // flow uses PayFastWebViewWindows without a warm-up preload.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      debugPrint('PayFast WebView preload skipped on Windows');
      return;
    }

    try {
      // Create the controller first
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      // Set initial state
      ProviderScope.containerOf(
        context,
      ).read(payFastWebViewProvider.notifier).state = PayFastWebViewState(
        controller: controller,
        url: url,
        isReady: false,
      );

      // Now set theme-dependent properties
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String loadedUrl) {
            // Update provider state when load is complete
            ProviderScope.containerOf(
              context,
            ).read(payFastWebViewProvider.notifier).state = PayFastWebViewState(
              controller: controller,
              url: url,
              isReady: true,
            );
            debugPrint('PayFast WebView preloaded: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation during preloading
            return NavigationDecision.navigate;
          },
        ),
      );

      // Load the URL
      controller.loadRequest(Uri.parse(url));
      debugPrint('Started preloading PayFast WebView: $url');
    } catch (e) {
      debugPrint('PayFast WebView preload error: $e');
    }
  }

  /// Get the preloaded WebView controller if available and matching the URL
  static WebViewController? getPreloadedController(WidgetRef ref, String url) {
    final preloadedState = ref.read(payFastWebViewProvider);
    if (preloadedState != null &&
        preloadedState.url == url &&
        preloadedState.isReady) {
      return preloadedState.controller;
    }
    return null;
  }
}
