import 'dart:convert';
import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetDropdownLists {
  static Future<http.Response> getDropdownLists(
      Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(
          Environment().config.getDropdownLists,
        ),
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
