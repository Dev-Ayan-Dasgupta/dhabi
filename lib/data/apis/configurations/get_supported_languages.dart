import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetSupportedLanguages {
  static Future<http.Response> getSupportedLanguages() async {
    try {
      return http.post(
        Uri.parse(Environment().config.getSupportedLanguages),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (_) {
      rethrow;
    }
  }
}
