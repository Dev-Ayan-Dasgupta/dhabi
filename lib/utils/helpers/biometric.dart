import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricHelper {
  static Future<bool> authenticateUser() async {
    // ? initiate Local Authetication plugin
    final LocalAuthentication localAuthentication = LocalAuthentication();

    // ? status of authentication
    bool isAuthenticated = false;

    // ? check if device supports biometrics authentication
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();

    // ? check if user has enabled biometrics
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    // ? if device supports biometrics and user has enabled biometrics, then authenticate

    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason:
              "Use biometric authentication to unlock this authenticator",
          authMessages: <AuthMessages>[
            const AndroidAuthMessages(
              cancelButton: 'Cancel',
            ),
            const IOSAuthMessages(
              cancelButton: 'Cancel',
            )
          ],
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } catch (e) {
        debugPrint("Local Auth Exception -> $e");
      }
    }

    return isAuthenticated;
  }
}
