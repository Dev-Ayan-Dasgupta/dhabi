import 'package:dialup_mobile_app/data/models/index.dart';
import 'package:dialup_mobile_app/presentation/widgets/core/index.dart';
import 'package:dialup_mobile_app/utils/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class TransferDetailsScreen extends StatefulWidget {
  const TransferDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TransferDetailsScreen> createState() => _TransferDetailsScreenState();
}

class _TransferDetailsScreenState extends State<TransferDetailsScreen> {
  List<DetailsTileModel> transferDetails = [
    DetailsTileModel(key: "Status", value: "Success"),
    DetailsTileModel(key: "Recipient", value: "Sanjay Talreja"),
    DetailsTileModel(key: "Delivery", value: "To account **2008"),
    DetailsTileModel(key: "You Send", value: "AED 15,000.00"),
    DetailsTileModel(key: "They Receive", value: "AED 50,000.00"),
    DetailsTileModel(key: "Exchange Rate", value: "1 USD = 0.9499 EUR"),
    DetailsTileModel(key: "Fees", value: "USD 5.00"),
    DetailsTileModel(key: "Transfer Date", value: "12 December 2022"),
  ];

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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizeBox(height: 10),
                  Text(
                    "Transfer Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.primary,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Expanded(
                    child: DetailsTile(
                      length: transferDetails.length,
                      details: transferDetails,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(onTap: () {}, text: "Repeat Transfer"),
                const SizeBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
