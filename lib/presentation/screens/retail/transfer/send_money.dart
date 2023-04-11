import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/recent_transfers_tile.dart';
import 'package:dialup_mobile_app/presentation/widgets/transfer/send_money_tile.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (22 / Dimensions.designWidth).w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizeBox(height: 10),
                Text(
                  "Send Money",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.primary,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 30),
                SendMoneyTile(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sendMoneyFrom);
                  },
                  iconPath: ImageConstants.moveDown,
                  text: "Between Accounts",
                ),
                const SizeBox(height: 10),
                SendMoneyTile(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.selectRecipient);
                  },
                  iconPath: ImageConstants.accountBalance,
                  text: "Within Dhabi Account",
                ),
                const SizeBox(height: 10),
                SendMoneyTile(
                  onTap: () {},
                  iconPath: ImageConstants.flagCircle,
                  text: "Within UAE",
                ),
                const SizeBox(height: 10),
                SendMoneyTile(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.selectCountry);
                  },
                  iconPath: ImageConstants.public,
                  text: "Foreign Currency Transfer",
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.50,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Stack(
                children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: (10 / Dimensions.designWidth).w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((20 / Dimensions.designWidth).w),
                      ),
                      boxShadow: [BoxShadows.primary],
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 51,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizeBox(height: 50);
                        }
                        return RecentTransferTile(
                          onTap: () {},
                          name: "Sanjay Talreja",
                          status: "Pending",
                          amount: 50000,
                          currency: "AED",
                          cardNo: "5040098712342534",
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 44.w,
                    top: (10 / Dimensions.designWidth).w,
                    child: IgnorePointer(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: (10 / Dimensions.designWidth).w,
                        ),
                        height: (7 / Dimensions.designWidth).w,
                        width: (50 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((10 / Dimensions.designWidth).w),
                          ),
                          color: const Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (22 / Dimensions.designWidth).w,
                    top: (25 / Dimensions.designWidth).w,
                    child: IgnorePointer(
                      child: Text(
                        "Recent Transactions",
                        style: TextStyles.primary.copyWith(
                          color: const Color.fromRGBO(9, 9, 9, 0.4),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
