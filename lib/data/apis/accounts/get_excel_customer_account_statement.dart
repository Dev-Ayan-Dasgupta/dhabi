import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetExcelCustomerAccountStatement {
  static Future<http.Response> getExcelCustomerAccountStatement(
      Map<String, dynamic> body, String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.getExcelCustomerAccountStatement),
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
