import 'package:dialup_mobile_app/data/models/arguments/error.dart';
import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:dialup_mobile_app/utils/helpers/biometric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:local_auth/local_auth.dart';

class TransferConfirmationScreen extends StatefulWidget {
  const TransferConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<TransferConfirmationScreen> createState() =>
      _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState
    extends State<TransferConfirmationScreen> {
  List<DetailsTileModel> transferConfirmation = [
    DetailsTileModel(key: "From", value: "11015346101"),
    DetailsTileModel(key: "To", value: "11015346102"),
    DetailsTileModel(key: "You Send", value: "USD 1,000"),
    DetailsTileModel(key: "You Receive", value: "USD 343"),
    DetailsTileModel(key: "Exchange Rate", value: " 1 AED = 0.34303 USD"),
    DetailsTileModel(key: "Fees", value: "AED 0.00"),
    DetailsTileModel(key: "Transfer Date", value: "Today"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: (22 / Dimensions.designWidth).w,
              top: (20 / Dimensions.designWidth).w,
            ),
            child: Text(
              "Cancel",
              style: TextStyles.primary.copyWith(
                color: const Color.fromRGBO(65, 65, 65, 0.5),
                fontSize: (16 / Dimensions.designWidth).w,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    "Transfer Confirmation",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Please review the transfer details and click proceed to confirm",
                    style: TextStyles.primaryMedium.copyWith(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: transferConfirmation.length,
                      details: transferConfirmation,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: biometricPrompt,
                  text: "Transfer",
                ),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void biometricPrompt() async {
    bool isBiometricSupported = await LocalAuthentication().isDeviceSupported();
    if (!isBiometricSupported) {
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.password);
      }
    } else {
      bool isAuthenticated = await BiometricHelper.authenticateUser();
      if (isAuthenticated) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.errorScreen,
            arguments: ErrorArgumentModel(
              hasSecondaryButton: true,
              iconPath: ImageConstants.checkCircleOutlined,
              title: "Success!",
              message:
                  "Your transaction has been completed\n\nTransfer reference: 254455588800",
              buttonText: "Home",
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonTextSecondary: "Make another transaction",
              onTapSecondary: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).toMap(),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Biometric Authentication failed.',
                style: TextStyles.primary.copyWith(
                  fontSize: (12 / Dimensions.designWidth).w,
                ),
              ),
            ),
          );
        }
      }
    }
  }
}
