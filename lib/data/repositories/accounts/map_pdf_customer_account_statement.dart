import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapPdfCustomerAccountStatement {
  static Future<String> mapPdfCustomerAccountStatement(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await GetPdfCustomerAccountStatement.getPdfCustomerAccountStatement(
              body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
