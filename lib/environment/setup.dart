import 'package:dialup_mobile_app/environment/index.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String stag = 'stag';
  static const String prod = 'prod';

  late BaseConfig config;

  initConfig(String environment) {
    config = getConfig(environment);
  }

  BaseConfig getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        return EnvConfig();
      case Environment.stag:
        return EnvConfig();
      case Environment.dev:
        return EnvConfig();
      default:
        return EnvConfig();
    }
  }

  static String getName(String environment) {
    switch (environment) {
      case Environment.prod:
        return '.env.production';
      case Environment.stag:
        return '.env.staging';
      case Environment.dev:
        return '.env.development';
      default:
        return '.env.development';
    }
  }
}
