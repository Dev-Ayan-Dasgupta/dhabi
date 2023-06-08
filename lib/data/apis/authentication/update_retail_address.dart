import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class UpdateRetailAddress {
  static Future<http.Response> updateRetailAddress(
      Map<String, dynamic> body, String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.updateRetailAddress),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
