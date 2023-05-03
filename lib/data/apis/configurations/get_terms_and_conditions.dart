import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetTermsAndConditions {
  static Future<http.Response> getTermsAndConditions(
      Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(Environment().config.getTermsAndConditions),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
