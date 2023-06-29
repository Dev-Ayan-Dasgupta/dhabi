import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapCreateAccountCorporate {
  static Future<Map<String, dynamic>> mapCreateAccountCorporate(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await CreateAccountCorporate.createAccountCorporate(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
