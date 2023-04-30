import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapCountryDetails {
  // TODO: test API and see return type
  static Future<List> mapCountryDetails(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetCountryDetails.getCountryDetails(body);
      return jsonDecode(response.body)[
          "labels"]; // TODO: pass the correct parameter after testing api
    } catch (_) {
      rethrow;
    }
  }
}
