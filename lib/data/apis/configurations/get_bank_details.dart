import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetBankDetails {
  static Future<http.Response> getBankDetails() async {
    try {
      return http.post(
        Uri.parse(
          Environment().config.getBankDetails,
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}
