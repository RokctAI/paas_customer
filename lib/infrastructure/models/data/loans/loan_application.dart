// Copyright (c) 2024 RokctAI. All rights reserved.
// Licensed under the GPLv3. See LICENSE file in the project root for details.

import 'dart:io';

class LoanApplicationModel {
  final String idNumber;
  final double amount;
  final Map<String, dynamic>? financialDetails; // Added
  final double income;
  final double totalExpenses;
  final bool skipDocuments;
  final String? savedApplicationId;
  final List<File> documents; // Assuming documents was a List<File> based on original constructor

  LoanApplicationModel({
    required this.idNumber,
    required this.amount,
    required this.documents,
    this.savedApplicationId,
    this.financialDetails,
    this.income = 0,
    this.totalExpenses = 0,
    this.skipDocuments = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_number': idNumber,
      'amount': amount,
      'saved_application_id': savedApplicationId,
    };
  }
}
