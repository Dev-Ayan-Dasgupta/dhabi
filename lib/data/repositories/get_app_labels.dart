import 'package:dialup_mobile_app/data/apis/get_app_labels.dart';
import 'package:http/http.dart' as http;

class MapAppLabels {
  static Future<List<Map<String, dynamic>>> mapAppLabels() async {
    try {
      http.Response response = await GetAppLabels.getAppLabels();
      print("response -> $response");
      return [];
    } catch (e) {
      print("mapping exception -> $e");
      rethrow;
    }
  }
}
