import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/login.dart';
import 'package:dialup_mobile_app/presentation/screens/not_available.dart';
import 'package:dialup_mobile_app/presentation/screens/onboarding_soft.dart';
import 'package:dialup_mobile_app/presentation/screens/otp.dart';
import 'package:dialup_mobile_app/presentation/screens/registration.dart';
import 'package:dialup_mobile_app/presentation/screens/select_account_type.dart';
import 'package:dialup_mobile_app/presentation/screens/splash.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case Routes.registration:
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.selectAccountType:
        return MaterialPageRoute(
          builder: (_) => const SelectAccountTypeScreen(),
        );
      case Routes.notAvailable:
        return MaterialPageRoute(
          builder: (_) => NotAvaiableScreen(
            argument: args,
          ),
        );
      case Routes.otp:
        return MaterialPageRoute(
          builder: (_) => OTPScreen(
            argument: args,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Empty Screen"),
            ),
          ),
        );
    }
  }
}
