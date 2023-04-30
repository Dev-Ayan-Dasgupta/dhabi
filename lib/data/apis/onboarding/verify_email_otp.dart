import 'dart:convert';

import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class VerifyEmailOtp {
  static Future<http.Response> verifyEmailOtp(Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(Environment().config.verifyEmailOtp),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
