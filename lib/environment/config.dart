import 'package:dialup_mobile_app/environment/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AllConfig {
  static String get appVersion => dotenv.env['APP_VERSION'] ?? "";
  static String get googleBundleId => dotenv.env['GOOGLE_BUNDLE_ID'] ?? "";
  static String get appleBundleId => dotenv.env['APPLE_BUNDLE_ID'] ?? "";
  static String get companyName => dotenv.env['COMPANY_NAME'] ?? "";
}

class EnvConfig implements BaseConfig {
  @override
  String get getAllCountries {
    return dotenv.env['GET_ALL_COUNTRIES'] ?? "";
  }

  @override
  String get getSupportedLanguages {
    return dotenv.env['GET_SUPPORTED_LANGUAGES'] ?? "";
  }

  @override
  String get getCountryDetails {
    return dotenv.env['GET_COUNTRY_DETAILS'] ?? "";
  }

  @override
  String get getAppLabels {
    return dotenv.env['GET_APP_LABELS'] ?? "";
  }

  @override
  String get getAppMessages {
    return dotenv.env['GET_APP_MESSAGES'] ?? "";
  }
}
