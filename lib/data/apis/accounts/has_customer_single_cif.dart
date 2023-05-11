import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class HasCustomerSingleCif {
  static Future<http.Response> hasCustomerSingleCif(
      Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(Environment().config.hasCustomerSingleCif),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
