import 'package:http/http.dart' as http;

class GetAppLabels {
  static Future<http.Response> getAppLabels() async {
    try {
      return http.post(
        Uri.parse(
          "https://dev-dhabi.fh.ae/api/v1/config/getAppLabels",
        ),
        body: {"languageCode": "en"},
      );
    } catch (e) {
      print("api exception -> $e");
      rethrow;
    }
  }
}
