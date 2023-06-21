import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetCorporateCustomerAccountDetails {
  static Future<http.Response> getCorporateCustomerAccountDetails(
      String token) async {
    try {
      return http.post(
        Uri.parse(Environment().config.getCorporateCustomerAccountDetails),
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
