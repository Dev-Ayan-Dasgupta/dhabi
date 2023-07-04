import 'dart:convert';
import 'dart:developer';

import 'package:dialup_mobile_app/data/apis/corporateAccounts/index.dart';
import 'package:http/http.dart' as http;

class MapForeignMoneyTransfer {
  static Future<Map<String, dynamic>> mapForeignMoneyTransfer(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await MakeForeignMoneyTransfer.makeForeignMoneyTransfer(body, token);
      if (response.statusCode != 200) {
        log("Status Code -> ${response.statusCode}");
      }
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
