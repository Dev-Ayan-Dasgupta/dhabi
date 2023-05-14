import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetCustomerAccountDetails {
  static Future<http.Response> getCustomerAccountDetails(String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.getCustomerAccountDetails),
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
