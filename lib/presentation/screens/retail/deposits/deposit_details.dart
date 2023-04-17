import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DepositDetailsScreen extends StatefulWidget {
  const DepositDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DepositDetailsScreen> createState() => _DepositDetailsScreenState();
}

class _DepositDetailsScreenState extends State<DepositDetailsScreen> {
  List<DetailsTileModel> depositDetails = [
    DetailsTileModel(key: "Deposit Account No.", value: "235437484001"),
    DetailsTileModel(key: "Deposit Amount", value: "USD 10,000.00"),
    DetailsTileModel(key: "Tenure", value: "13 months and 3 days"),
    DetailsTileModel(key: "Interest Rate", value: "6.10%"),
    DetailsTileModel(key: "Interest Amount", value: "USD 300"),
    DetailsTileModel(key: "Interest Payout", value: "On maturity"),
    DetailsTileModel(key: "Maturity Date", value: "9 November, 2023"),
    DetailsTileModel(key: "Maturity Amount", value: "USD 10,300.00"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (15 / Dimensions.designWidth).w,
              vertical: (15 / Dimensions.designWidth).w,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.downloadStatement);
              },
              child: SvgPicture.asset(ImageConstants.statement),
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
                  Text(
                    "Deposit Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Below are the details of your exisitng term deposit",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.grey40,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: depositDetails.length,
                      details: depositDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SolidButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Are you sure?",
                          message:
                              "Penal rate will apply in case of premature withdrawal.",
                          auxWidget: const SizeBox(),
                          actionWidget: Column(
                            children: [
                              GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, Routes.prematureWithdrawal);
                                },
                                text: "Yes, I am sure",
                              ),
                              const SizeBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  text: "Premature Withdrawal",
                  color: const Color.fromRGBO(34, 97, 105, 0.17),
                  fontColor: AppColors.primary,
                ),
                const SizeBox(height: 20),
                GradientButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.depositStatement);
                  },
                  text: "View Statement",
                ),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
