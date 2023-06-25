// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/recipient_receive_mode_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';

class RecipientReceiveModeScreen extends StatefulWidget {
  const RecipientReceiveModeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RecipientReceiveModeScreen> createState() =>
      _RecipientReceiveModeScreenState();
}

class _RecipientReceiveModeScreenState
    extends State<RecipientReceiveModeScreen> {
  late SendMoneyArgumentModel sendMoneyArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    sendMoneyArgument =
        SendMoneyArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

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
              labels[166]["labelText"],
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
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizeBox(height: 10),
            Text(
              "How would your recipient like to receive the money?",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.primary,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            RecipientReceiveModeTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.addRecipDetRem,
                  arguments: SendMoneyArgumentModel(
                    isBetweenAccounts: sendMoneyArgument.isBetweenAccounts,
                    isWithinDhabi: sendMoneyArgument.isWithinDhabi,
                    isRemittance: sendMoneyArgument.isRemittance,
                  ).toMap(),
                );
              },
              title: "To Bank",
              limitAmount: 10000,
              limitCurrency: "EUR",
              feeAmount: 10,
              feeCurrency: "USD",
              eta: 2,
            ),
            const SizeBox(height: 20),
            RecipientReceiveModeTile(
              onTap: () {},
              title: "To Digital Wallet",
              limitAmount: 20000,
              limitCurrency: "EUR",
              feeAmount: 20,
              feeCurrency: "USD",
              eta: 0,
            ),
            const SizeBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {},
                child: Text(
                  "View Exchange Rates",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: (16 / Dimensions.designWidth).w,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
