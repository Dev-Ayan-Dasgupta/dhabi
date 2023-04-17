import 'package:dialup_mobile_app/environment/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AllConfig {
  static String get appVersion => dotenv.env['APP_VERSION'] ?? "";
  static String get googleBundleId => dotenv.env['GOOGLE_BUNDLE_ID'] ?? "";
  static String get appleBundleId => dotenv.env['APPLE_BUNDLE_ID'] ?? "";
  static String get companyName => dotenv.env['COMPANY_NAME'] ?? "";
}

class EnvConfig implements BaseConfig {}
