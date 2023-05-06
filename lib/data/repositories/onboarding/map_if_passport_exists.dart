import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapIfPassportExists {
  static Future<bool> mapIfPassportExists(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await IfPassportExists.ifPassportExists(body, token);
      return jsonDecode(response.body)["exists"];
    } catch (_) {
      rethrow;
    }
  }
}
