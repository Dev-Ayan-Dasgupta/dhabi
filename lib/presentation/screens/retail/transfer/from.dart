import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/vault_account_card.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SendMoneyFromScreen extends StatefulWidget {
  const SendMoneyFromScreen({Key? key}) : super(key: key);

  @override
  State<SendMoneyFromScreen> createState() => _SendMoneyFromScreenState();
}

class _SendMoneyFromScreenState extends State<SendMoneyFromScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (22 / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
            Text(
              "From",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            VaultAccountCard(
              isVault: true,
              onTap: () {
                Navigator.pushNamed(context, Routes.sendMoneyTo);
              },
              title: "Vault",
              imgUrl:
                  "https://w7.pngwing.com/pngs/23/320/png-transparent-mastercard-credit-card-visa-payment-service-mastercard-company-orange-logo.png",
              accountNo: "1234567890987654",
              currency: "AED",
              amount: 25000,
            ),
            const SizeBox(height: 30),
            Text(
              "Accounts",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (18 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            VaultAccountCard(
              isVault: false,
              onTap: () {},
              title: "Current",
              accountNo: "0987654321098",
              currency: "USD",
              amount: 10000,
            ),
            const SizeBox(height: 10),
            VaultAccountCard(
              isVault: false,
              onTap: () {},
              title: labels[92]["labelText"],
              accountNo: "1098234571629834",
              currency: "USD",
              amount: 10000,
            ),
          ],
        ),
      ),
    );
  }
}
