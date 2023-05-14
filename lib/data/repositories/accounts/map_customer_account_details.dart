import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCustomerAccountDetails {
  static Future<Map<String, dynamic>> mapCustomerAccountDetails(
      String token) async {
    try {
      http.Response response =
          await GetCustomerAccountDetails.getCustomerAccountDetails(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
