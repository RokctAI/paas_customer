import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../app_constants.dart';

final shopNameProvider = FutureProvider.family<String, String>((
  ref,
  shopId,
) async {
  final response = await http.get(
    Uri.parse(
      '${AppConstants.baseUrl}/api/v1/method/paas.api.shop.get_shops_by_ids'
      '?shops=${Uri.encodeComponent(jsonEncode([shopId]))}',
    ),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    // Raw http (no dio interceptor) — unwrap Frappe's top-level `message`
    // envelope ourselves; the backend returns api_response(data=[...]) inside.
    final result =
        (responseData is Map ? responseData['message'] : null) ?? responseData;
    final shopTranslation = result['data'][0]['translation']['title'];
    return shopTranslation;
  } else {
    throw Exception('Failed to load shop details');
  }
});
