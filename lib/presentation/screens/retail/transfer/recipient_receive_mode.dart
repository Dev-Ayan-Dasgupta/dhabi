import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/recipient_receive_mode_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class RecipientReceiveModeScreen extends StatefulWidget {
  const RecipientReceiveModeScreen({Key? key}) : super(key: key);

  @override
  State<RecipientReceiveModeScreen> createState() =>
      _RecipientReceiveModeScreenState();
}

class _RecipientReceiveModeScreenState
    extends State<RecipientReceiveModeScreen> {
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
              onTap: () {},
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
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text(
                  "View Rate",
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
