import 'package:dialup_mobile_app/environment/index.dart';
import 'package:http/http.dart' as http;

class GetTransferCapabilities {
  static Future<http.Response> getTransferCapabilities() async {
    try {
      return http.post(
        Uri.parse(
          Environment().config.getTransferCapabilities,
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
