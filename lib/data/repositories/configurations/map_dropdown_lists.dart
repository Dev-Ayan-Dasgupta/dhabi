import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/configurations/get_dropdown_lists.dart';
import 'package:http/http.dart' as http;

class MapDropdownLists {
  static Future<List> mapDropdownLists(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetDropdownLists.getDropdownLists(body);
      print(
          "Dropdown List API output -> ${jsonDecode(response.body).runtimeType}");
      return jsonDecode(response.body);
    } catch (e) {
      print("API error -> $e");
      rethrow;
    }
  }
}
