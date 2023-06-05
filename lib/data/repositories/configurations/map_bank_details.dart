import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapBankDetails {
  static Future<List> mapBankDetails() async {
    try {
      http.Response response = await GetBankDetails.getBankDetails();
      return jsonDecode(response.body)["banks"];
    } catch (_) {
      rethrow;
    }
  }
}
