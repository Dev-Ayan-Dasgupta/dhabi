import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapLoanDetails {
  static Future<String> mapLoanDetails(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response = await GetLoanDetails.getLoanDetails(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
