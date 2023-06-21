import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class ApproveOrDisapproveCorporateFd {
  static Future<http.Response> approveOrDisapproveCorporateFd(
      String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.approveOrDisapproveCorporateFd),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}
