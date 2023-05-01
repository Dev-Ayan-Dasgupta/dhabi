import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetAllCountries {
  static Future<http.Response> getAllCountries() async {
    try {
      return http.post(
        Uri.parse(
          Environment().config.getAllCountries,
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
