// Copyright (c) 2024 RokctAI
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/loans/loan_contract_model.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'dart:math';
import 'package:payfast/payfast.dart';
import '../../domain/interface/loans.dart';
import '../../utils/payfast/payfast_webview.dart';
import '../models/data/loans/loan_application.dart';

class LoansRepository implements LoansRepositoryFacade {
  @override
  Future<ApiResult<dynamic>> submitLoanApplication({
    required LoanApplicationModel applicationData,
  }) async {
    try {
      final user = LocalStorage.getUser();
      final financials = applicationData.financialDetails ?? {};

      final double income =
          (financials['monthly_income'] as num?)?.toDouble() ?? 0.0;
      final double expenses =
          ((financials['grocery_expenses'] as num?)?.toDouble() ?? 0.0) +
              ((financials['other_expenses'] as num?)?.toDouble() ?? 0.0) +
              ((financials['existing_credits'] as num?)?.toDouble() ?? 0.0);

      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.create_loan_application',
        data: {
          'applicant_type': 'Customer',
          'applicant': user?.firstname != null
              ? "${user?.firstname} ${user?.lastname}"
              : user
                  ?.email, // Best guess for Name, backend should key off User though.
          'loan_product': 'Personal Loan',
          'loan_amount': applicationData.amount,
          'income': income,
          'total_expenses': expenses,
          'skip_documents': applicationData.skipDocuments ? 1 : 0,
          'id_number': applicationData.idNumber, // Extra metadata
          'documents': json.encode(applicationData.documents),
          'saved_application_id': applicationData.savedApplicationId,
        },
      );
      return ApiResult.success(data: response.data);
    } catch (e) {
      debugPrint('==> loan application submission failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // Fetch Loan Transactions Method
  @override
  Future<ApiResult<List<dynamic>>> fetchLoanTransactions(int page) async {
    debugPrint('==> Fetching loan transactions, page: $page');
    // Using Frappe standard method for wallet history
    final start = (page - 1) * 20;
    final limit = 20;

    final data = {'start': start, 'limit': limit};
    debugPrint('==> Query parameters: ${jsonEncode(data)}');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint(
        '==> Sending GET request to /api/method/paas.api.user.user.get_wallet_history',
      );
      final response = await client.get(
        '/api/method/paas.api.user.user.get_wallet_history',
        queryParameters: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      // Frappe returns {"message": [...]} or just [...] depending on endpoint
      if (response.data != null &&
          (response.data['message'] != null || response.data is List)) {
        final transactions = response.data['message'] ?? response.data;
        if (transactions is List) {
          debugPrint('==> Found ${transactions.length} transactions');
          // Filter for loan transactions if possible, or return all wallet history
          return ApiResult.success(data: transactions);
        }
      }

      // Return empty list if no data
      debugPrint('==> No transactions found');
      return const ApiResult.success(data: []);
    } catch (e) {
      debugPrint('==> get loan transactions failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> checkLoanEligibility({
    required String idNumber,
    required double amount,
  }) async {
    debugPrint(
      '==> Checking loan eligibility for ID: $idNumber, amount: $amount',
    );
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'id_number': idNumber,
        'amount': amount,
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint(
        '==> Sending POST request to /api/method/paas.api.check_loan_eligibility',
      );
      final response = await client.post(
        '/api/method/paas.api.check_loan_eligibility',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      // The backend returns {"message": {"is_eligible": true}} or just {"is_eligible": true}
      final message = response.data['message'] ?? response.data;
      final isEligible = message['is_eligible'] ?? false;
      debugPrint('==> Eligibility result: $isEligible');

      return ApiResult.success(data: isEligible);
    } catch (e) {
      debugPrint('==> loan eligibility check failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> getLoanDetails(String loanId) async {
    debugPrint('==> Getting loan details for ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Using standard Frappe REST API to get Loan Application
      debugPrint(
        '==> Sending GET request to /api/resource/Loan Application/$loanId',
      );
      final response = await client.get(
        '/api/resource/Loan Application/$loanId',
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      // Standard Frappe response for get_doc is {"data": {...}}
      if (response.data != null && response.data['data'] != null) {
        return ApiResult.success(data: response.data['data']);
      }

      return const ApiResult.failure(error: "Loan not found", statusCode: 404);
    } catch (e) {
      debugPrint('==> get loan details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> cancelLoanApplication(String loanId) async {
    debugPrint('==> Cancelling loan application with ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Using update to change status if allowed, or specific endpoint if exists.
      // Backend doesn't expose a cancel endpoint. Trying to update status via REST API.
      debugPrint(
        '==> Sending PUT request to /api/resource/Loan Application/$loanId',
      );
      await client.put(
        '/api/resource/Loan Application/$loanId',
        data: {'status': 'Cancelled'},
      );
      debugPrint('==> Loan cancellation successful');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> cancel loan application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> tokenizeCardWithVerificationFee({
    required BuildContext context,
    bool forceCardPayment = true,
    bool enableTokenization = true,
  }) async {
    debugPrint('==> Starting card tokenization with verification fee');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Use get_payfast_settings from backend
      debugPrint(
        '==> Sending GET request to /api/method/paas.api.payment.payment.get_payfast_settings',
      );
      var res = await client.get(
        '/api/method/paas.api.payment.payment.get_payfast_settings',
      );

      debugPrint('==> tokenization response: ${jsonEncode(res.data)}');

      final settings = res.data?["message"] ?? res.data ?? {};
      debugPrint('==> API data extracted: ${jsonEncode(settings)}');

      // Get user information
      final user = LocalStorage.getUser();
      final email = user?.email;
      final phone = user?.phone;
      final firstName = user?.firstname;
      final lastName = user?.lastname;
      debugPrint(
        '==> User info - Email: $email, Phone: $phone, Name: $firstName $lastName',
      );

      // Override PayFast settings locally for the enhancedPayment call
      final String passphrase =
          settings["pass_phrase"] ?? AppConstants.passphrase;
      final String merchantId =
          settings["merchant_id"] ?? AppConstants.merchantId;
      final String merchantKey =
          settings["merchant_key"] ?? AppConstants.merchantKey;

      // Use PayFastService for payment
      debugPrint('==> Generating PayFast payment URL');
      final paymentUrl = Payfast.enhancedPayment(
        passphrase: passphrase,
        merchantId: merchantId,
        merchantKey: merchantKey,
        production: !(settings["is_sandbox"] ?? true),
        amount: '5.00',
        itemName: 'Loan Tokenization',
        notifyUrl: settings["success_redirect_url"] ??
            "", // Map success to notify/return as fallback
        cancelUrl: settings["failure_redirect_url"] ?? "",
        returnUrl: settings["success_redirect_url"] ?? "",
        paymentId: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        forceCardPayment: forceCardPayment,
        enableTokenization: enableTokenization,
      );
      debugPrint('==> Generated payment URL: $paymentUrl');

      // Preload the WebView if context is available
      if (context.mounted) {
        try {
          debugPrint('==> Preloading PayFast WebView');
          PayFastWebViewPreloader.preloadPayFastWebView(context, paymentUrl);
          debugPrint('==> WebView preloaded successfully');
        } catch (e) {
          debugPrint('==> Unable to preload PayFast WebView: $e');
        }
      }

      return ApiResult.success(data: paymentUrl);
    } catch (e, s) {
      debugPrint('==> tokenization charge failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LoanContractModel>> fetchLoanContract(String loanId) async {
    debugPrint('==> Fetching loan contract for loan ID: $loanId');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Using standard REST API to query Loan Contract by loan_application
      final queryParams = {
        'filters': jsonEncode([
          ["loan_application", "=", loanId],
        ]),
        'fields': jsonEncode(["*"]),
        'limit': 1,
      };
      debugPrint('==> Query parameters: ${jsonEncode(queryParams)}');

      debugPrint('==> Sending GET request to /api/resource/Loan Contract');
      final response = await client.get(
        '/api/resource/Loan Contract',
        queryParameters: queryParams,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      if (response.data != null && response.data['data'] != null) {
        final List dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          final contractData = dataList[0];
          debugPrint(
            '==> Contract data extracted: ${jsonEncode(contractData)}',
          );
          debugPrint('==> Converting to LoanContractModel');
          final contract = LoanContractModel.fromJson(contractData);
          debugPrint('==> Contract model created successfully');
          return ApiResult.success(data: contract);
        }
      }

      return const ApiResult.failure(
        error: "Contract not found",
        statusCode: 404,
      );
    } catch (e) {
      debugPrint('==> fetch loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> acceptLoanContract({
    required String loanId,
    required String contractId,
  }) async {
    debugPrint(
      '==> Accepting loan contract - Loan ID: $loanId, Contract ID: $contractId',
    );
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Try to update the contract status via REST API
      debugPrint(
        '==> Sending PUT request to /api/resource/Loan Contract/$contractId',
      );
      await client.put(
        '/api/resource/Loan Contract/$contractId',
        data: {
          'status': 'Accepted',
          'accepted_date': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('==> Contract acceptance successful');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> accept loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> checkLoanHistoryEligibility() async {
    debugPrint('==> Checking loan history eligibility');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      debugPrint(
        '==> Sending GET request to /api/method/paas.api.check_loan_history_eligibility',
      );
      final response = await client.get(
        '/api/method/paas.api.check_loan_history_eligibility',
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final eligibilityData = response.data['message'] ?? response.data ?? {};
      debugPrint('==> Eligibility data: ${jsonEncode(eligibilityData)}');

      return ApiResult.success(data: eligibilityData);
    } catch (e) {
      debugPrint('==> check loan history eligibility failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> markApplicationAsRejected({
    required Map<String, dynamic> financialDetails,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Marking application as rejected');

      // The backend expects financial_details as a dict.
      final data = {'financial_details': financialDetails};

      debugPrint('==> Request data: ${jsonEncode(data)}');

      // Use the correct endpoint
      final response = await client.post(
        '/api/method/paas.api.mark_application_as_rejected',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> mark application as rejected failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> checkFinancialEligibility({
    required double monthlyIncome,
    required double groceryExpenses,
    required double otherExpenses,
    required double existingCredits,
  }) async {
    debugPrint('==> Checking financial eligibility');
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      final data = {
        'monthly_income': monthlyIncome,
        'grocery_expenses': groceryExpenses,
        'other_expenses': otherExpenses,
        'existing_credits': existingCredits,
      };
      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint(
        '==> Sending POST request to /api/method/paas.api.check_financial_eligibility',
      );
      final response = await client.post(
        '/api/method/paas.api.check_financial_eligibility',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final eligibilityData = response.data['message'] ?? response.data ?? {};
      debugPrint(
        '==> Financial eligibility data: ${jsonEncode(eligibilityData)}',
      );

      return ApiResult.success(data: eligibilityData);
    } catch (e) {
      debugPrint('==> check financial eligibility failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> saveIncompleteLoanApplication({
    required Map<String, dynamic> financialDetails,
  }) async {
    debugPrint('==> Saving incomplete loan application');
    debugPrint('==> Financial details: ${jsonEncode(financialDetails)}');

    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Created authenticated client');

      // Structure the data properly for backend
      // Backend expects 'financial_details' as a dict parameter
      final data = {'financial_details': financialDetails};

      debugPrint('==> Request data: ${jsonEncode(data)}');

      debugPrint(
        '==> Sending POST request to /api/method/paas.api.save_incomplete_loan_application',
      );
      final response = await client.post(
        '/api/method/paas.api.save_incomplete_loan_application',
        data: data,
      );
      debugPrint('==> Got response: ${jsonEncode(response.data)}');

      final message = response.data['message'] ?? response.data;
      final applicationId = message['name']?.toString() ?? '';
      debugPrint('==> Application ID received: $applicationId');

      return ApiResult.success(data: applicationId);
    } catch (e) {
      debugPrint('==> save incomplete loan application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> declineLoanContract({required String loanId}) async {
    debugPrint('==> Declining loan contract for loan ID: $loanId');
    try {
      // Trying to find contract and update status to Declined
      final client = dioHttp.client(requireAuth: true);

      // Find contract first
      final queryParams = {
        'filters': jsonEncode([
          ["loan_application", "=", loanId],
        ]),
        'limit': 1,
      };

      final response = await client.get(
        '/api/resource/Loan Contract',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['data'] != null) {
        final List dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          final contractId = dataList[0]['name'];

          // Update status
          await client.put(
            '/api/resource/Loan Contract/$contractId',
            data: {'status': 'Declined'},
          );
          return const ApiResult.success(data: true);
        }
      }

      return const ApiResult.success(
        data: true,
      ); // Assume success even if not found
    } catch (e) {
      debugPrint('==> decline loan contract failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> fetchSavedApplication() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Fetching saved loan application');

      final response = await client.get(
        '/api/method/paas.api.fetch_saved_application',
      );
      debugPrint(
        '==> Saved application response: ${jsonEncode(response.data)}',
      );

      final message = response.data['message'] ?? response.data;

      if (message != null && message is Map) {
        final applicationData = Map<String, dynamic>.from(message);
        debugPrint(
          '==> Application data found: ${jsonEncode(applicationData)}',
        );

        return ApiResult.success(data: applicationData);
      }

      debugPrint('==> No saved application found');
      return ApiResult.success(data: {});
    } catch (e) {
      debugPrint('==> fetch saved application failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> fetchSavedApplications() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Fetching saved loan applications');

      final response = await client.get(
        '/api/method/paas.api.fetch_saved_applications',
      );
      debugPrint(
        '==> Saved applications response: ${jsonEncode(response.data)}',
      );

      final message = response.data['message'] ?? response.data;

      if (message != null && message is List) {
        List<Map<String, dynamic>> processedApplications = [];
        for (var item in message) {
          if (item is Map) {
            processedApplications.add(Map<String, dynamic>.from(item));
          }
        }
        return ApiResult.success(data: processedApplications);
      }

      debugPrint('==> No saved applications found');
      return ApiResult.success(data: []);
    } catch (e) {
      debugPrint('==> fetch saved applications failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  Future<ApiResult<String>> disburseLoan(String loanApplicationName) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.disburse_loan',
        data: {'loan_application': loanApplicationName},
      );
      return ApiResult.success(data: response.data['message']);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  Future<ApiResult<String>> requestPayout(String loanApplicationName) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.request_payout',
        data: {'loan_application': loanApplicationName},
      );
      return const ApiResult.success(
        data: "Payout request submitted successfully!",
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  Future<ApiResult<List<dynamic>>> fetchMyLoanApplications() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Fetching my loan applications');

      final response = await client.post(
        '/api/method/paas.api.get_my_loan_applications',
      );
      debugPrint('==> My applications response: ${jsonEncode(response.data)}');

      if (response.data != null && response.data['message'] != null) {
        return ApiResult.success(data: response.data['message']);
      }

      return ApiResult.success(data: []);
    } catch (e) {
      debugPrint('==> fetch my loan applications failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> generateAndEmailContractPdf({
    required String loanId,
    required bool isAcceptance,
  }) async {
    debugPrint('==> Generating and emailing contract PDF for loan ID: $loanId');
    // Not implemented in backend
    return const ApiResult.success(data: "");
  }

  Future<ApiResult<int>> getCompletedLoanCount() async {
    try {
      final result = await fetchLoanTransactions(1);

      return result.when(
        success: (transactions) {
          // Filter for successfully repaid loans
          final completedLoans = transactions
              .where(
                (loan) =>
                    loan['status']?.toString().toLowerCase() == 'paid' ||
                    loan['status']?.toString().toLowerCase() == 'completed',
              )
              .toList();

          return ApiResult.success(data: completedLoans.length);
        },
        failure: (error, statusCode) {
          // Default to 0 if we can't determine
          return ApiResult.success(data: 0);
        },
      );
    } catch (e) {
      debugPrint('==> get completed loan count failure: $e');
      return ApiResult.success(data: 0);
    }
  }

  double getQualifyingAmount(int completedLoanCount) {
    switch (completedLoanCount) {
      case 0:
        return 500.0; // First time
      case 1:
        return 1500.0; // Second time
      case 2:
        return 2500.0; // Third time
      default:
        return 10000.0; // More than 3 loans
    }
  }

  Future<ApiResult<double>> calculatePreApprovalAmount(
    Map<String, dynamic> financialDetails,
  ) async {
    try {
      // First, get the loan history tier
      final countResult = await getCompletedLoanCount();
      int loanCount = 0;

      countResult.when(
        success: (count) {
          loanCount = count;
        },
        failure: (_, __) {
          loanCount = 0;
        },
      );

      // Get tier-based maximum
      final tierMaximum = getQualifyingAmount(loanCount);

      // Calculate risk-based amount
      final riskBasedAmount = _calculateRiskBasedAmount(
        loanCount: loanCount,
        tierMaximum: tierMaximum,
        financialDetails: financialDetails,
      );

      return ApiResult.success(data: riskBasedAmount);
    } catch (e) {
      debugPrint('==> calculate pre-approval amount failure: $e');
      // Default to minimum amount on error
      return ApiResult.success(data: 200.0);
    }
  }

  double _calculateRiskBasedAmount({
    required int loanCount,
    required double tierMaximum,
    required Map<String, dynamic> financialDetails,
  }) {
    // Extract financial metrics
    final monthlyIncome = financialDetails['monthly_income'] as double? ?? 0.0;
    final groceryExpenses =
        financialDetails['grocery_expenses'] as double? ?? 0.0;
    final otherExpenses = financialDetails['other_expenses'] as double? ?? 0.0;
    final existingCredits =
        financialDetails['existing_credits'] as double? ?? 0.0;

    // Calculate total expenses
    final totalExpenses = groceryExpenses + otherExpenses + existingCredits;

    // Calculate debt-to-income ratio (DTI)
    final dti = monthlyIncome > 0 ? totalExpenses / monthlyIncome : 1.0;

    // Calculate discretionary income
    final discretionaryIncome = monthlyIncome - totalExpenses;

    // Risk scoring based on financial metrics
    double riskScore = 0.0;

    // DTI scoring (lower is better)
    if (dti <= 0.2) {
      riskScore += 3.0; // Excellent DTI
    } else if (dti <= 0.3) {
      riskScore += 2.0; // Good DTI
    } else if (dti <= 0.4) {
      riskScore += 1.0; // Acceptable DTI
    }

    // Discretionary income scoring (higher is better)
    if (discretionaryIncome >= 10000) {
      riskScore += 3.0; // Excellent discretionary income
    } else if (discretionaryIncome >= 5000) {
      riskScore += 2.0; // Good discretionary income
    } else if (discretionaryIncome >= 2000) {
      riskScore += 1.0; // Acceptable discretionary income
    }

    // Income scoring (higher is better)
    if (monthlyIncome >= 20000) {
      riskScore += 3.0; // High income
    } else if (monthlyIncome >= 10000) {
      riskScore += 2.0; // Good income
    } else if (monthlyIncome >= 5000) {
      riskScore += 1.0; // Acceptable income
    }

    // Maximum possible score is 9.0

    // Calculate percentage of tier maximum based on risk score
    double percentageOfMaximum = 0.0;

    if (riskScore >= 7.0) {
      percentageOfMaximum = 1.0; // 100% of tier maximum
    } else if (riskScore >= 5.0) {
      percentageOfMaximum = 0.8; // 80% of tier maximum
    } else if (riskScore >= 3.0) {
      percentageOfMaximum = 0.6; // 60% of tier maximum
    } else {
      percentageOfMaximum = 0.4; // 40% of tier maximum (minimum)
    }

    // Calculate pre-approval amount
    double preApprovalAmount = tierMaximum * percentageOfMaximum;

    // Ensure it's at least the minimum loan amount
    preApprovalAmount = max(preApprovalAmount, 200.0);

    // Round to nearest 100
    preApprovalAmount = (preApprovalAmount / 100).round() * 100;

    return preApprovalAmount;
  }
}
