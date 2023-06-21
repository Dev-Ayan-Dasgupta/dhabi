import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapGetLoans {
  static Future<String> mapGetLoans(String token) async {
    try {
      http.Response response = await GetLoans.getLoans(token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
