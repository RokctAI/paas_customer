import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../app_constants.dart';

final aboutProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final response = await http.get(
      Uri.parse(
        '${AppConstants.baseUrl}/api/v1/method/paas.api.page.get_page?route=about',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Raw http (no dio interceptor) — unwrap Frappe's top-level
      // `message` envelope ourselves.
      final page = (data is Map ? data['message'] : null) ?? data;
      final translation = page['translation'];

      final imgUrl = page['img'];

      return {
        'title': translation['title'],
        'description': translation['description'],
        'img': imgUrl, // Include the image URL
      };
    } else {
      throw Exception('Failed to fetch about data');
    }
  } catch (e) {
    // Handle network exceptions here
    if (e.toString().contains('SocketException')) {
      // Return null to indicate network error
      return null;
    } else {
      rethrow;
    }
  }
});
