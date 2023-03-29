import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/request.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/success_request.dart';
import 'package:dialup_mobile_app/presentation/screens/business/thank_you.dart';
import 'package:dialup_mobile_app/presentation/screens/create_password.dart';
import 'package:dialup_mobile_app/presentation/screens/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/verify_mobile.dart';
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
          builder: (_) => OnboardingScreen(
            argument: args,
          ),
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
          builder: (_) => SelectAccountTypeScreen(
            argument: args,
          ),
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
      case Routes.createPassword:
        return MaterialPageRoute(
          builder: (_) => CreatePasswordScreen(
            argument: args,
          ),
        );
      case Routes.retailDashboard:
        return MaterialPageRoute(
          builder: (_) => RetailDashboardScreen(
            argument: args,
          ),
        );
      case Routes.businessDashboard:
        return MaterialPageRoute(
          builder: (_) => BusinessDashboardScreen(
            argument: args,
          ),
        );
      case Routes.verifyMobile:
        return MaterialPageRoute(
          builder: (_) => VerifyMobileScreen(
            argument: args,
          ),
        );
      case Routes.thankYou:
        return MaterialPageRoute(
          builder: (_) => const ThankYouScreen(),
        );
      case Routes.request:
        return MaterialPageRoute(
          builder: (_) => const RequestScreen(),
        );
      case Routes.requestSuccess:
        return MaterialPageRoute(
          builder: (_) => const LoanRequestSuccess(),
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
