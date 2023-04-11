import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/details.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/request.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/request_success.dart';
import 'package:dialup_mobile_app/presentation/screens/business/thank_you.dart';
import 'package:dialup_mobile_app/presentation/screens/create_password.dart';
import 'package:dialup_mobile_app/presentation/screens/error_screen.dart';
import 'package:dialup_mobile_app/presentation/screens/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/application/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/deposits/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/insights.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/terms_and_conditions.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/transfer/index.dart';
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
      case Routes.loanDetails:
        return MaterialPageRoute(
          builder: (_) => const LoanDetailsScreen(),
        );
      case Routes.applicationAddress:
        return MaterialPageRoute(
          builder: (_) => const ApplicationAddressScreen(),
        );
      case Routes.applicationIncome:
        return MaterialPageRoute(
          builder: (_) => const ApplicationIncomeScreen(),
        );
      case Routes.applicationTaxFATCA:
        return MaterialPageRoute(
          builder: (_) => const ApplicationTaxFATCAScreen(),
        );
      case Routes.applicationTaxCRS:
        return MaterialPageRoute(
          builder: (_) => const ApplicationTaxCRSScreen(),
        );
      case Routes.applicationAccount:
        return MaterialPageRoute(
          builder: (_) => const ApplicationAccountScreen(),
        );
      case Routes.termsAndConditions:
        return MaterialPageRoute(
          builder: (_) => TermsAndConditionsScreen(
            argument: args,
          ),
        );
      case Routes.errorScreen:
        return MaterialPageRoute(
          builder: (_) => ErrorScreen(
            argument: args,
          ),
        );
      case Routes.interestRates:
        return MaterialPageRoute(
          builder: (_) => const InterestRatesScreen(),
        );
      case Routes.createDeposits:
        return MaterialPageRoute(
          builder: (_) => const CreateDepositsScreen(),
        );
      case Routes.depositConfirmation:
        return MaterialPageRoute(
          builder: (_) => const DepositConfirmationScreen(),
        );
      case Routes.depositDetails:
        return MaterialPageRoute(
          builder: (_) => const DepositDetailsScreen(),
        );
      case Routes.prematureWithdrawal:
        return MaterialPageRoute(
          builder: (_) => const PrematureWithdrawalScreen(),
        );
      case Routes.depositStatement:
        return MaterialPageRoute(
          builder: (_) => const DepositStatementScreen(),
        );
      case Routes.insights:
        return MaterialPageRoute(
          builder: (_) => const InsightsScreen(),
        );
      case Routes.transferDetails:
        return MaterialPageRoute(
          builder: (_) => const TransferDetailsScreen(),
        );
      case Routes.sendMoney:
        return MaterialPageRoute(
          builder: (_) => const SendMoneyScreen(),
        );
      case Routes.sendMoneyFrom:
        return MaterialPageRoute(
          builder: (_) => const SendMoneyFromScreen(),
        );
      case Routes.sendMoneyTo:
        return MaterialPageRoute(
          builder: (_) => const SendMoneyToScreen(),
        );
      case Routes.transferConfirmation:
        return MaterialPageRoute(
          builder: (_) => const TransferConfirmationScreen(),
        );
      case Routes.transferAmount:
        return MaterialPageRoute(
          builder: (_) => const TransferAmountScreen(),
        );
      case Routes.selectRecipient:
        return MaterialPageRoute(
          builder: (_) => const SelectRecipientScreen(),
        );
      case Routes.recipientDetails:
        return MaterialPageRoute(
          builder: (_) => const RecipientDetailsScreen(),
        );
      case Routes.selectCountry:
        return MaterialPageRoute(
          builder: (_) => const SelectCountryScreen(),
        );
      case Routes.password:
        return MaterialPageRoute(
          builder: (_) => const PasswordScreen(),
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
