import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetFaqs {
  static Future<http.Response> getFaqs() async {
    try {
      return http.post(
        Uri.parse(
          Environment().config.getFAQs,
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
