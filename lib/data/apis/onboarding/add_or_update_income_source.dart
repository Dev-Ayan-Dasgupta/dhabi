import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class AddOrUpdateIncomeSource {
  static Future<http.Response> addOrUpdateIncomeSource(
      Map<String, dynamic> body, String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.addOrUpdateIncomeSource),
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