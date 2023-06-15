import 'dart:convert';

import 'package:dialup_mobile_app/data/apis/notifications/index.dart';
import 'package:http/http.dart' as http;

class MapRemoveNotifications {
  static Future<Map<String, dynamic>> mapRemoveNotifications(
      Map<String, dynamic> body, String token) async {
    try {
      http.Response response =
          await RemoveNotification.removeNotification(body, token);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
