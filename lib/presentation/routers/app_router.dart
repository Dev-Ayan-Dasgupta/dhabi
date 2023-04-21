import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/basic_company_details/basic_company_details.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/capture_face.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/accountDetails/download_statement.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/application/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/cardsVault/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/deposits/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dormant/dormant.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/insights.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/notifications/notifications.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/onboardingStatus/onboarding_status.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/profile/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/terms_and_conditions.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/transfer/index.dart';
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
      case Routes.exploreDashboard:
        return MaterialPageRoute(
          builder: (_) => const ExploreDashboardScreen(),
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
      case Routes.retailOnboardingStatus:
        return MaterialPageRoute(
          builder: (_) => RetailOnboardingStatusScreen(
            argument: args,
          ),
        );
      case Routes.businessOnboardingStatus:
        return MaterialPageRoute(
          builder: (_) => const BusinessOnboardingStatusScreen(),
        );
      case Routes.basicCompanyDetails:
        return MaterialPageRoute(
          builder: (_) => const BasicCompanyDetailsScreen(),
        );
      case Routes.captureFace:
        return MaterialPageRoute(
          builder: (_) => const CaptureFaceScreen(),
        );
      case Routes.finalImage:
        return MaterialPageRoute(
          builder: (_) => FinalFaceImageScreen(
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
      case Routes.errorSuccessScreen:
        return MaterialPageRoute(
          builder: (_) => ErrorSuccessScreen(
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
      case Routes.recipientReceiveMode:
        return MaterialPageRoute(
          builder: (_) => const RecipientReceiveModeScreen(),
        );
      case Routes.addRecipDetRem:
        return MaterialPageRoute(
          builder: (_) => const AddRecipientDetailsRemittanceScreen(),
        );
      case Routes.addRecipDetUae:
        return MaterialPageRoute(
          builder: (_) => const AddRecipientDetailsUaeScreen(),
        );
      case Routes.password:
        return MaterialPageRoute(
          builder: (_) => const PasswordScreen(),
        );
      case Routes.downloadStatement:
        return MaterialPageRoute(
          builder: (_) => const DownloadStatementScreen(),
        );
      case Routes.vault:
        return MaterialPageRoute(
          builder: (_) => const VaultScreen(),
        );
      case Routes.actions:
        return MaterialPageRoute(
          builder: (_) => const ActionsScreen(),
        );
      case Routes.profileHome:
        return MaterialPageRoute(
          builder: (_) => const ProfileHomeScreen(),
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case Routes.selectAccount:
        return MaterialPageRoute(
          builder: (_) => const SelectAccountScreen(),
        );
      case Routes.security:
        return MaterialPageRoute(
          builder: (_) => const SecurityScreen(),
        );
      case Routes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePassword(),
        );
      case Routes.faq:
        return MaterialPageRoute(
          builder: (_) => const FaqScreen(),
        );
      case Routes.requestType:
        return MaterialPageRoute(
          builder: (_) => const RequestTypeScreen(),
        );
      case Routes.updateAddress:
        return MaterialPageRoute(
          builder: (_) => const UpdateAddressScreen(),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificatonsScreen(),
        );
      case Routes.businessDepositDetails:
        return MaterialPageRoute(
          builder: (_) => const BusinessDepositDetailsScreen(),
        );
      case Routes.explore:
        return MaterialPageRoute(
          builder: (_) => const ExploreScreen(),
        );
      case Routes.dormant:
        return MaterialPageRoute(
          builder: (_) => const DormantScreen(),
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
