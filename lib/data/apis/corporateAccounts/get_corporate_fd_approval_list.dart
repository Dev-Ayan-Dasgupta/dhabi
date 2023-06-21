import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetCorporateFdApprovalList {
  static Future<http.Response> getCorporateFdApprovalList(String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.getCorporateFdApprovalList),
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
